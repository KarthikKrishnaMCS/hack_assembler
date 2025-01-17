open Ast
open Machine
open Parser

(* Convert an int to a binary string representation of 16 bits *)
let int_to_binary_string n =
  let rec aux n acc =
    if n = 0 && acc = "" then "0"
    else if n = 0 then acc
    else aux (n lsr 1) ((if (n land 1) = 1 then "1" else "0") ^ acc)
  in
  let binary = aux n "" in
  let padding = String.make (16 - String.length binary) '0' in
  padding ^ binary

(* Convert assembly instruction to machine code *)
let instruction_to_machine inst =
  match inst with
  | At value -> encode (At value)
  | C (dest, output, jump) -> encode (C (dest, output, jump))
  | Label _ -> failwith "Labels are not encoded as machine instructions"

(* Process the input assembly code *)
let process_input lines =
  let lines_without_comments = ignore_comments lines in  (* Ignore comments from the lines *)
  let instructions = parse_program lines_without_comments in
  let machine_codes = List.map instruction_to_machine instructions in
  List.iter (fun code ->
    Printf.printf "%s\n" (int_to_binary_string code)
  ) machine_codes

let () =
  Printf.printf "Enter Hack assembly code (Ctrl+D to end input):\n";
  
  let rec read_lines acc =
    try
      let line = read_line () in
      read_lines (line :: acc)
    with End_of_file -> List.rev acc
  in

  let lines = read_lines [] in
  try
    process_input lines
  with
  | Failure msg -> Printf.printf "Parsing error: %s\n" msg
  | e -> Printf.printf "Unexpected error: %s\n" (Printexc.to_string e)
