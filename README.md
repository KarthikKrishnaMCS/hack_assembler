
# Hack Assembler

This project is an assembler written in OCaml that translates Hack assembly language instructions into binary code for the Hack computer platform. The assembler processes assembly instructions, constructs an abstract syntax tree (AST), parses instructions, and utilizes a symbol table for variable management. The build and execution of the project are managed using Dune.

## Features

- **Abstract Syntax Tree (AST):** Defines the structure of Hack assembly instructions, facilitating efficient parsing and translation.  
- **Parser:** Interprets assembly instructions and constructs the corresponding AST.  
- **Symbol Table:** Manages variable symbols and their corresponding memory addresses, ensuring accurate translation.  
- **Assembler:** Converts the parsed instructions into binary code executable by the Hack computer.  

## Prerequisites

- **OCaml:** Ensure that OCaml is installed on your system. You can download it from the [official OCaml website](https://ocaml.org/).  
- **Dune:** This project uses Dune as the build system. Install Dune by following the instructions on the [Dune GitHub page](https://github.com/ocaml/dune).  

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
   dune build
  ```
Replace path/to/your/assembly_file.asm with the actual path to your Hack assembly file.


 ## Project Structure

 - **`ast.ml`**: Contains the definitions for the abstract syntax tree representing the structure of Hack assembly instructions.  
 - **`parser.ml`**: Implements the parser that reads assembly instructions and constructs the AST.  
 - **`machine.ml`**: Handles the translation of parsed instructions into binary code.  
 - **`symbol_table.ml`**: Manages the symbol table for storing and retrieving variable addresses.  
 - **`bin/main.ml`**: The entry point of the assembler application. 

