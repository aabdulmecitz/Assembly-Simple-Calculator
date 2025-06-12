.global _start

.section .data
msg:     .asciz "Result: "
nl:      .asciz "\n"
buf:     .space 12        ; ASCII number buffer

.section .text
_start:
    MOV     r0, #15        ; number 1
    MOV     r1, #7         ; number 2
    ADD     r2, r0, r1     ; r2 = r0 + r1

    ; Prepare buffer address
    LDR     r1, =buf
    MOV     r0, r2         ; number to convert
    BL      itoa           ; itoa(r0=r2, r1=buf)

    ; Print "Result: "
    MOV     r0, #1         ; stdout
    LDR     r1, =msg
    MOV     r2, #8
    MOV     r7, #4         ; sys_write
    SWI     0

    ; Print ASCII number
    MOV     r0, #1
    LDR     r1, =buf
    MOV     r2, #12
    MOV     r7, #4
    SWI     0

    ; Print newline
    MOV     r0, #1
    LDR     r1, =nl
    MOV     r2, #1
    MOV     r7, #4
    SWI     0

    ; Exit
    MOV     r0, #0
    MOV     r7, #1
    SWI     0

; -------------- itoa function --------------
; r0: number, r1: buffer address
itoa:
    STMFD   sp!, {r4-r7, lr}
    MOV     r4, r1          ; buffer pointer
    MOV     r5, #0          ; digit count

    CMP     r0, #0
    BNE     itoa_loop
    MOV     r6, #'0'
    STRB    r6, [r4], #1
    MOV     r5, #1
    B       itoa_done

itoa_loop:
    MOV     r6, r0
    MOV     r7, #10
    BL      udivmod         ; returns quotient in r0, remainder in r1
    ADD     r1, r1, #'0'
    STRB    r1, [r4], #1
    ADD     r5, r5, #1
    CMP     r0, #0
    BNE     itoa_loop

itoa_done:
    ; Reverse buffer
    SUB     r4, r4, r5      ; r4 points to start
    MOV     r6, r5
    SUB     r6, r6, #1      ; r6 = r5-1
    MOV     r7, #0
itoa_rev_loop:
    CMP     r7, r6
    BGE     itoa_rev_end
    LDRB    r2, [r4, r7]
    LDRB    r3, [r4, r6]
    STRB    r3, [r4, r7]
    STRB    r2, [r4, r6]
    ADD     r7, r7, #1
    SUB     r6, r6, #1
    B       itoa_rev_loop
itoa_rev_end:
    LDMFD   sp!, {r4-r7, lr}
    BX      lr

; Unsigned division: r0 = dividend, r7 = divisor
; Returns: r0 = quotient, r1 = remainder
udivmod:
    MOV     r2, #0          ; quotient
    MOV     r3, r0          ; dividend
    MOV     r4, r7          ; divisor
    CMP     r4, #0
    BEQ     udivmod_end
udivmod_loop:
    CMP     r3, r4
    BLT     udivmod_end
    SUB     r3, r3, r4
    ADD     r2, r2, #1
    B       udivmod_loop
udivmod_end:
    MOV     r0, r2          ; quotient
    MOV     r1, r3          ; remainder
    BX      lr
