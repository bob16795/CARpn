#include "llvm/ADT/APFloat.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/LegacyPassManager.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Verifier.h"
#include "llvm/Support/TargetSelect.h"
#include "llvm/Target/TargetMachine.h"
#include "llvm/Transforms/InstCombine/InstCombine.h"
#include "llvm/Transforms/Scalar.h"
#include "llvm/Transforms/Scalar/GVN.h"
#include "./jit.h"

using namespace llvm;
using namespace llvm::orc;

#include <utility>
#include <string>
#include <map>
#include <vector>
#include <memory>

enum Token {
  // control
  tok_null = 0,
  tok_eof = -1,

  tok_extern = -2,

  // block
  tok_def = -3,
  tok_proc = -4,
  tok_if = -5,
  tok_var = -6,

  // intrinsics
  tok_number = -7,
  tok_ident = -8,
};

static std::string IdentifierStr; // Filled in if tok_identifier
static double NumVal;             // Filled in if tok_number
static std::unique_ptr<AbsJIT> TheJIT;
static std::unique_ptr<legacy::FunctionPassManager> TheFPM;
static ExitOnError ExitOnErr;

static int gettok() {
  static int LastChar = ' ';

  // Skip any whitespace.
  while (isspace(LastChar))
    LastChar = getchar();

  if (isalpha(LastChar)) { // identifier: [a-zA-Z][a-zA-Z0-9]*
    IdentifierStr = LastChar;
    while (isalnum((LastChar = getchar())))
      IdentifierStr += LastChar;

    if (IdentifierStr == "proc")
      return tok_proc;
    if (IdentifierStr == "var")
      return tok_var;
    if (IdentifierStr == "def")
      return tok_def;
    if (IdentifierStr == "if")
      return tok_if;
    if (IdentifierStr == "extern")
      return tok_extern;
    return tok_ident;
  }

  if (isdigit(LastChar) || LastChar == '.') {   // Number: [0-9.]+
    std::string NumStr;
    do {
      NumStr += LastChar;
      LastChar = getchar();
    } while (isdigit(LastChar) || LastChar == '.');

    NumVal = strtod(NumStr.c_str(), 0);
    return tok_number;
  }

  if (LastChar == '#') {
    // Comment until end of line.
    do
      LastChar = getchar();
    while (LastChar != EOF && LastChar != '\n' && LastChar != '\r');

    if (LastChar != EOF)
      return gettok();
  }

  // Check for end of file.  Don't eat the EOF.
  if (LastChar == EOF) {
    return tok_eof;
  }

  // Otherwise, just return the character as its ascii value.
  int ThisChar = LastChar;
  LastChar = getchar();
  return ThisChar;
}

/// ExprAST - Base class for all expression nodes.
class ExprAST {
public:
  virtual ~ExprAST() = default;
  virtual void codegen(std::vector<Value *> *values) {
  };
};

/// NumberExprAST - Expression class for numeric literals like "1.0".
class NumberExprAST : public ExprAST {
  double Val;

public:
  NumberExprAST(double Val) : Val(Val) {}
  void codegen(std::vector<Value *> *values) override;
};

/// VariableExprAST - Expression class for referencing a variable, like "a".
class VariableExprAST : public ExprAST {
  std::string Name;

public:
  VariableExprAST(const std::string &Name) : Name(Name) {}

  void codegen(std::vector<Value *> *values) override;
  const std::string &getName() const { return Name; }
};

/// NumberExprAST - Expression class for numeric literals like "1.0".
class IdentExprAST : public ExprAST {
  std::string Ident;

public:
  IdentExprAST(std::string Ident) : Ident(std::move(Ident)) {}
  void codegen(std::vector<Value *> *values) override;
};

/// BlockExprAST - Expression class for numeric literals like "1.0".
class BlockExprAST : public ExprAST {
  std::vector<std::unique_ptr<ExprAST>> Ops;

public:
  BlockExprAST(std::vector<std::unique_ptr<ExprAST>> Ops) : Ops(std::move(Ops)) {}
  void codegen(std::vector<Value *> *values) override;
};

/// OpExprAST - Expression class for numeric literals like "1.0".
class OpExprAST : public ExprAST {
  char Op;

public:
  OpExprAST(char Op) : Op(Op) {}
  void codegen(std::vector<Value *> *values) override;
};


/// IfExprAST - This class represents a function definition itself.
class IfExprAST : public ExprAST {
  std::unique_ptr<ExprAST> Body;

public:
  IfExprAST(std::unique_ptr<ExprAST> Body)
    : Body(std::move(Body)) {}
  void codegen(std::vector<Value *> *values) override;
};


/// PrototypeAST - This class represents the "prototype" for a function,
/// which captures its name, and its argument names (thus implicitly the number
/// of arguments the function takes).
class PrototypeAST {
  std::string Name;
  int In;

public:
  PrototypeAST(const std::string &Name, int In)
    : Name(Name), In(In) {}

  const std::string &getName() const { return Name; }
  Function *codegen();
};

static std::map<std::string, std::unique_ptr<PrototypeAST>> FunctionProtos;

/// FunctionAST - This class represents a function definition itself.
class ProcAST {
  std::unique_ptr<PrototypeAST> Proto;
  std::unique_ptr<ExprAST> Body;

public:
  ProcAST(std::unique_ptr<PrototypeAST> Proto,
              std::unique_ptr<ExprAST> Body)
    : Proto(std::move(Proto)), Body(std::move(Body)) {}
  Function *codegen();
};

// code gen

static std::unique_ptr<LLVMContext> TheContext;
static std::unique_ptr<Module> TheModule;
static std::unique_ptr<IRBuilder<>> Builder;
static std::map<std::string, AllocaInst*> NamedValues;

/// CreateEntryBlockAlloca - Create an alloca instruction in the entry block of
/// the function.  This is used for mutable variables etc.
static AllocaInst *CreateEntryBlockAlloca(Function *TheFunction,
                                          const std::string &VarName) {
  IRBuilder<> TmpB(&TheFunction->getEntryBlock(),
                 TheFunction->getEntryBlock().begin());
  return TmpB.CreateAlloca(Type::getDoubleTy(*TheContext), nullptr,
                           VarName);
}

void NumberExprAST::codegen(std::vector<Value *> *values) {
  values->push_back(ConstantFP::get(*TheContext, APFloat(Val)));
}

void BinOpCodegen(std::vector<Value *> *values, char Op) {
  Value *R = values->back();
  values->pop_back();
  Value *L = values->back();
  values->pop_back();
  switch (Op) {
    case '+':
      values->push_back(Builder->CreateFAdd(L, R, "addtmp"));
      break;
    case '=':
      Builder->CreateStore(R, L);
      break;
    case '-':
      values->push_back(Builder->CreateFSub(L, R, "subtmp"));
      break;
  }
}

Value *ReadValue(Value *Val) {
  if (AllocaInst *A = static_cast<AllocaInst*>(Val)) {
    return Builder->CreateLoad(A->getAllocatedType(), A, "readtmp");
  }

  return nullptr;
}

void UnOpCodegen(std::vector<Value *> *values, char Op) {
  Value *Val = values->back();
  values->pop_back();
  switch (Op) {
    case '@':
      values->push_back(ReadValue(Val));
      break;
  }
}

void OpExprAST::codegen(std::vector<Value *> *values) {
  switch (Op) {
    case '+':
      BinOpCodegen(values, Op);
      break;
    case '=':
      BinOpCodegen(values, Op);
      break;
    case '-':
      BinOpCodegen(values, Op);
      break;
    case '@':
      UnOpCodegen(values, Op);
      break;
  }
}

void BlockExprAST::codegen(std::vector<Value *> *values) {
  for (auto &Operation : Ops) {
    Operation->codegen(values);
  }
}

void VariableExprAST::codegen(std::vector<Value *> *values) {
  Function *TheFunction = Builder->GetInsertBlock()->getParent();

  // Register all variables and emit their initializer.
  const std::string &VarName = Name;

  // Emit the initializer before adding the variable to scope, this prevents
  // the initializer from referencing the variable itself, and permits stuff
  // like this:
  //  var a = 1 in
  //    var a = a in ...   # refers to outer 'a'.
  AllocaInst *Alloca = CreateEntryBlockAlloca(TheFunction, VarName);

  // Remember this binding.
  NamedValues[VarName] = Alloca;

  // Return the body computation.
  values->push_back(Alloca);
}

void IfExprAST::codegen(std::vector<Value *> *values) {
  Value *CondV = values->back();
  values->pop_back();

  // Convert condition to a bool by comparing non-equal to 0.0.
  CondV = Builder->CreateFCmpONE(
      CondV, ConstantFP::get(*TheContext, APFloat(0.0)), "ifcond");

  Function *TheFunction = Builder->GetInsertBlock()->getParent();

  // Create blocks for the then and else cases.  Insert the 'then' block at the
  // end of the function.
  BasicBlock *HeadBB =
    BasicBlock::Create(*TheContext, "ifhead", TheFunction);
  BasicBlock *BodyBB =
    BasicBlock::Create(*TheContext, "ifbody", TheFunction);
  BasicBlock *MergeBB =
    BasicBlock::Create(*TheContext, "ifcont", TheFunction);

  Builder->CreateBr(HeadBB);

  Builder->SetInsertPoint(HeadBB);

  Builder->CreateCondBr(CondV, BodyBB, MergeBB);

  Builder->SetInsertPoint(BodyBB);

  std::vector<Value *> values_copy = *values;
  Body->codegen(&values_copy);
  if (values_copy.size() != values->size()) {
    return;
  }

  Builder->CreateBr(MergeBB);

  Builder->SetInsertPoint(MergeBB);
  std::vector<Value *> old_values = *values;
  values->resize(0);
  for (unsigned long i = 0; i < old_values.size(); i++) {
    if (old_values[i] == values_copy[i]) {
      values->push_back(old_values[i]);
      continue;
    };

    std::string name = "if__a";
    name[4] += i;

    PHINode *Arg = Builder->CreatePHI(Type::getDoubleTy(*TheContext), 2, name);
    Arg->addIncoming(old_values[i], HeadBB);
    Arg->addIncoming(values_copy[i], BodyBB);

    values->push_back(Arg);
  }
}

Function *getFunction(std::string Name) {
  // First, see if the function has already been added to the current module.
  if (auto *F = TheModule->getFunction(Name))
    return F;

  // If not, check whether we can codegen the declaration from some existing
  // prototype.
  auto FI = FunctionProtos.find(Name);
  if (FI != FunctionProtos.end())
    return FI->second->codegen();

  // If no existing prototype exists, return null.
  return nullptr;
}

void IdentExprAST::codegen(std::vector<Value *> *values) {
  if (Ident == "copy") {
    values->push_back(values->back());
  } else if (Ident == "covr") {
    values->push_back((*values)[values->size() - 2]);
  } else if (Ident == "swap") {
    auto A = values->back();
    values->pop_back();
    auto B = values->back();
    values->pop_back();
    values->push_back(A);
    values->push_back(B);
  } else if (Ident == "disc") {
    values->pop_back();
  } else if (Function *CalleeF = getFunction(Ident)) {

    auto start = values->begin() + values->size() - CalleeF->arg_size();
    auto end = values->begin() + values->size();

    std::vector<Value *> ArgsV(CalleeF->arg_size());
    copy(start, end, ArgsV.begin());

    values->resize(values->size() - ArgsV.size());

    values->push_back(Builder->CreateCall(CalleeF, std::move(ArgsV), "calltmp"));

    return;
  } else if (auto Value = NamedValues[Ident]){
    values->push_back(Value);

    return;
  } else {
    fprintf(stderr, "Bad ident %s", Ident.c_str());
    exit(0);
  }
}

Function *PrototypeAST::codegen() {
  // Make the function type:  double(double,double) etc.
  std::vector<Type*> Doubles(In,
                             Type::getDoubleTy(*TheContext));
  FunctionType *FT =
    FunctionType::get(Type::getDoubleTy(*TheContext), Doubles, false);

  Function *F =
    Function::Create(FT, Function::ExternalLinkage, Name, TheModule.get());

  // Set names for all arguments.
  unsigned Idx = 0;
  for (auto &Arg : F->args()) {
    std::string name = "__a";
    name[2] += Idx++;
    Arg.setName(name);
  }

  return F;
}

Function *ProcAST::codegen() {
  auto &P = *Proto;
  FunctionProtos[Proto->getName()] = std::move(Proto);
  Function *TheFunction = TheModule->getFunction(P.getName());

  if (!TheFunction)
    TheFunction = P.codegen();

  if (!TheFunction)
    return nullptr;

  // Create a new basic block to start insertion into.
  BasicBlock *BB = BasicBlock::Create(*TheContext, "entry", TheFunction);
  Builder->SetInsertPoint(BB);

  // Record the function arguments in the NamedValues map.
  std::vector<Value*> values;

  for (auto &Arg : TheFunction->args())
    values.push_back(&Arg);

  Body->codegen(&values);

  if (values.size() == 1) {
    // Finish off the function.
    Builder->CreateRet(values[0]);

    // Validate the generated code, checking for consistency.
    verifyFunction(*TheFunction);

    return TheFunction;
  }

  printf("bad function %s", P.getName().c_str());

  // Error reading body, remove function.
  TheFunction->eraseFromParent();
  return nullptr;
}

/// CurTok/getNextToken - Provide a simple token buffer.  CurTok is the current
/// token the parser is looking at.  getNextToken reads another token from the
/// lexer and updates CurTok with its results.
static int CurTok;
static int getNextToken() {
  return CurTok = gettok();
}

/// LogError* - These are little helper functions for error handling.
std::unique_ptr<ExprAST> LogError(const char *Str) {
  fprintf(stderr, "Error: %s\n", Str);
  return nullptr;
}
std::unique_ptr<PrototypeAST> LogErrorP(const char *Str) {
  LogError(Str);
  return nullptr;
}

// forward
static std::unique_ptr<ExprAST> ParseNumberExpr();
static std::unique_ptr<ExprAST> ParseBlockExpr();
static std::unique_ptr<ExprAST> ParseIdentExpr();
static std::unique_ptr<ExprAST> ParseIfExpr();
static std::unique_ptr<ExprAST> ParseVarExpr();
static std::unique_ptr<ExprAST> ParseExpression();
static std::unique_ptr<PrototypeAST> ParsePrototype();
static std::unique_ptr<PrototypeAST> ParseExtern();
static std::unique_ptr<ProcAST> ParseDefinition();

/// pushexpr ::= number
static std::unique_ptr<ExprAST> ParseNumberExpr() {
  auto Result = std::make_unique<NumberExprAST>(NumVal);
  getNextToken(); // consume the number
  return std::move(Result);
}

/// pushexpr ::= number
static std::unique_ptr<ExprAST> ParseIdentExpr() {
  auto Result = std::make_unique<IdentExprAST>(std::move(IdentifierStr));
  getNextToken(); // consume the number
  return std::move(Result);
}

/// blockexpr ::= '{' expression '}'
static std::unique_ptr<ExprAST> ParseBlockExpr() {
  getNextToken(); // eat {.

  std::vector<std::unique_ptr<ExprAST>> vals;
  while (true) {
    if (CurTok == '}') break;
    auto V = ParseExpression();
    if (!V) break;
    vals.push_back(std::move(V));
  };

  if (CurTok != '}')
    return LogError("expected '}'");
  getNextToken(); // eat }.

  return std::make_unique<BlockExprAST>(std::move(vals));
}

static std::unique_ptr<ExprAST> ParseOp() {
  char tok = CurTok;
  getNextToken(); // eat oper

  return std::make_unique<OpExprAST>(std::move(tok));
}

static std::unique_ptr<ExprAST> ParseVarExpr() {
  getNextToken(); // eat var

  return std::make_unique<VariableExprAST>(std::move(IdentifierStr));
}

/// expression
static std::unique_ptr<ExprAST> ParseExpression() {
  switch (CurTok) {
    default:
      return LogError("unknown token when expecting an expression");
    case tok_var:
      return ParseVarExpr();
    case tok_if:
      return ParseIfExpr();
    case tok_number:
      return ParseNumberExpr();
    case tok_ident:
      return ParseIdentExpr();
    case '+':
      return ParseOp();
    case '=':
      return ParseOp();
    case '-':
      return ParseOp();
    case '@':
      return ParseOp();
    case '{':
      return ParseBlockExpr();
  }
}

/// prototype
///   ::= proc id num num
static std::unique_ptr<PrototypeAST> ParsePrototype() {
  if (CurTok != tok_proc)
    return LogErrorP("Expected proc in prototype");
  getNextToken(); // eat proc

  if (CurTok != tok_ident)
    return LogErrorP("Expected function name in prototype");

  std::string FnName = IdentifierStr;
  getNextToken();

  // Read the list of argument names.
  int In = NumVal;
  getNextToken();

  return std::make_unique<PrototypeAST>(FnName, In);
}

/// procexpr ::= `def` prototype expr
static std::unique_ptr<ProcAST> ParseDefinition() {
  getNextToken();  // eat def

  auto Proto = ParsePrototype();
  if (!Proto) return nullptr;

  if (auto E = ParseExpression())
    return std::make_unique<ProcAST>(std::move(Proto), std::move(E));
  return nullptr;
}

/// procexpr ::= `if` prototype expr
static std::unique_ptr<ExprAST> ParseIfExpr() {
  getNextToken();  // eat if

  if (auto E = ParseExpression())
    return std::make_unique<IfExprAST>(std::move(E));
  return nullptr;
}

/// external ::= 'extern' prototype
static std::unique_ptr<PrototypeAST> ParseExtern() {
  getNextToken(); // eat extern.
  return ParsePrototype();
}

static void InitializeModuleAndPassManager() {
  // Open a new context and module.
  TheContext = std::make_unique<LLVMContext>();
  TheModule = std::make_unique<Module>("my cool jit", *TheContext);
  TheModule->setDataLayout(TheJIT->getDataLayout());

  // Create a new builder for the module.
  Builder = std::make_unique<IRBuilder<>>(*TheContext);

  // Create a new pass manager attached to it.
  TheFPM = std::make_unique<legacy::FunctionPassManager>(TheModule.get());

  // Do simple "peephole" optimizations and bit-twiddling optzns.
  TheFPM->add(createInstructionCombiningPass());
  // Reassociate expressions.
  TheFPM->add(createReassociatePass());
  // Eliminate Common SubExpressions.
  TheFPM->add(createGVNPass());
  // Simplify the control flow graph (deleting unreachable blocks, etc).
  TheFPM->add(createCFGSimplificationPass());

  TheFPM->doInitialization();
}

static void HandleDefinition() {
  if (auto FnAST = ParseDefinition()) {
    if (auto *FnIR = FnAST->codegen()) {
      //fprintf(stderr, "Read function definition:");
      //FnIR->print(errs());
      //fprintf(stderr, "\n");
      ExitOnErr(TheJIT->addModule(
          ThreadSafeModule(std::move(TheModule), std::move(TheContext))));
      InitializeModuleAndPassManager();
    }
  } else {
    // Skip token for error recovery.
    getNextToken();
  }
}

static void HandleExtern() {
  if (auto ProtoAST = ParseExtern()) {
    if (auto *FnIR = ProtoAST->codegen()) {
      //fprintf(stderr, "Read extern: ");
      //FnIR->print(errs());
      //fprintf(stderr, "\n");
      FunctionProtos[ProtoAST->getName()] = std::move(ProtoAST);
    }
  } else {
    // Skip token for error recovery.
    getNextToken();
  }
}

#ifdef _WIN32
#define DLLEXPORT __declspec(dllexport)
#else
#define DLLEXPORT
#endif

/// putchard - putchar that takes a double and returns 0.
extern "C" DLLEXPORT double putchard(double X) {
  fputc((char)X, stderr);
  return 0;
}

// printd - printf that takes a double prints it as "%f\n", returning 0.
extern "C" DLLEXPORT double printd(double X) {
  fprintf(stderr, "%f\n", X);
  return 0;
}

static int DoneRun() {
  auto RT = TheJIT->getMainJITDylib().createResourceTracker();

  auto TSM = ThreadSafeModule(std::move(TheModule), std::move(TheContext));
  ExitOnErr(TheJIT->addModule(std::move(TSM), RT));
  InitializeModuleAndPassManager();

  // Search the JIT for the __anon_expr symbol.
  auto ExprSymbol = ExitOnErr(TheJIT->lookup("main"));
  assert(ExprSymbol && "Function not found");

  // Get the symbol's address and cast it to the right type (takes no
  // arguments, returns a double) so we can call it as a native function.
  double (*FP)() = (double (*)())(intptr_t)ExprSymbol.getAddress();
  double result = FP();

  // Delete the anonymous expression module from the JIT.
  ExitOnErr(RT->remove());

  return (int)result;
}

static void MainLoop() {
  while (true) {
    switch (CurTok) {
      case tok_eof:
        // Create a ResourceTracker to track JIT'd memory allocated to our
        // anonymous expression -- that way we can free it after executing.
        exit(DoneRun());
        return;
      case tok_def:
        HandleDefinition();
        break;
      case tok_extern:
        HandleExtern();
        break;
      case ';':
        DoneRun();
        break;
      default:
        fprintf(stderr, "error %s", IdentifierStr.c_str());
        return;
    }
  }
}

int main() {
  InitializeNativeTarget();
  InitializeNativeTargetAsmPrinter();
  InitializeNativeTargetAsmParser();

  // absJit
  TheJIT = ExitOnErr(AbsJIT::Create());

  InitializeModuleAndPassManager();

  // Prime the first token.
  getNextToken();

  MainLoop();

  return 0;
}
