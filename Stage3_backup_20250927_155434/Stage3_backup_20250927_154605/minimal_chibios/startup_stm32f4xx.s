.syntax unified
.cpu cortex-m4
.fpu softvfp
.thumb

.global Reset_Handler
.global _estack

/* Vector Table */
.section .isr_vector, "a", %progbits
.word _estack
.word Reset_Handler

/* Reset handler */
.text
Reset_Handler:
    ldr sp, =_estack
    bl main
1:  b 1b
