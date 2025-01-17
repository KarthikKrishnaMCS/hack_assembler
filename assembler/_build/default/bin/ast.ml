type jump = JGT
           |JEQ
           |JGE
           |JLT
           |JLE
           |JNE
           |JMP
                                                                                                  
type const = Zero | One | MinusOne

type register = A | D | M

type unary = BNeg  | UMinus | ID | Incr | Decr

type binary = Add | Sub | And | Or

type output = 
        |Constant of const
        |UApply of unary * register
        |BApply of binary * register * register

type destination = register list

type label = string

type 'v inst = 
        |At of 'v
        |C of destination *output*jump option
        |Label of label

let string_of_output output =
  match output with
  | Constant Zero -> "0"
  | Constant One -> "1"
  | Constant MinusOne -> "-1"
  | UApply (op, reg) ->
      let op_str = match op with
        | BNeg -> "!"
        | UMinus -> "-"
        | ID -> "ID"
        | Incr -> "++"
        | Decr -> "--"
      in
      Printf.sprintf "%s(%s)" op_str (match reg with A -> "A" | D -> "D" | M -> "M")
  | BApply (op, reg1, reg2) ->
      let op_str = match op with
        | Add -> "+"
        | Sub -> "-"
        | And -> "&"
        | Or -> "|"
      in
      Printf.sprintf "%s(%s, %s)" op_str (match reg1 with A -> "A" | D -> "D" | M -> "M") 
                                         (match reg2 with A -> "A" | D -> "D" | M -> "M")
