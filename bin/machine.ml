open Ast

type minst = int

let const_minst (constant: const): minst = 
    match constant with 
    | Zero -> 0b00101010
    | One -> 0b00111111
    | MinusOne -> 0b00111010

let unary_minst (unary_op, reg: unary * register): minst = 
    match unary_op, reg with
    | BNeg, A -> 0b00110001
    | BNeg, D -> 0b00001101
    | BNeg, M -> 0b01110001
    | UMinus, A -> 0b00110011
    | UMinus, D -> 0b00011111
    | UMinus, M -> 0b01110011
    | ID, A -> 0b00110000
    | ID, D -> 0b00001100
    | ID, M -> 0b01110000
    | Incr, A -> 0b00110111
    | Incr, D -> 0b00011111
    | Incr, M -> 0b01110111
    | Decr, A -> 0b00110010
    | Decr, D -> 0b00001110
    | Decr, M -> 0b01110010

let binary_minst (binary_op, reg1, reg2: binary * register * register): minst =
    match binary_op, reg1, reg2 with
    | Add, D, A -> 0b00000010
    | Add, D, M -> 0b01000010
    | Add, A, D -> 0b00000110
    | Add, M, D -> 0b01000110
    | Sub, D, A -> 0b00100011
    | Sub, D, M -> 0b01010011
    | Sub, A, D -> 0b00000111
    | Sub, M, D -> 0b01000111
    | And, D, A -> 0b00000000
    | And, D, M -> 0b01000000
    | Or, D, A -> 0b00010101
    | Or, D, M -> 0b01010101
    | _ -> failwith "Unsupported binary operation or registers"

let output_minst (output_type: output): minst =
    match output_type with
    | Constant c -> const_minst c
    | UApply (unary_op, reg) -> unary_minst (unary_op, reg)
    | BApply (binary_op, reg1, reg2) -> binary_minst (binary_op, reg1, reg2)

let dest_minst (dest_type: destination): minst =
    let a_bit = if List.mem A dest_type then 0b100 else 0b000 in
    let d_bit = if List.mem D dest_type then 0b010 else 0b000 in
    let m_bit = if List.mem M dest_type then 0b001 else 0b000 in
    a_bit lor d_bit lor m_bit


let jump_minst (jump_type: jump option): minst =
    match jump_type with 
    | None -> 0b00000000
    | Some JGT -> 0b00000001
    | Some JEQ -> 0b00000010
    | Some JGE -> 0b00000011
    | Some JLT -> 0b00000100
    | Some JLE -> 0b00000110
    | Some JNE -> 0b00000101
    | Some JMP -> 0b00000111

let a_instruction_minst (value: int): minst =
    if value < 0 || value > 32767 then
        failwith "Value out of range for A-instruction (0-32767)"
    else
        value  (* Use lower 16 bits for the A-instruction *)

let c_instruction_minst (dest: destination) (output: output) (jump: jump option): minst =
    let dest_code = dest_minst dest in
    let output_code = output_minst output in
    let jump_code = jump_minst jump in
  
    (* Combine the codes into a single int value following the format:
       111 + comp + dest + jump *)
    (0b111 lsl 13) lor (output_code lsl 6) lor (dest_code lsl 3) lor jump_code

let encode (inst: 'v inst): minst = 
    match inst with
    | At value -> a_instruction_minst value
    | C (dest, output, jump) -> c_instruction_minst dest output jump
    | Label _ -> failwith "Labels cannot be encoded directly"