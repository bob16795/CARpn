pub const Token = struct {
    const Type = enum {
        Eof,
        Extern,
        Def,
        Proc,
        If,
        Do,
        For,
        Var,
        Number,
        String,
        Macro,
        Ident,
        Bracket,
        Paren,
        Op,
        Struct,
        Prop,
        Lambda,
        Error,
        Func,
    };

    type: Type,
    pos: u64,
    value: []const u8,
};
