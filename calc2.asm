.global _start

.section .data
msg:    .ascii "Result: "
msglen = . - msg
result: .ascii "     "      /* Buffer for result digits */
newline: .ascii "\n"

.section .text
_start:
    /* Simple addition: 15 + 7 = 22 */
    mov r0, #15         /* First number */
    mov r1, #7          /* Second number */
    add r0, r0, r1      /* Result in r0 */

    /* Convert to ASCII - simple version for positive numbers 0-99 */
    mov r1, #10         /* Divisor */
    mov r2, #0          /* Digit counter */

    /* First check if zero */
    cmp r0, #0
    bne div_loop

    /* Handle zero case */
    mov r3, #48         /* ASCII '0' */
    ldr r4, =result
    strb r3, [r4]
    mov r2, #1          /* Length = 1 */
    b print_result

div_loop:
    /* Divide r0 by 10 */
    mov r3, #0          /* Quotient */
div_inner:
    cmp r0, r1
    blt div_done
    sub r0, r0, r1
    add r3, r3, #1
    b div_inner

div_done:
    /* r0 now has remainder, r3 has quotient */
    add r0, r0, #48     /* Convert remainder to ASCII */
    
    /* Store digit */
    ldr r4, =result
    add r4, r4, r2      /* Position in buffer */
    strb r0, [r4]       /* Store digit */
    add r2, r2, #1      /* Increment counter */
    
    /* Check if done */
    cmp r3, #0
    beq reverse
    
    /* Continue with quotient */
    mov r0, r3
    b div_loop

reverse:
    /* Reverse the digits (simple case for small numbers) */
    cmp r2, #2
    blt print_result    /* Nothing to reverse if only 1 digit */
    
    /* Swap first and last digit for 2-digit number */
    ldr r4, =result
    ldrb r0, [r4]
    ldrb r1, [r4, #1]
    strb r1, [r4]
    strb r0, [r4, #1]

print_result:
    /* Print "Result: " */
    mov r7, #4          /* syscall: write */
    mov r0, #1          /* stdout */
    ldr r1, =msg
    mov r2, #msglen
    swi 0

    /* Print result */
    mov r7, #4          /* syscall: write */
    mov r0, #1          /* stdout */
    ldr r1, =result
    /* r2 already has length */
    swi 0

    /* Print newline */
    mov r7, #4          /* syscall: write */
    mov r0, #1          /* stdout */
    ldr r1, =newline
    mov r2, #1
    swi 0

    /* Exit */
    mov r7, #1          /* syscall: exit */
    mov r0, #0          /* status: 0 */
    swi 0
