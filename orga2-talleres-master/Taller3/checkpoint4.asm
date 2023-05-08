extern malloc
extern free
extern fprintf

section .data
	msg db  'NULL'
	
section .text

global strCmp
global strClone
global strDelete
global strPrint
global strLen



; ** String **

; in_tt32 strCmp(char* a(rdi), char* b(rsi))
; Compara dos strings en orden lexicográfico. Ver https://es.wikipedia.org/wiki/Orden_lexicografico.
; Debe retornar: 
; 0 si son iguales
; 1 si a < b
;-1 si a > b
strCmp:
;prologo
	push rbp
	mov rbp, rsp

	xor rax, rax

.ciclo:	
	xor rdx, rdx 
	mov dl, BYTE [rsi]		;muevo a un registro el char de B porque no puedo hacer cmp entre dos operandos en memoria

	cmp BYTE [rdi], dl		;comparo para ver cual es mas grande, es decir, cual esta primero en el orden lexicografico
	jl .A_antes				;si el char de A es menor que el de B, A esta antes lexicograficamente
	jg .B_antes				;si el char de A es mayor que el de B, B esta antes lexicograficamente
	cmp BYTE [rdi], 0x0		;en caso de que ambos sean iguales, si el char es 0 quiere decir que terminaron y que son iguales
	jz .iguales
	inc rdi					;si son iguales pero no se termino el string, incrementamos en uno los punteros y volvemos a empezar el ciclo
	inc rsi
	jmp .ciclo 

.A_antes:
	mov rax, 0x1			;devuelvo 1 y termino
	jmp .fin

.B_antes:
	mov rax, 0x0
	dec rax					;devuelvo -1 y termino
	jmp .fin

.iguales:					
	xor rax, rax			;devuelvo 0 y termino

.fin:
;epilogo
	pop rbp	
	ret



; char* strClone(char* a(rdi))
; Genera una copia del string pasado por parámetro. El puntero pasado siempre es válido
; aunque podría corresponderse a la cadena vacía.
strClone:
;prologo
	push rbp
	mov rbp, rsp
	push r12
	push r13	;alineado
	push rbx
	sub rsp, 8	;alineado

	xor r12, r12
	mov r12, rdi	;muevo a r12 el string
	call strLen
	xor r13, r13
	inc rax			;tengo que incrementar por uno para que entre el 0 al final
	mov r13, rax	;muevo a r13 el largo del string

	mov rdi, r13
	call malloc		;pido memoria para el nuevo string

	xor rdi, rdi
	mov rdi, rax	;muevo a rdi, el puntero del nuevo string

	xor rcx, rcx
	mov rcx, r13	;muevo a rcx el tamaño del string

.ciclo:
	xor rbx, rbx
	mov bl, BYTE [r12]		;
	mov [rdi], bl			;copio el char al nuevo string
	inc rdi					;avanzo en el string destino
	inc r12					;avanzo en el string fuente

	loop .ciclo

;epilogo
	add rsp, 8
	pop rbx
	pop r13
	pop r12
	pop rbp	
	ret

; void strDelete(char* a(rdi))
; Borra el string pasado por parámetro. Esta función es equivalente a la función free.
strDelete:
;prologo
	push rbp
	mov rbp, rsp

	call free

;epilogo
	pop rbp	
	ret



; void strPrint(char* a(rdi), FILE* pFile(rsi))
; Escribe el string en el stream indicado a través de pFile. Si el string es vacío debe escribir "NULL"
strPrint:
;prologo
	push rbp
	mov rbp, rsp
	push r12
    push r13

	mov r12, rdi
	mov r13, rsi

    call strLen
    cmp rax, 0x0
    JNE .end
    mov rdi, msg

.end:
	
    mov rdi, r13
    mov rsi, r12
    call fprintf




;epilogo
	pop r13
	pop r12
	pop rbp	
	ret

; uint32_t strLen(char* a(rdi))
; Retorna la cantidad de caracteres distintos de cero del string pasado por parámetro. El /0 no se cuenta en el largo 
strLen:
;prologo
	push rbp
	mov rbp, rsp

	xor rax, rax

.ciclo:
	cmp byte [rdi], 0x0		;comparamos con el byte 0 que indica que termina el string
	je .fin					;si el char en el que estamos parados es 0, el string termino por lo que saltamos al fin
	inc rax					;sino aumentamos en uno el tamaño y también el puntero al string para mirar al siguiente char
	inc rdi
	jmp .ciclo

.fin: 

;epilogo
	pop rbp	
	ret
