; sinal.s
; Desenvolvido para a placa EK-TM4C1294XL
; Pedro Henrique Grossi da Silva - 16/06/2023	
	
;################################################################################
        THUMB                        ; Instruções do tipo Thumb-2
;################################################################################		
	AREA  DATA, ALIGN=2

;################################################################################	
	AREA    |.text|, CODE, READONLY, ALIGN=2
	
	IMPORT PortF_Output			; Output da porta F
	IMPORT PortN_Output			; Output da porta N
		
	EXPORT Sinal
	IMPORT Wait

;################################################################################
; Função Sinal
; Parâmetro de entrada: Não tem
; Parâmetro de saída: Não tem
;################################################################################
Sinal
	MOV		R10, LR
	LDR 	R5, =Sem_F			;Vetor de estados de F
	LDR 	R6, =Sem_N			;Vetor de estados de N	
	LDR 	R0, [R5, R8]		;Seleciona o estado de F
	BL		PortF_Output		;Print do estado de F
	LDR 	R0, [R6, R8]		;Seleciona o estado de N
	BL		PortN_Output		;Print do estado de N
	BL		Wait
	CMP 	R8, #5				;Se chega no estado 5(ultimo) 
	ADDNE	R8, R8, #1			;Passa para o proximo estado
	MOVEQ	R8, #0				;Retorna para o primeiro estado
	BX 		R10					;return

;################################################################################
; Fim do Arquivo
;################################################################################
    ALIGN                       ;Garante que o fim da seção está alinhada 
;estados dos leds no semaforo
Sem_N	DCB		2_00000011,2_00000011,2_00000011,2_00000011,2_00000010,2_00000001	;vetor que salva o estado do modo N do semaforo
Sem_F	DCB		2_00010001,2_00010000,2_00000001,2_00010001,2_00010001,2_00010001	;vetor que salva o estado do modo F do semaforo
				
    END                          		;Fim do arquivo