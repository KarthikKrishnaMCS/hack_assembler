open Ast
open Hashtbl

(* Mutable hash table for symbol table *)
let symbol_table : (string, int) t = create 16
let next_var_address = ref 16  (* Starting address for user-defined variables *)

(* Initialize the symbol table with predefined symbols *)
let initialize_symbol_table () =
  (* Add predefined registers R0 to R15 *)
  for i = 0 to 15 do
    add symbol_table ("R" ^ string_of_int i) i
  done;
  (* Add predefined symbols *)
  add symbol_table "SP" 0;
  add symbol_table "LCL" 1;
  add symbol_table "ARG" 2;
  add symbol_table "THIS" 3;
  add symbol_table "THAT" 4;
  add symbol_table "SCREEN" 16384;
  add symbol_table "KBD" 24576

(* First pass to collect labels *)
let first_pass lines =
  let instruction_count = ref 0 in
  List.iter (fun line ->
    let trimmed_line = String.trim line in
    if String.length trimmed_line > 0 then (
      if trimmed_line.[0] = '(' then
        let label = String.sub trimmed_line 1 (String.length trimmed_line - 2) in
        add symbol_table label !instruction_count
      else (
        incr instruction_count
      )
    )
  ) lines;
  !instruction_count  (* Return the total number of instructions *)

(* Parse registers, jumps, destination, and output *)
let parse_register reg_str =
  match reg_str with
  | "A" -> A
  | "D" -> D
  | "M" -> M
  | _ -> failwith ("Unsupported register: " ^ reg_str)

let parse_jump jump_str =
  match jump_str with
  | "JGT" -> Some JGT
  | "JEQ" -> Some JEQ
  | "JGE" -> Some JGE
  | "JLT" -> Some JLT
  | "JLE" -> Some JLE
  | "JNE" -> Some JNE
  | "JMP" -> Some JMP
  | _ -> None

let parse_dest dest_str =
  let rec parse acc chars =
    match chars with
    | [] -> List.rev acc
    | 'M'::rest -> parse (M::acc) rest
    | 'D'::rest -> parse (D::acc) rest
    | 'A'::rest -> parse (A::acc) rest
    | _ -> failwith ("Unsupported register in destination: " ^ dest_str)
  in
  parse [] (String.to_seq dest_str |> List.of_seq)

let parse_output output_str =
  match output_str with
  | "0" -> Constant Zero
  | "1" -> Constant One
  | "-1" -> Constant MinusOne
  | reg when reg = "A" || reg = "D" || reg = "M" ->
      UApply (ID, parse_register reg)
  | reg when (String.length reg > 2) && (String.sub reg (String.length reg - 2) 2 = "+1") ->
      let base = String.sub reg 0 (String.length reg - 2) in
      UApply (Incr, parse_register base)  (* Recognize X+1 as an increment operation *)
  | reg when (String.length reg > 2) && (String.sub reg (String.length reg - 2) 2 = "-1") ->
      let base = String.sub reg 0 (String.length reg - 2) in
      UApply (Decr, parse_register base)  (* Recognize X-1 as a decrement operation *)
  | reg when (String.length reg > 1) && (String.sub reg 0 1 = "!") ->
      let base = String.sub reg 1 (String.length reg - 1) in
      UApply (BNeg, parse_register base)  (* Recognize !X as a negation operation *)
  | _ ->
    (* Check for binary operations *)
    let ops = String.split_on_char '+' output_str in
    if List.length ops > 1 then
      let left = String.trim (List.hd ops) in
      let right = String.trim (List.nth ops 1) in
      if right = "1" then
        BApply (Add, parse_register left, parse_register "A")  (* Placeholder to handle X + 1 *)
      else
        BApply (Add, parse_register left, parse_register right)
    else
      let ops = String.split_on_char '-' output_str in
      if List.length ops > 1 then
        BApply (Sub, parse_register (List.hd ops), parse_register (List.nth ops 1))
      else
        let ops = String.split_on_char '&' output_str in
        if List.length ops > 1 then
          BApply (And, parse_register (List.hd ops), parse_register (List.nth ops 1))
        else
          let ops = String.split_on_char '|' output_str in
          if List.length ops > 1 then
            BApply (Or, parse_register (List.hd ops), parse_register (List.nth ops 1))
          else
            failwith ("Unsupported output expression: " ^ output_str)



let parse_c_instruction line =
  let parts = String.split_on_char ';' line in
  let (comp, jump) =
    match parts with
    | [c] -> (c, None)
    | [c; j] -> (c, parse_jump j)
    | _ -> failwith "Invalid C instruction format"
  in
  let dest, output =
    match String.split_on_char '=' comp with
    | [d; c] -> (parse_dest d, parse_output c)
    | _ -> ([], parse_output comp)
  in
  C (dest, output, jump)

let parse_line line =
  let line = String.trim line in
  if String.length line = 0 then
    None  (* Ignore empty lines *)
  else if line.[0] = '(' then
    None  (* Ignore label lines during this pass *)
  else if line.[0] = '@' then
    let value_str = String.sub line 1 (String.length line - 1) in
    let value =
      try int_of_string value_str
      with Failure _ ->
        if not (mem symbol_table value_str) then
          let address = !next_var_address in
          add symbol_table value_str address;
          next_var_address := address + 1;
          address
        else find symbol_table value_str
    in
    Some (At value)  (* Return the instruction *)
  else
    Some (parse_c_instruction line)  (* Parse actual C-instruction *)

let parse_program lines =
  let _ = first_pass lines in  (* First pass for labels *)
  List.filter_map parse_line lines  (* Second pass for instructions *)

let ignore_comments lines =
  List.map (fun line ->
    let trimmed_line = String.trim line in
    match String.index_opt trimmed_line '/' with
    | Some idx -> String.trim (String.sub trimmed_line 0 idx)  (* Take the part before the comment *)
    | None -> trimmed_line  (* No comment, return the trimmed line as is *)
  ) lines

let () =
  initialize_symbol_table ()
