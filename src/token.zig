pub const Token = struct {
    const Type = enum {
        Eof,
        Extern,
        Def,
        Proc,
        If,
        Var,
        Number,
        Ident,
        Op,
        Struct,
        Prop,
    };

    type: Type,
    value: []const u8,
};
