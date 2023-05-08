extern malloc
extern free
extern fprintf

section .data

section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen

; ** String **

; int32_t strCmp(char* a, char* b)
; a: rdi, b: rsi
strCmp:
	; push rbp
	; mov rbp, rsp
	
	; pop rbp
	ret
	
; char* strClone(char* a)
strClone:
	; Arranca el prologo
	push rbp
	mov rbp, rsp
	; Termina el prologo
	
	xor r8, r8
	mov r8, rdi

	call strLen
	inc rax
	mov rdi, rax
	
	call malloc ; me devuelve el puntero donde arranca el string en el que voy a copiar rdi
	; a malloc solo le paso el tamaño en bytes
	mov r9, rax
	
	mov rdx, r9
	
	jmp caracterNoNulo
copiarCaracter:
	mov cl, byte[r8] ; uso cl porque son los 8 bits bajos del ecx
	mov byte[r9], cl
	inc r8
	inc r9

caracterNoNulo:
	cmp byte[r8], 0x00
	jne copiarCaracter
fin:
	mov rax, rdx
	; mov rdi, 
	pop rbp
	ret

; void strDelete(char* a)
strDelete:
	; Esto no funciona porque copia el puntero al string
	; pero no el string en sí mismo
	; mov rax, rdi
	push rbp
	mov rbp, rsp
	
	; mov r9, rdi
	; call strLen
	; mov rdi, rax
	
	; jmp compararChar
	
	call free ; si bien (creo que) cada free tiene que tener su malloc, llamo a free porque me pasan un puntero como parámetro

	pop rbp
	ret
	
	
cambiarChar:
	; mov byte[r9], 0x00
	; inc r9
	
compararChar:
	; cmp byte[r9], 0x00
	; jne cambiarChar

; void strPrint(char* a, FILE* pFile)
strPrint:
	ret

; uint32_t strLen(char* a)
strLen:
	push rbp
	mov rbp, rsp

	xor r8, r8
	jmp ciclo

incRegistros:
	inc r8
	inc rdi

ciclo:
	cmp byte[rdi], 0x00
	jne incRegistros

end:
	mov rax, r8
	pop rbp
	ret
