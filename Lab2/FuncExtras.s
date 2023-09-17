; FuncExtras.s
; Desenvolvido para a placa EK-TM4C1294XL
; Pedro Henrique Grossi da Silva - 24/05/2023	
	
;################################################################################
        THUMB                       ; Instruções do tipo Thumb-2
;################################################################################		
	AREA  DATA, ALIGN=2

;################################################################################	
	AREA    |.text|, CODE, READONLY, ALIGN=2
	
	IMPORT PortJ_Input
	
	EXPORT Verifica_Chaves

;################################################################################
; Função Verifica_Chaves
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
;################################################################################
Verifica_Chaves
	MOV 	R10, LR					;Salva de onde veio
	BL		PortJ_Input
Verifica_Nenhuma
	CMP		R0, #2_00000011			;Verifica se nenhuma chave está pressionada
	BNE		Verifica_SW1			;Se o teste viu que tem pelo menos alguma chave pressionada
	BX		R10						;Return
Verifica_SW1	
	CMP		R0, #2_00000010			;Verifica se somente a chave SW1 está pressionada
	BNE		Verifica_SW2			;Se não for a chave SW1 pula para a chave SW2
	BL		Troca_Modo				;Troca entre cavalgada e contador
	BX		R10						;Return
Verifica_SW2
	CMP		R0, #2_00000001			;Verifica se somente a chave SW1 está pressionada
	BNE		Verifica_SW1_SW2		;Se não for a chave SW1 pula para o teste das duas
	BL		Troca_Velocidade		;Troca velocidade dos modos
	BX		R10						;Return
Verifica_SW1_SW2
	CMP		R0, #2_00000000			;Verifica se as duas chaves estão pressionadas
	BXNE	R10						;Return
	BL		Troca_Modo				;Troca entre cavalgada e contador
	BL		Troca_Velocidade		;Troca velocidade dos modos
	BX		R10						;Return
	
;################################################################################
; Função Troca_Modo
; Parâmetro de entrada: R11 --> 0 = cavalgada // 1 = contagem
; Parâmetro de saída: R11 --> 0 = cavalgada // 1 = contagem
;################################################################################
Troca_Modo
	CMP		R11, #0					;Verifica em qual modo esta (cavalgada ou contagem)
	MOVEQ	R11, #1					;Muda para contagem
	MOVNE	R11, #0					;Muda para cavalgada
	BX		LR						;return

;################################################################################
; Função Troca_Velocidade
; Parâmetro de entrada: R12 --> 1000ms // 500ms // 200ms
; Parâmetro de saída: R12 --> 1000ms // 500ms // 200ms
;################################################################################
Troca_Velocidade
	CMP		R12, #1000				;Verifica se a velocidade é 1000ms
	MOVEQ	R12, #500				;Se sim, muda para 500ms
	BXEQ	R10						;return
	CMP		R12, #500				;Verifica se a velocidade é 500ms
	MOVEQ	R12, #200				;Se sim, muda para 200ms
	BXEQ	R10						;return
	MOV	    R12, #1000				;Se sim, muda para 1000ms
	BX	    R10						;return
	
;################################################################################
; Fim do Arquivo
;################################################################################
    ALIGN                        	;Garante que o fim da seção está alinhada 
    END                          	;Fim do arquivo