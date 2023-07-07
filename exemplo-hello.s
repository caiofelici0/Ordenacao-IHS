// Using Intel syntax instead of AT&T
.intel_syntax noprefix

// HOW TO COMPILE: gcc -Wall hello_world.s -o hello_world.bin

// Executable code segment
.section .text
// Main function
.global main
main:
	// Prologue (saving stack registers)
	push rbp
	mov rbp, rsp
	// Reserving 16 bytes in stack
	sub rsp, 16
	// Allocating 5 positions of 32 bits in vector
	mov rdi, 5 * 4
	call malloc@plt
	// vector = [?, ?, ?, ?, ?]
	mov [rip + vector], rax
	// Calling printf("Please wait for delays...\n")
	lea rdi, [rip + wait_message]
	call printf@plt
	// for(i = 0; i < 5; i++)
	read_timestamps_init:
		// i = 0
		mov rcx, 0
	read_timestamps:
		// i < 5
		cmp rcx, 5
		je print_timestamps_init
		// Saving rcx
		mov [rbp - 8], rcx
		// Calling time(NULL);
		mov rdi, 0
		call time@plt
		// Restoring rcx
		mov rcx, [rbp - 8]
		// vector[i] = time(NULL)
		mov rdx, [rip + vector]
		mov [rdx + rcx * 4], rax
		// Delay
		rdtsc
		mov r8, rdx
		add r8, 3
		delay:
			rdtsc
			cmp rdx, r8
			jl delay
		// i++
		inc rcx
		jmp read_timestamps
	// for(i = 0; i < 5; i++)
	print_timestamps_init:
		// i = 0
		mov rcx, 0
	print_timestamps:
		// i < 5
		cmp rcx, 5
		je done
		// Saving rcx
		mov [rbp - 8], rcx
		// Calling printf("Hello world from assembly #%u (timestamp = %u)\n")
		lea rdi, [rip + hello_world]
		mov rsi, rcx
		// rdx = vector[i]
		mov rdx, [rip + vector]
		mov rdx, [rdx + rcx * 4]
		call printf@plt
		// Restoring rcx
		mov rcx, [rbp - 8]
		// i++
		inc rcx
		jmp print_timestamps
	done:
	// Freeing vector
	mov rdi, [rip + vector]
	call free@plt
	// Setting return value to 0
	xor rax, rax
	// Epilogue (restoring stack registers)
	mov rsp, rbp
	pop rbp
	// Returning from call
	ret

// BSS segment
.section .bss
vector:
	// 8 byte pointer (64 bits)
	.8byte
// Read-only data segment
.section .rodata
wait_message:
	// Printf wait argument
	.string "Please wait for delays...\n"
hello_world:
	// Printf hello world argument
	.string "Hello world from assembly #%u (timestamp = %u)\n"