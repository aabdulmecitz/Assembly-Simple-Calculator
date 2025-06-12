    .global _start

.section .data
msg:     .asciz "Result: "
nl:      .asciz "\n"
buf:     .space 12        @ ASCII sayı yazmak için buffer

.section .text
_start:
    MOV     r0, #15        @ sayı 1
    MOV     r1, #7         @ sayı 2
    ADD     r2, r0, r1     @ toplama: r2 = r0 + r1

    MOV     r0, r2         @ sayıyı yazmak için r0 → itoa
    LDR     r1, =buf
    BL      itoa           @ r0 sayı → buf'a yazılır

    @ Ekrana "Result: "
    MOV     r0, #1         @ stdout
    LDR     r1, =msg
    MOV     r2, #8
    MOV     r7, #4         @ syscall write
    SVC     #0

    @ ASCII sayıyı yaz
    MOV     r0, #1
    LDR     r1, =buf
    MOV     r2, #12
    MOV     r7, #4
    SVC     #0

    @ newline
    MOV     r0, #1
    LDR     r1, =nl
    MOV     r2, #1
    MOV     r7, #4
    SVC     #0

    @ çıkış
    MOV     r0, #0
    MOV     r7, #1
    SVC     #0

@ -------------- itoa fonksiyonu --------------

@ r0: sayı, r1: hedef buffer
itoa:
    PUSH    {r4, r5, lr}
    MOV     r2, r1
    MOV     r3, #0

itoa_loop:
    MOV     r4, #10
    UDIV    r5, r0, r4
    MLS     r6, r5, r4, r0
    ADD     r6, r6, #'0'
    STRB    r6, [r2], #1
    MOV     r0, r5
    ADD     r3, r3, #1
    CMP     r0, #0
    BNE     itoa_loop

    SUB     r2, r2, r3
    SUB     r1, r2, #0
    ADD     r4, r1, r3
    SUB     r4, r4, #1

itoa_reverse:
    CMP     r2, r4
    BHS     itoa_done
    LDRB    r5, [r2]
    LDRB    r6, [r4]
    STRB    r6, [r2]
    STRB    r5, [r4]
    ADD     r2, r2, #1
    SUB     r4, r4, #1
    B       itoa_reverse

itoa_done:
    POP     {r4, r5, lr}
    BX      lr
