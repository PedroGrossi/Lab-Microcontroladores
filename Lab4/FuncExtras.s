; FuncExtras.s
; Desenvolvido para a placa EK-TM4C1294XL
; Pedro Henrique Grossi da Silva - 24/05/2023	
	
;################################################################################
        THUMB                       ; Instruções do tipo Thumb-2
;################################################################################		
	AREA  DATA, ALIGN=2

;################################################################################	
	AREA    |.text|, CODE, READONLY, ALIGN=2
	
	IMPORT SysTick_Wait1ms				; Função de espera
	IMPORT PortF_Output			; Output da porta F
	IMPORT PortN_Output			; Output da porta N
	
	EXPORT Wait
;################################################################################
; Função Wait
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
;################################################################################
Wait
	MOV		R9, LR
	CMP		R8, #0
	BLEQ	Verifica_Pedestre
	CMP		R8, #0
	BLEQ 	SysTick_Wait1ms
	BXEQ	R9
	CMP		R8, #1
	MOVEQ	R0, #6000
	BLEQ 	SysTick_Wait1ms
	BXEQ	R9
	CMP		R8, #2
	MOVEQ	R0, #2000
	BLEQ 	SysTick_Wait1ms
	BXEQ	R9
	CMP		R8, #3
	MOVEQ	R0, #1000
	BLEQ 	SysTick_Wait1ms
	BXEQ	R9
	CMP		R8, #4
	MOVEQ	R0, #6000
	BLEQ 	SysTick_Wait1ms
	BXEQ	R9
	CMP		R8, #5
	MOVEQ	R0, #2000
	BLEQ 	SysTick_Wait1ms
	BXEQ	R9
	
Verifica_Pedestre
	PUSH	{LR}
	CMP		R11,#0
	MOVEQ	R0, #1000	;Espera 1 segundo
	BXEQ	LR
	MOV		R7, #0
Pisca_Led
	MOV		R0, #2_00000010
	BL		PortN_Output
	MOV		R0, #2_00010000
	BL		PortF_Output
	MOV		R0, #1000	;Espera 1 segundos
	BL	 	SysTick_Wait1ms
	ADD		R7, #1
	CMP		R7, #5
	MOVEQ	R0, #0
	MOVEQ	R11, #0		;Reseta a interrupção
	POPEQ	{LR}
	BXEQ	LR			;ACABOU A FUNÇÃO
	MOV		R0, #2_00000001
	BL		PortN_Output
	MOV		R0, #2_00000001
	BL		PortF_Output
	MOV		R0, #1000	;Espera 1 segundos
	BL	 	SysTick_Wait1ms
	ADD		R7, #1
	B		Pisca_Led
		
	
;################################################################################
; Fim do Arquivo
;################################################################################
    ALIGN                        	;Garante que o fim da seção está alinhada 
Pisca_N		DCB		2_00000010,2_00000001
Pisca_F		DCB		2_00010000,2_00000001
    END                          	;Fim do arquivo