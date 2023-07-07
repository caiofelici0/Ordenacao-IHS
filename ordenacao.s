.intel_syntax noprefix

// HOW TO COMPILE: gcc -Wall ordenacao.s -o ordenacao.bin

.section .text

.global main
main:
    # inicializando 
    push rbp
    mov rbp, rsp
    sub rsp, 48
    # onde tudo acontece
    mov rdi, 5 * 4
    call malloc@plt
    mov [rip + vector], rax
    add_vector:
        mov rdx, [rip + vector]
        movq [rdx + 0], 1
        movq [rdx + 4], 3
        movq [rdx + 8], 5
        movq [rdx + 12], 2
        movq [rdx + 16], 4
        call ordenar_vetor
    print_vector_init:
        mov rcx, 0
	print_vector:
        cmp rcx, 5
        je done
        mov [rbp - 4], rcx # i = rcx
        lea rdi, [rip + print_v]
        mov rsi, [rip + vector]
        mov rsi, [rsi + rcx * 4]
        call printf@plt
        mov rcx, [rbp - 4]
        inc rcx
        jmp print_vector
done:
    lea rdi, [rip + final]
    call printf@plt
    mov rdi, [rip + vector]
    call free@plt
    # encerrando
    xor rax, rax
    mov rsp, rbp
    pop rbp
    ret

ordenar_vetor:
    # inicializando 
    push rbp
    mov rbp, rsp
    sub rsp, 16
    for_i_init:
        mov rcx, 0 # i = 0
    for_i:
        cmp rcx, 4
        je final_ordenar
        mov [rbp - 8], rcx # salvando i
        mov [rbp - 12], rcx # salvando min
        for_j_init:
            mov rdx, rcx
            add rdx, 1
        for_j:
            cmp rdx, 5
            je continuacao_for_i
            mov [rbp - 16], rdx
            lea rdi, [rip + print_v]
            mov rsi, rdx
            call printf@plt
            mov rdx, [rbp - 16]
            inc rdx
            jmp for_j
    continuacao_for_i:
        mov rcx, [rbp - 8]
        inc rcx
        jmp for_i
    final_ordenar:
    # encerrando
    mov rsp, rbp
    pop rbp
    ret
    
.section .bss
    vector: .8byte  

.section .rodata
    print_v: .string "%u "
    final: .string "\n"
    
    