section 	.data
blue_mask: dd 0x000000ff, 0x000000ff, 0x000000ff, 0x000000ff
red_mask: dd 0x000000ff, 0x00000000, 0x00000000, 0x00000000
green_mask: dd 0x00000000, 0x000000ff, 0x00000000, 0x00000000
saturation_mask: dd 0x000000ff, 0x000000ff, 0x000000ff, 0x0000000

section 	.text

%define PIXEL_OFFSET 4


global Offset_asm

; void Offset_asm(uint8_t *src, uint8_t *dst, int width, int height, int src_row_size, int dst_row_size)
; registros: src[rdi], dst[rsi], width[rdx], height[rcx]

Offset_asm:

	; prologo
	push rbp
	mov rbp, rsp

	; Muevo las mascaras a registros xmm
	movdqa xmm3, [blue_mask]
	movdqa xmm2, [red_mask]
	movdqa xmm4, [green_mask]
	movdqa xmm5, [saturation_mask]
	pxor xmm6, xmm6


	; COMPLETAR

	; Copio los pixeles rojos que quiero y los paso
	movdqu xmm0, [rsi]									; Muevo a xmm0 los pixeles del src
	movdqa xmm1, [red_mask]								; Muevo a xmm1 la mascara roja

	pand xmm0, xmm1										; Extraigo los pixeles rojos del src

	movdqa xmm2, xmm0									; Muevo a xmm2 los pixeles rojos solos

	pcmpeqb xmm1, xmm1									; Invierto la mascara para que deje pasar todos los pixeles salvo los rojos
	pandn xmm1, xmm0

	movdqa xmm2, [rdi]									; Move el resto de los componentes de los pixeles a xmm2
	pand xmm2, xmm1
	por xmm2, xmm0										; Filtro los pixeles que no son rojos
	movdqu [rdi], xmm2									; Muevo los valores rojos del src con los otros valos del dst devuelta al dst



	; Copio los pixeles verdes que quiero y los paso
	movdqu xmmo




	; epilogo
	pop rbp
	ret
	


