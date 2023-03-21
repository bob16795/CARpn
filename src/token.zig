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
        Op,
        Struct,
        Prop,
        Alias,
    };

    type: Type,
    value: []const u8,
};
