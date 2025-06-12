section .data
    msg1 db "Sayi1: ", 0
    msg2 db "Sayi2: ", 0
    msg3 db "Islem (+ - * /): ", 0
    resultMsg db "Sonuc: ", 0
    newline db 10

section .bss
    num1 resb 10
    num2 resb 10
    op resb 2
    sonuc resb 10

section .text
    global _start

_start:
    ; Sayı 1
    mov eax, 4
    mov ebx, 1
    mov ecx, msg1
    mov edx, 7
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 10
    int 0x80

    ; Sayı 2
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, 7
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, num2
    mov edx, 10
    int 0x80

    ; İşlem seçimi
    mov eax, 4
    mov ebx, 1
    mov ecx, msg3
    mov edx, 17
    int 0x80

    mov eax, 3
    mov ebx, 0
    mov ecx, op
    mov edx, 2
    int 0x80

    ; String -> int
    mov ecx, num1
    call atoi
    mov esi, eax        ; sayı1

    mov ecx, num2
    call atoi
    mov edi, eax        ; sayı2

    ; İşlem karakteri al
    mov al, [op]
    cmp al, '+'
    je toplama
    cmp al, '-'
    je cikarma
    cmp al, '*'
    je carpma
    cmp al, '/'
    je bolme

    jmp bitir

toplama:
    add esi, edi
    jmp yazdir

cikarma:
    sub esi, edi
    jmp yazdir

carpma:
    imul esi, edi
    jmp yazdir

bolme:
    xor edx, edx
    mov eax, esi
    mov ebx, edi
    idiv ebx
    mov esi, eax
    jmp yazdir

yazdir:
    mov eax, esi
    call itoa
    mov edx, eax

    mov eax, 4
    mov ebx, 1
    mov ecx, resultMsg
    mov edx, 7
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, sonuc
    mov edx, edx
    int 0x80

    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

bitir:
    mov eax, 1
    xor ebx, ebx
    int 0x80

; ------------------------
; Yardımcı Fonksiyonlar
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
itoa:
    mov ecx, 10
    lea edi, [sonuc + 9]
    mov byte [edi], 0
    dec edi
.reverse:
    xor edx, edx
    div ecx
    add dl, '0'
    mov [edi], dl
    dec edi
    test eax, eax
    jnz .reverse
    inc edi
    sub edx, edx
    mov eax, sonuc + 9
    sub eax, edi
    ret
