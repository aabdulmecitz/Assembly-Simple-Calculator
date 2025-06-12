# Assembly Simple Calculator

This repository contains two simple calculator programs written in assembly language:

- `calc.asm`: An interactive calculator for x86 (NASM, Linux).
- `calc2.asm`: A simple calculator for ARM (GNU Assembler, Linux).

## Files

- **calc.asm**:  
  - Written for x86 architecture using NASM syntax.
  - Runs on Linux.
  - Prompts the user to enter two numbers and an operation (`+`, `-`, `*`, `/`).
  - Performs the selected operation and prints the result.
  - Uses system calls for input/output.
  - Includes helper functions for string-to-integer (`atoi`) and integer-to-string (`itoa`) conversions.

- **calc2.asm**:  
  - Written for ARM architecture using GNU Assembler syntax.
  - Runs on Linux (can be tested with QEMU).
  - Hardcoded to add two numbers (`15` and `7`), prints the result.
  - Demonstrates basic arithmetic, integer-to-ASCII conversion, and output using system calls.

## How to Build and Run

### Prerequisites

- For `calc.asm`:  
  - NASM assembler  
  - GNU linker (`ld`)  
  - x86 Linux environment

- For `calc2.asm`:  
  - GNU assembler (`as`)  
  - GNU linker (`ld`)  
  - QEMU user-mode emulator for ARM (`qemu-arm`) if running on non-ARM hardware

### Build

```sh
make
```

This will build both `calc` (x86) and `calc2` (ARM) binaries.

### Run

- To run the x86 calculator:
  ```sh
  make run-calc
  ```
  - The program will prompt for two numbers and an operation, then display the result.

- To run the ARM calculator (using QEMU):
  ```sh
  make run-calc2
  ```
  - The program will output the sum of 15 and 7.

### Clean

```sh
make clean
```
Removes all generated binaries and object files.

### Troubleshooting

If you get an error like `make: nasm: Command not found`, you need to install NASM.  
On Ubuntu/Debian, run:

```sh
sudo apt-get update
sudo apt-get install nasm
```

If you see `E: Unable to locate package nasm`, make sure your package lists are up to date and your system has the correct repositories enabled.  
If you are using a minimal or containerized environment, you may need to enable the `universe` repository:

```sh
sudo apt-get update
sudo apt-get install software-properties-common
sudo add-apt-repository universe
sudo apt-get update
sudo apt-get install nasm
```

For other platforms, please refer to the [NASM official website](https://www.nasm.us/).

## Code Explanation

### calc.asm (x86, NASM)

- Prompts the user for two numbers and an operation.
- Reads input using Linux system calls.
- Converts ASCII input to integers (`atoi`).
- Performs the selected arithmetic operation.
- Converts the result back to ASCII (`itoa`).
- Prints the result.

### calc2.asm (ARM, GNU Assembler)

- Hardcoded to add two numbers: 15 and 7.
- Converts the result to ASCII and prints it with the label "Result: ".
- Uses a custom `itoa` function for integer-to-string conversion.
- Uses Linux system calls for output.

---

**Note:**  
- `calc.asm` is interactive and works on x86 Linux.
- `calc2.asm` is for ARM and demonstrates basic assembly arithmetic and output.