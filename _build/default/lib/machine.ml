open Ast

type minst = int  

let const_minst (constant: const): minst = 
    match constant with 
    | Zero -> 0b0101010
    | One -> 0b0111111
    | MinusOne -> 0b0111010

let unary_minst (unary_op, reg: unary * register): minst = 
    match unary_op, reg with
    | BNeg, A -> 0b0110001
    | BNeg, D -> 0b0001101
    | BNeg, M -> 0b1110001
    | UMinus, A -> 0b0110011
    | UMinus, D -> 0b0001111
    | UMinus, M -> 0b1110011
    | ID, A -> 0b0110000
    | ID, D -> 0b0001100
    | ID, M -> 0b1110000
    | Incr, A -> 0b0110111
    | Incr, D -> 0b0011111
    | Incr, M -> 0b1110111
    | Decr, A -> 0b0110010
    | Decr, D -> 0b0001110
    | Decr, M -> 0b1110010

let binary_minst (binary_op, reg1, reg2: binary * register * register): minst =
    match binary_op, reg1, reg2 with
    | Add, D, A -> 0b0000010
    | Add, D, M -> 0b1000010
    | Sub, D, A -> 0b0010011
    | Sub, D, M -> 0b1010011
    | Sub, A, D -> 0b0000111
    | Sub, M, D -> 0b1000111
    | And, D, A -> 0b0000000
    | And, D, M -> 0b1000000
    | Or, D, A -> 0b0010101
    | Or, D, M -> 0b1010101
    | _ -> failwith "Unsupported binary operation or registers"

let output_minst (output_type: output): minst =
    match output_type with
    | Constant c -> const_minst c
    | UApply (unary_op, reg) -> unary_minst (unary_op, reg)
    | BApply (binary_op, reg1, reg2) -> binary_minst (binary_op, reg1, reg2)

let dest_minst (dest_type: destination): minst =
    match dest_type with
    | [M] -> 0b001
    | [D] -> 0b010
    | [M; D] -> 0b011
    | [A] -> 0b100
    | [A; M] -> 0b101
    | [A; D] -> 0b110
    | [A; D; M] -> 0b111
    | [] -> 0b000
    | _ -> failwith "Unsupported destination registers"

let jump_minst (jump_type: jump option): minst =
    match jump_type with 
    | None -> 0b000
    | Some JGT -> 0b001
    | Some JEQ -> 0b010
    | Some JGE -> 0b011
    | Some JLT -> 0b100
    | Some JLE -> 0b101
    | Some JNE -> 0b110
    | Some JMP -> 0b111

let a_instruction_minst (value: int): minst =
    if value < 0 || value > 32767 then
        failwith "Value out of range for A-instruction (0-32767)"
    else
        value (* Directly return the value for A-instruction *)

let c_instruction_minst (dest: destination) (output: output) (jump: jump option): minst =
    let dest_code = dest_minst dest in
    let output_code = output_minst output in
    let jump_code = jump_minst jump in
    (* Combine dest_code (3 bits), output_code (7 bits), and jump_code (3 bits) *)
    (dest_code lsl 13) lor (output_code lsl 6) lor jump_code

let encode (inst: 'v inst): minst = 
    match inst with
    | At value -> a_instruction_minst value
    | C (dest, output, jump) -> c_instruction_minst dest output jump
    | Label _ -> failwith "Labels cannot be encoded directly"
