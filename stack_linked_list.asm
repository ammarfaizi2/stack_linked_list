
; @author Ammar Faizi <ammarfaizi2@gmail.com> https://www.facebook.com/ammarfaizi2
; @license MIT

; struct _my_node
; 64 bytes data
; 8 bytes next
; 8 bytes prev

%define struct_size (64 + 8 + 8)
%define struct_amount 26

section .text
global _start
_start:
	push qword 0xffffffffffffffff
	lea rbp, [rsp - 8]
	sub rsp, struct_size * struct_amount

	; init head head [0]
	mov qword [rbp - (struct_size * 0)], 0 ; prev is nullptr
	lea rax, [rbp - struct_size]
	mov [rbp - (struct_size * 0) - 8], rax ; next is [1]
	lea rdi, [rbp - (struct_size * 0) - 8 - 64]
	mov rax, "AAAAAAAA"
	mov rcx, 8
	rep stosq

	mov rdi, 0
	mov rsi, 1
	mov rcx, 2
	xor rdx, rdx

	.init_ll:
		; Get prev addr
		mov r8, rbp
		mov rax, struct_size
		mul rdi
		sub r8, rax

		; Set prev addr
		mov r9, rbp
		mov rax, struct_size
		mul rsi
		sub r9, rax
		mov [r9], r8

		; Get next addr
		mov r8, rbp
		mov rax, struct_size
		mul rcx
		sub r8, rax

		; Set next addr
		sub r9, 8
		mov r11, r9
		mov [r9], r8

		sub r9, 64
		mov r10, rdi ; Backup rdi
		mov rdi, r9
		mov r9, rcx ; Backup rcx
		lea rax, [r10 + 66]
		mov rcx, 64
		rep stosb

		lea rdi, [r10 + 1]
		lea rcx, [r9 + 1]
		inc rsi

		cmp rsi, struct_amount
		jl .init_ll

	xor rax, rax
	mov [r11], rax ; Set next on tail to null.

	.nop_sec:
		nop
		nop
		nop

	sub rsp, 16

	.print_link:
		mov [rsp + 8], rbp
		mov qword [rsp], 10

		.l0:
			mov rax, 1
			mov rdi, 1
			mov rsi, [rsp + 8]
			sub rsi, 72
			mov rdx, 64
			syscall
			mov rax, 1
			mov rdi, 1
			mov rsi, rsp
			mov rdx, 1
			syscall
			mov rax, [rsp + 8]
			sub rax, 8
			mov rax, [rax]
			mov [rsp + 8], rax
			cmp rax, 0
			jne .l0

	.exit:
		mov rax, 60
		xor rdi, rdi
		syscall

;;; Base code
	; ; head [0]
	; xor rax, rax
	; mov [rbp - (struct_size * 0)], rax ; prev is nullptr
	; lea rax, [rbp - struct_size]
	; mov [rbp - (struct_size * 0) - 8], rax ; next is [1]

	; ; [1]
	; lea rax, [rbp - (struct_size * 0)]
	; mov [rbp - (struct_size * 1)], rax ; prev is [0]
	; lea rax, [rbp - (struct_size * 2)]
	; mov [rbp - (struct_size * 1) - 8], rax ; next is [2]

	; ; [2]
	; lea rax, [rbp - (struct_size * 1)]
	; mov [rbp - (struct_size * 2)], rax ; prev is [1]
	; lea rax, [rbp - struct_size * 3]
	; mov [rbp - (struct_size * 2) - 8], rax ; next is [3]

	; ; [3]
	; lea rax, [rbp - (struct_size * 2)]
	; mov [rbp - (struct_size * 3)], rax ; prev is [2]
	; lea rax, [rbp - struct_size * 4]
	; mov [rbp - (struct_size * 3) - 8], rax ; next is [4]

	; ...
	; ...
