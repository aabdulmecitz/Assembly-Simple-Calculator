# Assembly Simple Calculator

This repository contains two calculator programs written in assembly language:

- `calc.asm`: A working interactive calculator for x86 (NASM, Linux).
- `calc2.asm`: A simple calculator for ARM (GNU Assembler, Linux) - **Currently has syntax compatibility issues**.

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
  - Has compatibility issues with certain versions of GNU Assembler.
  - Designed to add two numbers (`15` and `7`) and print the result.
  - **Note**: This file may require syntax adjustments for your specific ARM assembler version.

## Detailed Code Explanation for calc.asm (x86)

### Data and BSS Sections
```nasm
section .data
    msg1 db "Sayi1: ", 0        ; Prompt for first number
    msg2 db "Sayi2: ", 0        ; Prompt for second number
    msg3 db "Islem (+ - * /): ", 0  ; Prompt for operation
    resultMsg db "Sonuc: ", 0   ; Result message prefix
    newline db 10               ; Newline character (ASCII 10)

section .bss
    num1 resb 10                ; Buffer for first number input
    num2 resb 10                ; Buffer for second number input
    op resb 2                   ; Buffer for operation character
    sonuc resb 12               ; Buffer for result string
```

- `.data` section contains initialized data (strings, constants)
- `.bss` section reserves uninitialized memory for variables
- `db` directive defines bytes with initial values
- `resb` reserves the specified number of bytes

### Input/Output Operations
The program uses Linux system calls for I/O:
- System call 4 (`sys_write`) - writes data to a file descriptor
  - `eax = 4` - system call number
  - `ebx = 1` - file descriptor (1 = stdout)
  - `ecx` - buffer address
  - `edx` - buffer length
- System call 3 (`sys_read`) - reads data from a file descriptor
  - `eax = 3` - system call number
  - `ebx = 0` - file descriptor (0 = stdin)
  - `ecx` - buffer address
  - `edx` - maximum bytes to read

### Arithmetic Operations
- `add esi, edi` - Addition (esi = esi + edi)
- `sub esi, edi` - Subtraction (esi = esi - edi)
- `imul esi, edi` - Signed multiplication (esi = esi * edi)
- `idiv ebx` - Signed division (eax = eax / ebx, remainder in edx)

### String to Integer Conversion (atoi)
```nasm
atoi:
    xor eax, eax        ; Clear result register
    xor ebx, ebx        ; Clear temporary register
.next:
    mov bl, byte [ecx]  ; Load a byte from the string
    cmp bl, 10          ; Check for newline
    je .done            ; If newline, we're done
    sub bl, '0'         ; Convert ASCII to number
    imul eax, eax, 10   ; Multiply current result by 10
    add eax, ebx        ; Add the new digit
    inc ecx             ; Move to next character
    jmp .next           ; Process next character
.done:
    ret                 ; Return with result in eax
```

### Integer to String Conversion (itoa)
```nasm
itoa:
    mov ebx, 10         ; Divisor = 10
    mov edi, ecx        ; Save buffer address
    mov esi, edi        ; Start from end of buffer
    add esi, 11         ; Move to the end
    mov byte [esi], 0   ; Null-terminate
    dec esi             ; Step back
    mov ecx, 0          ; Initialize length counter
    
    ; Handle zero case
    cmp eax, 0
    jne .convert
    mov byte [esi], '0' ; Put '0' character
    dec esi             ; Move left
    inc ecx             ; Increment length
    jmp .done
    
    ; Convert digits
.convert:
.reverse:
    xor edx, edx        ; Clear edx for division
    div ebx             ; Divide by 10, remainder in edx
    add dl, '0'         ; Convert remainder to ASCII
    mov [esi], dl       ; Store the digit
    dec esi             ; Move left
    inc ecx             ; Increment length
    test eax, eax       ; Check if quotient is zero
    jnz .reverse        ; If not, continue
    
.done:
    ; Copy to start of buffer
    inc esi             ; Point to first digit
    mov edi, ecx        ; Save length
    mov ebx, ecx        ; Save length again
    ; Copy digits to buffer start
    mov ecx, ebx        ; Loop counter = length
    mov edi, sonuc      ; Destination = result buffer
.rep:
    mov al, [esi]       ; Load digit
    mov [edi], al       ; Store digit
    inc esi             ; Next source
    inc edi             ; Next destination
    loop .rep           ; Repeat until done
    mov eax, ebx        ; Return length in eax
    ret
```

## Issues with ARM Assembly (calc2.asm)

The ARM assembly version (`calc2.asm`) encounters syntax compatibility issues with the GNU Assembler. These issues may include:

1. Incompatible comment style
2. Different memory addressing syntax
3. Register operand format differences
4. Function call and return mechanism differences

The current implementation attempts to add two numbers (15 and 7) and print the result, but syntax compatibility issues prevent successful compilation on some systems.

## How to Build and Run

### Prerequisites

- For `calc.asm`:  
  - NASM assembler  
  - GNU linker (`ld`)  
  - x86 Linux environment

- For `calc2.asm` (if you can resolve the syntax issues):  
  - GNU assembler (`as`)  
  - GNU linker (`ld`)  
  - QEMU user-mode emulator for ARM (`qemu-arm`) if running on non-ARM hardware

### Build

```sh
# To build only the x86 version (recommended)
make calc

# To attempt building both (ARM version may fail)
make
```

### Run

- To run the x86 calculator:
  ```sh
  make run-calc
  ```
  - The program will prompt for two numbers and an operation, then display the result.

- If you manage to build the ARM version:
  ```sh
  make run-calc2
  ```

### Clean

```sh
make clean
```
Removes all generated binaries and object files.

## Troubleshooting

### For x86 (calc.asm)

If you get an error like `make: nasm: Command not found`, you need to install NASM:
```sh
sudo apt-get update
sudo apt-get install nasm
```

### For ARM (calc2.asm)

The ARM version has syntax compatibility issues that vary by assembler version. Common errors include:
- Comment syntax issues (`@` vs `/* */`)
- Memory addressing format incompatibility
- Register list notation differences
- Function call/return mechanism differences

You may need to adapt the syntax for your specific version of GNU Assembler or use a different ARM assembly development environment.