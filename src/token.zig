pub const Token = struct {
    const Type = enum {
        Eof,
        Extern,
        Def,
        Proc,
        If,
        Do,
        Var,
        Number,
        String,
        Ident,
        Op,
        Struct,
        Prop,
        Alias,
    };

    type: Type,
    value: []const u8,
};
