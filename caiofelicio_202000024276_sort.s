.intel_syntax noprefix

// HOW TO COMPILE: gcc -Wall caiofelicio_202000024276_sort.s -o caiofelicio_202000024276_sort.bin / ./caiofelicio_202000024276_sort.bin input.txt output.txt

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
    mov [rbp - 64], rax # input_name
    mov rax, [rsi + 16]
    mov [rbp - 56], rax # output_name
abrindo_arquivos:
    mov rdi, [rbp - 64]
    lea rsi, [rip + read_arq]
    call fopen
    mov QWORD PTR [rbp - 8], rax # input
    mov rdi, [rbp - 56]
    lea rsi, [rip + write_arq]
    call fopen
    mov QWORD PTR [rbp - 32], rax # output
get_n:
    mov rdi, QWORD PTR [rbp - 8]
    lea rsi, [rip + _int]
    lea rdx, [rbp - 12] # n
    call fscanf
loop_principal_init:
    mov ecx, 0
loop_principal:
    cmp ecx, DWORD PTR [rbp - 12]
    je done
    mov DWORD PTR [rbp - 16], ecx # i = ecx
alocando_vector:
    mov rdi, QWORD PTR [rbp - 8]
    lea rsi, [rip + _int]
    lea rdx, [rbp - 20] # m: tamanho do vetor
    call fscanf
    mov eax, DWORD PTR [rbp - 20]
    imul eax, 4
    mov edi, eax
    call malloc@plt
    mov [rip + vector], rax
vector_init:
    mov ecx, 0
vector_loop:
    cmp ecx, DWORD PTR [rbp - 20]
    je call_ordenar
    mov DWORD PTR [rbp - 24], ecx
    lea rdx, [rcx * 4]
    mov rax, [rip + vector]
    add rax, rdx
    mov rdi, QWORD PTR [rbp - 8]
    lea rsi, [rip + _int]
    lea rdx, [rax]
    call fscanf
    mov ecx, DWORD PTR [rbp - 24]
    inc ecx
    jmp vector_loop
call_ordenar:
    mov rdi, [rip + vector]
    mov esi, DWORD PTR [rbp - 20]
    call ordenar_vetor
print_vector_init:
    mov rdi, QWORD PTR [rbp - 32]
    lea rsi, [rip + indice]
    mov edx, DWORD PTR [rbp - 16]
    call fprintf
    mov ecx, 0
print_vector:
    cmp ecx, DWORD PTR [rbp - 20]
    je final_loop_principal
    mov DWORD PTR [rbp - 36], ecx # i = ecx
    lea rdx, [ecx * 4]
    mov rax, [rip + vector]
    add rax, rdx
    mov rdi, QWORD PTR [rbp - 32]
    lea rsi, [rip + _int]
    mov edx, DWORD PTR [rax] 
    call fprintf
    mov ecx, DWORD PTR [rbp - 36]
    inc ecx
    jmp print_vector
final_loop_principal:
    mov rdi, QWORD PTR [rbp - 32]
    lea rsi, [rip + final]
    call fprintf
    mov rdi, [rip + vector]
    call free@plt
    mov ecx, DWORD PTR [rbp - 16]
    inc ecx
    jmp loop_principal
done:
    mov rdi, QWORD PTR [rbp - 32]
    call fclose
    mov rdi, QWORD PTR [rbp - 8]
    call fclose
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
    mov QWORD PTR [rbp - 8], rdi # ponteiro vetor
    mov DWORD PTR [rbp - 12], esi # tamanho vetor
for_i_init:
    mov DWORD PTR [rbp - 44], 0 # i = 0
for_i:
    mov ecx, DWORD PTR [rbp - 12] 
    sub ecx, 1
    cmp DWORD PTR [rbp - 44], ecx # i == m - 1?
    je final_ordenar
    mov eax, DWORD PTR [rbp - 44]
    mov DWORD PTR [rbp - 40], eax # min = i
for_j_init:
    mov eax, DWORD PTR [rbp - 44]
    add eax, 1
    mov DWORD PTR [rbp - 36], eax # j = i + 1
for_j:
    mov ecx, DWORD PTR [rbp - 12]
    cmp DWORD PTR [rbp - 36], ecx # j == 5 ?
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
    mov eax, DWORD PTR [rbp - 40]
    lea rdx, [rax * 4 + 0]
    mov rax, QWORD PTR [rbp - 8]
    add rdx, rax
    mov eax, DWORD PTR [rbp - 44]
    lea rcx, [rax * 4 + 0]
    mov rax, QWORD PTR [rbp - 8]
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
    
    
    