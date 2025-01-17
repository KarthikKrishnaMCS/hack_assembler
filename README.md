
# Hack Assembler

This project is an assembler written in OCaml that translates Hack assembly language instructions into binary code for the Hack computer platform. The assembler processes assembly instructions, constructs an abstract syntax tree (AST), parses instructions, and utilizes a symbol table for variable management. The build and execution of the project are managed using Dune.

## Prerequisites

- **OCaml:** Ensure that OCaml is installed on your system. You can download it from the [official OCaml website](https://ocaml.org/).  
- **Dune:** This project uses Dune as the build system. Install Dune by following the instructions on the [Dune GitHub page](https://github.com/ocaml/dune).  

## Features

- **Abstract Syntax Tree (AST):** Defines the structure of Hack assembly instructions, facilitating efficient parsing and translation.  
- **Parser:** Interprets assembly instructions and constructs the corresponding AST.  
- **Symbol Table:** Manages variable symbols and their corresponding memory addresses, ensuring accurate translation.  
- **Assembler:** Converts the parsed instructions into binary code executable by the Hack computer.  


## Project Structure

- **`ast.ml`**: Contains the definitions for the abstract syntax tree representing the structure of Hack assembly instructions.  
- **`parser.ml`**: Implements the parser that reads assembly instructions and constructs the AST.  
- **`machine.ml`**: Handles the translation of parsed instructions into binary code.  
- **`symbol_table.ml`**: Manages the symbol table for storing and retrieving variable addresses.
  

## Installation

1. **Clone the Repository:**  
   ```bash
   git clone https://github.com/KarthikKrishnaMCS/hack_assembler.git
2. **Navigate to the Project Directory:**  
   ```bash
   cd hack_assembler
3. **Build the Project Using Dune**  
   ```bash
   dune build

## Usage

After building the project, run the assembler to translate Hack assembly files into binary code:

  ```bash
   dune ./bin/main.exe > file.asm
  ```
Replace file.asm with your Hack assembly file.


## Example

Given a Hack assembly file Max.asm with the following content:

  ```asm
   // This program computes R2 = max(R0, R1)
   @R0
   D=M
   @R1
   D=D-M
   @OUTPUT_FIRST
   D;JGT
   @R1
   D=M
   @OUTPUT_D
  0;JMP
   (OUTPUT_FIRST)
   @R0
   D=M
   (OUTPUT_D)
   @R2
   M=D
   @END
   0;JMP
   (END)
   ```

Running the assembler will produce a binary file Max.hack with the corresponding machine code:

   ```hack
   0000000000000000
   1111110000001000
   0000000000000001
   1111010011010000
   0000000000001010
   1110001100000001
   0000000000000001
   1111110000001000
   0000000000001100
   1110101010000111
   0000000000000000
   1111110000001000
   0000000000000010
   1110001100001000
   0000000000001110
   1110101010000111
   0000000000001110
   ```

## Acknowledgements

This assembler is inspired by the projects and teachings from the "Elements of Computing Systems" course, also known as Nand2Tetris. Special thanks to Noam Nisan and Shimon Schocken for their foundational work in computer science education.


