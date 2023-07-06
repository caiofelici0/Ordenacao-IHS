.intel_syntax noprefix

// HOW TO COMPILE: gcc -Wall ordenacao.s -o ordenacao.bin

.section .text

.global main
main:
    # inicializando 
    push rbp
    mov rbp, rsp
    sub rsp, 16
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
    for_i_init:
        mov rcx, 0 # i = 0
    for_i:
        cmp rcx, 4
        je print_vector_init
        mov [rbp - 4], rcx # min = i
        for_j_init:
            mov r8, [rcx + 1] # j = i + 1
        for_j:
            cmp r8, 5
            je cont_for_i
            mov rdx, [rip + vector] 
            mov rdx, [rdx + r8 * 4] # rdx = V[j]
            mov rdi, [rip + vector] 
            mov r9, [rbp - 4] # r9 = min
            cmp rdx, [rdi + r9 * 4] # comparacao V[j] e V[min]
            jl min_menor_que_j
            jmp for_j
    cont_for_i:
        cmp rcx, [rbp - 4]
        jne swap
        inc rcx
        jmp for_i
    ret

min_menor_que_j:
    mov [rbp - 4], r8
    jmp for_j
    
swap:
    mov rdx, [rip + vector]
    mov r9, [rdx + rcx * 4] # V[i]
    mov r10, [rdx + 
    mov [rcx, [rbp - 4]
    mov [rbp - 4], rcx
    inc rcx
    jmp for_i
    
.section .bss
    vector: .8byte  

.section .rodata
    print_v: .string "%u "
    final: .string "\n"
    
    