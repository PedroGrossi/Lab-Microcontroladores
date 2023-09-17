; Leds.s
; Desenvolvido para a placa EK-TM4C1294XL
; Pedro Henrique Grossi da Silva - 24/05/2023	
	
;################################################################################
        THUMB                        ; Instruções do tipo Thumb-2
;################################################################################		
	AREA  DATA, ALIGN=2

;################################################################################	
	AREA    |.text|, CODE, READONLY, ALIGN=2
	
	IMPORT PortF_Output			; Output da porta F
	IMPORT PortN_Output			; Output da porta N
	
	EXPORT Modo_Operacao		; Exibe o modo de operação selecionado

;################################################################################
; Função Modo_Operacao
; Parâmetro de entrada: R11 --> 0 = cavalgada // 1 = contagem
; Parâmetro de saída: Não tem
;################################################################################
Modo_Operacao
	MOV R10, LR					;Salva a posição de que veio
	CMP	R11, #0
	BNE Contagem				;Se for contagem salta para a subrotina
	BEQ	Cavalgada				;Se for cavalgada salta para a subrotina

;################################################################################
; Função Cavalgada
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
;################################################################################

Cavalgada	
	LDR 	R5, =Cavalaria_F	;Vetor de estados de F
	LDR 	R6, =Cavalaria_N	;Vetor de estados de N	
	LDR 	R0, [R5, R8]		;Seleciona o estado de F
	BL		PortF_Output		;Print do estado de F
	LDR 	R0, [R6, R8]		;Seleciona o estado de N
	BL		PortN_Output		;Print do estado de N
	CMP 	R8, #5				;Se chega no estado 5(ultimo) 
	ADDNE	R8, R8, #1			;Passa para o proximo estado
	MOVEQ	R8, #0				;Retorna para o primeiro estado
	BX 		R10					;return
	
;################################################################################
; Função Contagem
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
;################################################################################
Contagem
	LDR 	R5, =Contagem_F 	;Vetor de estados de F
	LDR 	R6, =Contagem_N		;Vetor de estados de N
	LDR 	R0, [R5, R9]		;Seleciona o estado de F
	BL		PortF_Output		;Print do estado de F
	LDR 	R0, [R6, R9]		;Seleciona o estado de N
	BL		PortN_Output		;Print do estado de N
	CMP 	R9, #15				;Se chega no estado 5(ultimo) 
	ADDNE	R9, R9, #1			;Passa para o proximo estado
	MOVEQ	R9, #0				;Retorna para o primeiro estado
	BX 		R10					;return
		
;################################################################################
; Fim do Arquivo
;################################################################################
    ALIGN                       ;Garante que o fim da seção está alinhada 
;Estados dos leds na cavalaria
Cavalaria_N		DCB		2_00000010,2_00000001,2_00000000,2_00000000,2_00000000,2_00000001	;vetor que salva o estado do modo N na cavalaria
Cavalaria_F		DCB		2_00000000,2_00000000,2_00010000,2_00000001,2_00010000,2_00000000	;vetor que salva o estado do modo F na cavalaria
;Estados dos leds na contagem
Contagem_N		DCB		2_00000000,2_00000000,2_00000000,2_00000000,2_00000001,2_00000001,2_00000001,2_00000001,2_00000010,2_00000010,2_00000010,2_00000010,2_00000011,2_00000011,2_00000011,2_00000011 ;vetor que salva o estado do modo N na contagem
Contagem_F		DCB		2_00000000,2_00000001,2_00010000,2_00010001,2_00000000,2_00000001,2_00010000,2_00010001,2_00000000,2_00000001,2_00010000,2_00010001,2_00000000,2_00000001,2_00010000,2_00010001 ;vetor que salva o estado do modo F na contagem
    END                          		;Fim do arquivo