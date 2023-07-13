.intel_syntax noprefix

// HOW TO COMPILE: gcc -Wall teste.s -o teste.bin

.section .text

.global main
main:
    # inicializando 
    push rbp
    mov rbp, rsp
    sub rsp, 48
alocando_vector:
    mov rdi, 5 * 4
    call malloc@plt
    mov [rip + vector], rax
    mov rax, [rip + vector]
    mov DWORD PTR [rax + 0], 5
    mov DWORD PTR [rax + 4], 4
    mov DWORD PTR [rax + 8], 2
    mov DWORD PTR [rax + 12], 1
    mov DWORD PTR [rax + 16], 3
call_ordenar:
    mov rdi, [rip + vector]
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
    sub rsp, 48
    mov QWORD PTR [rbp - 8], rdi
for_i_init:
    mov DWORD PTR [rbp - 44], 0 # i = 0
for_i:
    cmp DWORD PTR [rbp - 44], 4 # i == 4 ?
    je final_ordenar
    mov eax, DWORD PTR [rbp - 44]
    mov DWORD PTR [rbp - 40], eax # min = i
for_j_init:
    mov eax, DWORD PTR [rbp - 44]
    add eax, 1
    mov DWORD PTR [rbp - 36], eax # j = i + 1
for_j:
    cmp DWORD PTR [rbp - 36], 5 # j == 5 ?
    je continuacao_for_i
condicao_min:
    mov eax, DWORD PTR [rbp - 36] 
    lea rdx, [rax * 4 + 0]
    mov rax, QWORD PTR [rbp - 8] 
    add rax, rdx
    mov edx, DWORD PTR [rax] 
    mov eax, DWORD PTR [rbp - 40] 
    lea rcx, [rax * 4 + 0]
    mov rax, QWORD PTR [rbp - 8]
    add rax, rcx
    mov eax, DWORD PTR [rax]
    cmp edx, eax
    jge continuacao_for_j
min_igual_j:
    mov eax, DWORD PTR [rbp - 36]
    mov DWORD PTR [rbp - 40], eax
continuacao_for_j:
    inc DWORD PTR [rbp - 36]
    jmp for_j
continuacao_for_i:
    mov eax, DWORD PTR [rbp - 44]
    cmp eax, DWORD PTR [rbp - 40]
    je final_for_i
    lea rdx, [rax * 4 + 0]
    mov rax, [rip + vector]
    add rdx, rax
    mov eax, DWORD PTR [rbp - 40]
    lea rcx, [rax * 4 + 0]
    mov rax, [rip + vector]
    add rax, rcx
    mov rdi, rax
    mov rsi, rdx
    call swap
final_for_i:
    inc DWORD PTR [rbp - 44]
    jmp for_i
final_ordenar:
    # encerrando
    mov rsp, rbp
    pop rbp
    ret

swap:
    mov eax, DWORD PTR [rdi]
    xchg eax, DWORD PTR [rsi]
    mov DWORD PTR [rdi], eax
    ret
    
.section .bss
    vector: .8byte  

.section .rodata
    teste: .string "teste i = %u / j = %u / %u %u\n"
    print_v: .string "%u "
    final: .string "\n"
    
    