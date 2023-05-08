section .data


section .text

global invertirBytes_asm



; void invertirBytes_asm(uint8_t* p(rdi), uint8_t n(rsi), uint8_t m(rdx))


invertirBytes_asm:
	;prologo
	push rbp
	mov rbp, rsp
	push rbx
	sub rsp, 8 ;Alineado
	
	pxor xmm0, xmm0
	pxor xmm1, xmm1

	movdqa xmm1, [rdi]
	;muevo a rbx porque el registro rsi no tiene parte 8 bits mas bajos
	xor rbx, rbx
	mov rbx, rsi

	xor rcx, rcx
	mov rcx, 0xF
	;voy a crear la mascar en xmm2
	pxor xmm2, xmm2

;---------------------------------------------------------------------------------------
	;este ciclo es para poder crear la mascar, avanzo desde 0 hasta 15. Si el iterador es igual a M o a M, ponemos en esa posicion de la mascar la nueva posicion que le corresponde a ese byte
.ciclo:
	cmp rcx, rbx
	je .estamosEnN
	cmp rcx, rdx
	je .estamosEnM

	;en caso de que rcx no sea igual a N ni a M, voy a escribir en el rcx-esimo byte a rcx. Eso va a hacer que estee byte se permute al mismo lugar donde estaba
	;como no se como esrcibir en byte especificos de un registro, voy a escribir la mascara primero en memoria y despues la muevo a xmm2
	mov BYTE [rdi + rcx],  cl
	;si N!=15 y M!=15, en p+15 voy a guardar 15
	

.seguirCiclando:
	cmp rcx, 0x0
	je .finDeCiclo
	sub rcx, 1 
	jmp .ciclo

.estamosEnN:
	;cuando rcx es igual a N, quiero guardar en p+rcx a M, asi el valor que esta en el N-esimo byte va a parar al M-esimo byte
	mov BYTE [rdi + rcx], dl
	jmp .seguirCiclando

.estamosEnM:
	;cuando rcx es igual a M, quiero guardar en p+rcx a N, asi el valor que esta en el M-esimo byte va a parar al N-esimo byte
	mov BYTE [rdi + rcx], bl
	jmp .seguirCiclando

.finDeCiclo:
	;cuando rcx es 0, termina el ciclo pero nos falto esribir en [rdi+0] a 0
	;mov BYTE [rdi + rcx], cl
;---------------------------------------------------------------------------------------

;una vez que la mascara ya esta terminada, la movemos de [p] a xmm2
	movdqa xmm2, [rdi]

;Con vpermb, copio lo que esta en xmm1 a xmm0(primero a reg porque no me deja directo a memoria), en base a la mascar en xmm2
	;vpermb xmm0, xmm2, xmm1
	pshufb xmm1, xmm2

	movdqa [rdi], xmm1

	;epilogo
	add rsp, 8
	pop rbx
	pop rbp
	ret
