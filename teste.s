.intel_syntax noprefix

// HOW TO COMPILE: gcc -Wall teste.s -o teste.bin / ./teste.bin input.txt output.txt

.section .bss
    vector: .8byte

.section .rodata
    _int: .string "%d "
    s: .string "%s \n"
    indice: .string "[%d] "
    final: .string "\n"
    read_arq: .string "r"
    write_arq: .string "w"

.section .text

.global main
main:
    # inicializando 
    push rbp
    mov rbp, rsp
    sub rsp, 64
    mov rax, [rsi + 8]
    mov [rbp - 64], rax
    mov rax, [rsi + 16]
    mov [rbp - 56], rax
    lea rdi, [rip + s]
    mov rsi, [rbp - 56]
    call printf@plt
done:
    # encerrando
    xor rax, rax
    mov rsp, rbp
    pop rbp
    ret

    