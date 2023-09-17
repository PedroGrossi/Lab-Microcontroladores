; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme de S. Peron	- 12/03/2018
; Prof. Marcos E. P. Monteiro	- 12/03/2018
; Prof. DaLuz           		- 25/02/2022
; Pedro Henrique Grossi da Silva- 27/05/2023

;################################################################################

; Este programa atende ao laboratorio 2 

;################################################################################
	THUMB											; Instru��es do tipo Thumb-2
;################################################################################
; Defini��es dos Registradores Gerais.  Obs: *(EQU)=(EQUATE)*
;<NOME>	EQU	<VALOR>
;################################################################################
; �rea de Dados - Declara��es de vari�veis
	AREA  DATA, ALIGN=2
	; Se alguma vari�vel for chamada em outro arquivo
	;EXPORT  <var> [DATA,SIZE=<tam>]	; Permite chamar a vari�vel <var> a 
		                                ; partir de outro arquivo
;<var>	SPACE <tam>                     ; Declara uma vari�vel de nome <var>
                                        ; de <tam> bytes a partir da primeira 
                                        ; posi��o da RAM		
;################################################################################
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
	AREA    |.text|, CODE, READONLY, ALIGN=2
	; Se alguma fun��o do arquivo for chamada em outro arquivo	
    EXPORT Start                		; Permite chamar a fun��o Start a partir de 
										; outro arquivo. No caso startup.s
	; Se chamar alguma fun��o externa	
	;IMPORT <func>              		; Permite chamar dentro deste arquivo uma 
										; fun��o <func>
	IMPORT PLL_Init
	IMPORT SysTick_Init
	IMPORT GPIO_Init
		
	IMPORT SysTick_Wait1ms				; Fun��o de espera
	IMPORT Sinal
		
;################################################################################
; Fun��o main()
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
    ALIGN                        		;Garante que o fim da se��o est� alinhada 
    END                          		;Fim do arquivo