section .data
    msg1 db "Number1: ", 0
    msg2 db "Number2: ", 0
    msg3 db "Operation (+ - * /): ", 0
    resultMsg db "Result: ", 0
    newline db 10

section .bss
    num1 resb 10
    num2 resb 10
    op resb 2
    result resb 12      ; buffer size increased for safety

section .text
    global _start

_start:
    ; Number 1
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, 9
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 10
    int 0x80

    ; Number 2
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, 9
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 10
    int 0x80

    ; Operation selection
    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, 19
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, op
    mov edx, 2
    int 0x80

    ; String -> int
    mov ecx, num1
    call atoi
    mov esi, eax        ; number1

    mov ecx, num2
    call atoi
    mov edi, eax        ; number2

    ; Get operation character
    mov al, [op]
    cmp al, '+'
    je addition
    cmp al, '-'
    je subtraction
    cmp al, '*'
    je multiplication
    cmp al, '/'
    je division

    jmp finish

addition:
    add esi, edi
    jmp print

subtraction:
    sub esi, edi
    jmp print

multiplication:
    imul esi, edi
    jmp print

division:
    xor edx, edx
    mov eax, esi
    mov ebx, edi
    idiv ebx
    mov esi, eax
    jmp print

print:
    mov eax, esi
    mov ecx, result
    call itoa
    mov edx, eax       ; eax = length

    mov eax, 4
    mov ebx, 1
    mov ecx, resultMsg
    mov edx, 7
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, eax       ; eax = length
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

finish:
    mov eax, 1
    xor ebx, ebx
    int 0x80

; ------------------------
; Helper Functions
; ------------------------

; String -> Integer
atoi:
    xor eax, eax
    xor ebx, ebx
.next:
    mov bl, byte [ecx]
    cmp bl, 10
    je .done
    sub bl, '0'
    imul eax, eax, 10
    add eax, ebx
    inc ecx
    jmp .next
.done:
    ret

; Integer -> String
; IN: eax = number, ecx = buffer
; OUT: eax = length
itoa:
    mov ebx, 10
    mov edi, ecx        ; edi = buffer
    mov esi, edi
    add esi, 11         ; write from end
    mov byte [esi], 0
    dec esi
    mov edx, 0
    mov ecx, 0          ; length

    cmp eax, 0
    jne .convert
    mov byte [esi], '0'
    dec esi
    inc ecx
    jmp .done

.convert:
.reverse:
    xor edx, edx
    div ebx
    add dl, '0'
    mov [esi], dl
    dec esi
    inc ecx
    test eax, eax
    jnz .reverse

.done:
    inc esi             ; esi now points to first digit
    mov edi, ecx        ; edi = length
    mov ebx, ecx        ; ebx = length
    mov edi, ecx        ; edi = length
    ; Copy digits to buffer start
    mov ecx, ebx        ; ecx = length
    mov edi, result     ; destination buffer
    mov esi, esi        ; source pointer (already set)
.rep:
    mov al, [esi]
    mov [edi], al
    inc esi
    inc edi
    loop .rep
    mov eax, ebx        ; return length
    ret
