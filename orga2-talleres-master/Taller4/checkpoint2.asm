
section .data
TodosUnos dq 0xFFFF, 0xFFFF


section .text
%define OFFSET_A 0x0
%define OFFSET_B 0x10
%define OFFSET_C 0x20
%define OFFSET_SIGUIENTE 0x40
%define OFFSET_A_2 0x8
%define OFFSET_B_2 0x18
%define OFFSET_C_2 0x30

global checksum_asm


; uint8_t checksum_asm(void* array(rdi), uint32_t n(rsi))

checksum_asm:
	;prologo
	push rbp
	mov rbp, rsp

	
	mov rcx, rsi

	xor rax, rax

	mov rax, 0x1

.inicioDeCiclo:

;movemos primeros 8 A
	pxor xmm1, xmm1
	pmovzxwd xmm1, [rdi + OFFSET_A]
	pxor xmm4, xmm4
	pmovzxwd xmm4, [rdi + OFFSET_A_2]
	
;movemos primeros 8 B
	pxor xmm2, xmm2
	pmovzxwd xmm2, [rdi + OFFSET_B]
	pxor xmm5, xmm5
	pmovzxwd xmm5, [rdi + OFFSET_B_2]

;sumamos los A con los B
	paddd xmm1, xmm2
	paddd xmm4, xmm5
;multiplicamos por 8 el resultado
	pslld xmm1, 3
	pslld xmm4, 3

;movemos los primeros 8 de C
	pxor xmm3, xmm3
	movdqa xmm3, [rdi + OFFSET_C]
	pxor xmm6, xmm6
	movdqa xmm6, [rdi + OFFSET_C_2]
	
;comparar con respecto a C

	pcmpeqq xmm1, xmm3
	
	pcmpeqq xmm7, xmm7
	pxor xmm1, xmm7

	phaddd xmm1, xmm1
	phaddd xmm1, xmm1

	movq r8, xmm1
	cmp r8, 0x0
	jne .distintos

	pcmpeqq xmm4, xmm6
	pcmpeqq xmm7, xmm7
	pxor xmm4, xmm7
	
	phaddd xmm4, xmm4
	phaddd xmm4, xmm4

	movq r8, xmm4
	cmp r8, 0x0
	jne .distintos

	dec rcx
	jz .fin_ciclo

	add rdi, OFFSET_SIGUIENTE


	jmp .inicioDeCiclo

.distintos:
	mov rax, 0x0
	
.fin_ciclo:




	;epilogo
	pop rbp
	ret

