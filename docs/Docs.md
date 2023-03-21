- Builtin consts

| Const | kind  | value       |
| ----- | ----- | ----------- |
| null  | Value | void* 0     |
| false | Value | bool 0      |
| true  | Value | bool 1      |
| void  | Type  |             |
| bool  | Type  | 1 bit int   |
| i8    | Type  | 8 bit int   |
| i16   | Type  | 16 bit int  |
| i32   | Type  | 32 bit int  |
| i64   | Type  | 64 bit int  |
| u8    | Type  | 8 bit uint  |
| u16   | Type  | 16 bit uint |
| u32   | Type  | 32 bit uint |
| u64   | Type  | 64 bit uint |
| f32   | Type  | float       |
| f64   | Type  | double      |
- Proc Structure
```
def main proc [input] : [output] {
	...
}
```