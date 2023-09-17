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
		
	IMPORT Verifica_Chaves
	IMPORT SysTick_Wait1ms				; Fun��o de espera
	IMPORT Modo_Operacao
		
;################################################################################
; Fun��o main()
Start  		
	BL		PLL_Init                  	;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL		SysTick_Init				;Chama a subrotina para Inicializar o SysTick
	BL		GPIO_Init       	       	;Chama a subrotina que inicializa os GPIO
	
	MOV 	R8,  #0						;Estado do modo Cavalgada
	MOV		R9,  #0						;Estado do modo Contagem
	MOV		R11, #0						;R11 � o controlador do modo de opera��o -> 0 = cavalgada // 1 = contagem
	MOV		R12, #1000					;R12 � o controlador de velocidade de opera��o -> 1000ms // 500ms // 200ms
	
MainLoop
	BL		Verifica_Chaves				;Verifica as chaves clicadas
	MOV		R0, #100
	BL 		SysTick_Wait1ms
	BL		Modo_Operacao
	MOV		R0, R12
	BL 		SysTick_Wait1ms
	BL		MainLoop
	
;################################################################################
; Fim do Arquivo
;################################################################################
    ALIGN                        		;Garante que o fim da se��o est� alinhada 
    END                          		;Fim do arquivo