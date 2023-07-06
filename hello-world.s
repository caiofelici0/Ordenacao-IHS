.intel_syntax noprefix

// HOW TO COMPILE: gcc -Wall hello-world.s -o hello-world.bin

.section .text

.global main
main:
    // Prologue (saving stack registers)
    push rbp
    mov rbp, rsp
    // Printando hello world
    lea rdi, [rip + hello_world]
    call printf@plt
    // Epilogue (restoring stack registers)
    mov rsp, rbp
    pop rbp
    // Returning from call
    ret

.section .rodata
hello_world:
    .string "Hello world!\n"