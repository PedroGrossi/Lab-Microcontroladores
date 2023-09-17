; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme de S. Peron	- 12/03/2018
; Prof. Marcos E. P. Monteiro	- 12/03/2018
; Prof. DaLuz           		- 25/02/2022
; Pedro Henrique Grossi da Silva- 27/05/2023

;################################################################################

; Este programa atende ao laboratorio 2 

;################################################################################
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
    EXPORT Start                		; Permite chamar a função Start a partir de 
										; outro arquivo. No caso startup.s
	; Se chamar alguma função externa	
	;IMPORT <func>              		; Permite chamar dentro deste arquivo uma 
										; função <func>
	IMPORT PLL_Init
	IMPORT SysTick_Init
	IMPORT GPIO_Init
		
	IMPORT SysTick_Wait1ms				; Função de espera
	IMPORT Sinal
		
;################################################################################
; Função main()
Start  		
	BL		PLL_Init                  	;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL		SysTick_Init				;Chama a subrotina para Inicializar o SysTick
	BL		GPIO_Init       	       	;Chama a subrotina que inicializa os GPIO
	
	MOV		R8, #0						;Estado da maquina
	MOV		R9, #0						;Guarda LR
	MOV		R10, #0						;Guarda LR
	MOV		R11, #0						;Verifica pedestre
	
MainLoop
	
	BL		Sinal
	B		MainLoop

;################################################################################
; Fim do Arquivo
;################################################################################
    ALIGN                        		;Garante que o fim da seção está alinhada 
    END                          		;Fim do arquivo