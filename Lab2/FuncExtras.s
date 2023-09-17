; FuncExtras.s
; Desenvolvido para a placa EK-TM4C1294XL
; Pedro Henrique Grossi da Silva - 24/05/2023	
	
;################################################################################
        THUMB                       ; Instru��es do tipo Thumb-2
;################################################################################		
	AREA  DATA, ALIGN=2

;################################################################################	
	AREA    |.text|, CODE, READONLY, ALIGN=2
	
	IMPORT PortJ_Input
	
	EXPORT Verifica_Chaves

;################################################################################
; Fun��o Verifica_Chaves
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
;################################################################################
Verifica_Chaves
	MOV 	R10, LR					;Salva de onde veio
	BL		PortJ_Input
Verifica_Nenhuma
	CMP		R0, #2_00000011			;Verifica se nenhuma chave est� pressionada
	BNE		Verifica_SW1			;Se o teste viu que tem pelo menos alguma chave pressionada
	BX		R10						;Return
Verifica_SW1	
	CMP		R0, #2_00000010			;Verifica se somente a chave SW1 est� pressionada
	BNE		Verifica_SW2			;Se n�o for a chave SW1 pula para a chave SW2
	BL		Troca_Modo				;Troca entre cavalgada e contador
	BX		R10						;Return
Verifica_SW2
	CMP		R0, #2_00000001			;Verifica se somente a chave SW1 est� pressionada
	BNE		Verifica_SW1_SW2		;Se n�o for a chave SW1 pula para o teste das duas
	BL		Troca_Velocidade		;Troca velocidade dos modos
	BX		R10						;Return
Verifica_SW1_SW2
	CMP		R0, #2_00000000			;Verifica se as duas chaves est�o pressionadas
	BXNE	R10						;Return
	BL		Troca_Modo				;Troca entre cavalgada e contador
	BL		Troca_Velocidade		;Troca velocidade dos modos
	BX		R10						;Return
	
;################################################################################
; Fun��o Troca_Modo
; Par�metro de entrada: R11 --> 0 = cavalgada // 1 = contagem
; Par�metro de sa�da: R11 --> 0 = cavalgada // 1 = contagem
;################################################################################
Troca_Modo
	CMP		R11, #0					;Verifica em qual modo esta (cavalgada ou contagem)
	MOVEQ	R11, #1					;Muda para contagem
	MOVNE	R11, #0					;Muda para cavalgada
	BX		LR						;return

;################################################################################
; Fun��o Troca_Velocidade
; Par�metro de entrada: R12 --> 1000ms // 500ms // 200ms
; Par�metro de sa�da: R12 --> 1000ms // 500ms // 200ms
;################################################################################
Troca_Velocidade
	CMP		R12, #1000				;Verifica se a velocidade � 1000ms
	MOVEQ	R12, #500				;Se sim, muda para 500ms
	BXEQ	R10						;return
	CMP		R12, #500				;Verifica se a velocidade � 500ms
	MOVEQ	R12, #200				;Se sim, muda para 200ms
	BXEQ	R10						;return
	MOV	    R12, #1000				;Se sim, muda para 1000ms
	BX	    R10						;return
	
;################################################################################
; Fim do Arquivo
;################################################################################
    ALIGN                        	;Garante que o fim da se��o est� alinhada 
    END                          	;Fim do arquivo