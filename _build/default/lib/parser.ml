open Ast

(* Helper function to parse registers *)
let parse_register reg_str =
  match reg_str with
  | "A" -> A
  | "D" -> D
  | "M" -> M
  | _ -> failwith ("Unsupported register: " ^ reg_str)

(* Parses a single line of assembly code *)
let parse_line line =
  let trimmed = String.trim line in
  if String.length trimmed = 0 then
    raise (Failure "Empty line")
  else if trimmed.[0] = '(' then
    (* Handle labels *)
    let label = String.sub trimmed 1 (String.length trimmed - 2) in
    if String.length label = 0 then
      failwith "Invalid label: Label cannot be empty"
    else
      Label label
  else if trimmed.[0] = '@' then
    (* Handle A-instruction *)
    let value_str = String.sub trimmed 1 (String.length trimmed - 1) in
    let value = int_of_string value_str in
    if value < 0 || value > 32767 then
      failwith "Value out of range for A-instruction (0-32767)"
    else
      At value
  else
    (* Handle C-instruction *)
    let parts = String.split_on_char '=' trimmed in
    match parts with
    | [dest] ->
      let dest_regs = List.map parse_register (String.split_on_char ',' dest) in
      C (dest_regs, Constant Zero, None)  (* Default output and jump *)
    | [dest; rest] ->
      let dest_regs = List.map parse_register (String.split_on_char ',' dest) in

      let output, jump =
        if String.contains rest ';' then
          let output_parts = String.split_on_char ';' rest in
          let output_expr = List.hd output_parts in
          let jump_expr = List.nth output_parts 1 in
          let output = match output_expr with
            | "0" -> Constant Zero
            | "1" -> Constant One
            | "-1" -> Constant MinusOne
            | _ -> failwith ("Unsupported output expression: " ^ output_expr)
          in
          let jump = match jump_expr with
            | "JGT" -> Some JGT
            | "JEQ" -> Some JEQ
            | "JGE" -> Some JGE
            | "JLT" -> Some JLT
            | "JLE" -> Some JLE
            | "JNE" -> Some JNE
            | "JMP" -> Some JMP
            | _ -> None
          in
          (output, jump)
        else
          (Constant Zero, None)  (* Default output if no jump is specified *)
      in
      C (dest_regs, output, jump)
    | _ -> failwith ("Invalid C-instruction format: " ^ trimmed)

(* Parses multiple lines of assembly code *)
let parse_program lines =
  List.map parse_line lines
