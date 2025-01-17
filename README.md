
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
1. **Build the Project Using Dune**  
   ```bash
   dune build
