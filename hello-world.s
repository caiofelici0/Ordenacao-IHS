.intel_syntax noprefix

// HOW TO COMPILE: gcc -Wall hello-world.s -o hello-world.bin

.section .text

.global main
main:
    push rbp
    mov rbp, rsp
    sub rsp, 16
    lea rdi, [rip + hello_world]
    call printf@plt
    mov rsp, rbp
    pop rbp
    // Returning from call
    ret

.section .rodata
hello_world:
    .string "Hello world! %u\n"

    