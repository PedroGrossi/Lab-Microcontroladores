	THUMB											; Instruções do tipo Thumb-2
;################################################################################
; Definições dos Registradores Gerais.  Obs: *(EQU)=(EQUATE)*
;<NOME>	EQU	<VALOR>
;################################################################################
; Área de Dados - Declarações de variáveis
	AREA  DATA, ALIGN=2
	; Se alguma variável for chamada em outro arquivo
	;EXPORT  <var> [DATA,SIZE=<tam>]	; Permite chamar a variável <var> a 
		                                ; partir de outro arquivo
;<var>	SPACE <tam>                     ; Declara uma variável de nome <var>
                                        ; de <tam> bytes a partir da primeira 
                                        ; posição da RAM		
;################################################################################
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
	AREA    |.text|, CODE, READONLY, ALIGN=2
	; Se alguma função do arquivo for chamada em outro arquivo	
										; outro arquivo. No caso startup.s
	; Se chamar alguma função externa	
	;IMPORT <func>              		; Permite chamar dentro deste arquivo uma 
										; função <func>
	IMPORT  PLL_Init
	IMPORT  SysTick_Init
	IMPORT  SysTick_Wait1ms			
	IMPORT  GPIO_Init
	IMPORT  PortN_Output
	IMPORT  PortJ_Input	
	
	EXPORT	Testar_Chaves
;################################################################################
; Função main()
Testar_Chaves
	MOV		R10, LR
	BL 		PortJ_Input				 	;Chama a subrotina que l? o estado das chaves e coloca o resultado em R0
Verifica_Nenhuma
	CMP		R0, #2_00000011			 	;Verifica se nenhuma chave est? pressionada
	BNE		Verifica_SW1			 	;Se o teste viu que tem pelo menos alguma chave pressionada pula
	BX 		R10
Verifica_SW1	
	CMP		R0, #2_00000010			 	;Verifica se somente a chave SW1 est? pressionada
	BNE		Verifica_SW2             	;Se o teste falhou, pula
	CMP 	R4, #0
	MOVEQ	R4, #1
	MOVNE	R4, #0
	BX 		R10
Verifica_SW2	
	CMP		R0, #2_00000001			 	;Verifica se somente a chave SW2 est? pressionada
	BNE		Verifica_Ambas           	;Se o teste falhou, pula
	BX 		R10
Verifica_Ambas
	CMP		R0, #2_00000000			 	;Verifica se ambas as chaves est?o pressionadas
	BXNE 	R10        		 			;	Se o teste falhou, pula
	BX 		R10

; Fim do Arquivo

	ALIGN                        		;Garante que o fim da seção está alinhada 
    END                          		;Fim do arquivo