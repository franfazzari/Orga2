extern sumar_c
extern restar_c
;########### SECCION DE DATOS
section .data

;########### SECCION DE TEXTO (PROGRAMA)
section .text

;########### LISTA DE FUNCIONES EXPORTADAS

global alternate_sum_4
global alternate_sum_4_simplified
global alternate_sum_8
global product_2_f
global alternate_sum_4_using_c

;########### DEFINICION DE FUNCIONES
; uint32_t alternate_sum_4(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[rdi], x2[rsi], x3[rdx], x4[rcx]
alternate_sum_4:
	;prologo
	push rbp
	mov rbp, rsp
	; COMPLETAR

	xor rax, rax
	add rax, rdi
	sub rax, rsi
	add rax, rdx
	sub rax, rcx

	;recordar que si la pila estaba alineada a 16 al hacer la llamada
	;con el push de RIP como efecto del CALL queda alineada a 8

	;epilogo
	pop rbp
	; COMPLETAR
	ret

; uint32_t alternate_sum_4_using_c(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[rdi], x2[rsi], x3[rdx], x4[rcx]
alternate_sum_4_using_c:
	;prologo
	push rbp ; alineado a 16
	mov rbp,rsp
	push r12
	push r13

	;pasar los parametros a registros no volatiles para asi cuando llamamos a la funcion de c, que los parametros que estan en los registros no se cmambien
	mov r12, rdx
	mov r13, rcx


	call restar_c
	mov rdi, rax
	mov rsi, r12
	call sumar_c
	mov rdi, rax
	mov rsi, r13
	call restar_c


	; COMPLETAR

	;epilogo
	pop r13
	pop r12
	pop rbp
	ret



; uint32_t alternate_sum_4_simplified(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4);
; registros: x1[rdi], x2[rsi], x3[rdx], x4[rcx]
alternate_sum_4_simplified:
	mov rax, rdi
	sub rax, rsi
	add rax, rdx
	sub rax, rcx
	ret


; uint32_t alternate_sum_8(uint32_t x1, uint32_t x2, uint32_t x3, uint32_t x4, uint32_t x5, uint32_t x6, uint32_t x7, uint32_t x8);
; registros y pila: x1[rdi], x2[rsi], x3[rdx], x4[rcx], x5[r8], x6[r9], x7[rbp + 0x10], x8[rbp + 0x20]
alternate_sum_8:
	;prologo
	push rbp
	mov rsp, rbp

	call alternate_sum_4_simplified
	push rax
	sub rsp, 0x8
	mov rdi, r8
	mov r8, rax
	mov rsi, r9
	mov edx, DWORD  [rbp +0x10]
	mov ecx, DWORD  [rbp +0x20]
	call alternate_sum_4_simplified
	mov rdi, rax
	add rsp, 0x8
	pop rax
	add rax, rdi

	;epilogo
	
	pop rbp
	ret


; SUGERENCIA: investigar uso de instrucciones para convertir enteros a floats y viceversa
;void product_2_f(uint32_t * destination, uint32_t x1, float f1);
;registros: destination[rdi], x1[rsi], f1[xmm0]
product_2_f:
	;prologo
	push rbp
	mov rsp, rbp

	;COMPLETAR
	pxor xmm1, xmm1
	; VCVTUSI2SS — Convert Unsigned Integer to Scalar Single-Precision Floating-Point Value
	CVTSI2SS xmm1, rsi
	; MULSS
	MULSS xmm0, xmm1

	; VCVTTSD2USI — Convert with Truncation Scalar Double-Precision Floating-Point Value to Unsigned Integer
	CVTSS2SI rax, xmm1
	mov [rdi], rax
	

	;epilogo
	pop rbp
	ret

