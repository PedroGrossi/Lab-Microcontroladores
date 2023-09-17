; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Esquele de um novo Projeto para Keil
; Prof. Guilherme de S. Peron	- 12/03/2018
; Prof. Marcos E. P. Monteiro	- 12/03/2018
; Prof. DaLuz           		- 25/02/2022

;################################################################################
; Declarações EQU
; <NOME>	EQU <VALOR>
num_list       EQU 0x20000400
prime_num_list EQU 0x20000500
;################################################################################
	AREA    |.text|, CODE, READONLY, ALIGN=2
	THUMB
; Se alguma função do arquivo for chamada em outro arquivo	
    EXPORT Start					; Permite chamar a função Start a partir de 
									; outro arquivo. No caso startup.s
								
; Se chamar alguma função externa	
;	IMPORT <func>          			; Permite chamar dentro deste arquivo uma 
									; função <func>

;################################################################################
; Função main()	
Start								;Label Start ... void main(void)
; Comece o código aqui <=========================================================

	BL store_mem
	BL prime_list

store_mem
	LDR R10, =num_list
    MOV R0, #193
	STRB R0, [R10], #1
    MOV R0, #63
	STRB R0, [R10], #1
    MOV R0, #176
	STRB R0, [R10], #1
    MOV R0, #127
	STRB R0, [R10], #1
    MOV R0, #43
	STRB R0, [R10], #1
    MOV R0, #13
	STRB R0, [R10], #1
    MOV R0, #211
	STRB R0, [R10], #1
    MOV R0, #3
	STRB R0, [R10], #1
    MOV R0, #203
	STRB R0, [R10], #1
    MOV R0, #5
	STRB R0, [R10], #1
    MOV R0, #21
	STRB R0, [R10], #1
    MOV R0, #7
	STRB R0, [R10], #1
    MOV R0, #206
	STRB R0, [R10], #1
    MOV R0, #245
	STRB R0, [R10], #1
    MOV R0, #157
	STRB R0, [R10], #1
    MOV R0, #237
	STRB R0, [R10], #1
    MOV R0, #241
	STRB R0, [R10], #1
    MOV R0, #105
	STRB R0, [R10], #1
    MOV R0, #252
	STRB R0, [R10], #1
    MOV R0, #19
	STRB R0, [R10], #1
	LDR R7, =num_list
	BX LR
	
prime_list
	LDR R11, =prime_num_list
	LDRB R0, [R7]
	MOV R1, R0
	LSR R1, #1
	ADD R1, R1, #1
	MOV R2, #1
	PUSH{LR}
	BL prime_number_finder
	POP{LR}
	

prime_number_finder
	
	CMP R1, R2
	ADDNE R2, R2, #1
	UDIV R3, R0, R2
	MLS R4, R2, R3, R0
	CMP R4, #0
	BXEQ LR
	CMP R1, R2
	BNE prime_number_finder
	STRB R0, [R11], #1
	MOV R5, #0
	BX LR

; Final do código aqui <=========================================================
    NOP
    ALIGN                       	;garante que o fim da seção está alinhada 
    END                         	;fim do arquivo