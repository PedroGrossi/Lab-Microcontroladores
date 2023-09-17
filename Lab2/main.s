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
		
	IMPORT Verifica_Chaves
	IMPORT SysTick_Wait1ms				; Função de espera
	IMPORT Modo_Operacao
		
;################################################################################
; Função main()
Start  		
	BL		PLL_Init                  	;Chama a subrotina para alterar o clock do microcontrolador para 80MHz
	BL		SysTick_Init				;Chama a subrotina para Inicializar o SysTick
	BL		GPIO_Init       	       	;Chama a subrotina que inicializa os GPIO
	
	MOV 	R8,  #0						;Estado do modo Cavalgada
	MOV		R9,  #0						;Estado do modo Contagem
	MOV		R11, #0						;R11 é o controlador do modo de operação -> 0 = cavalgada // 1 = contagem
	MOV		R12, #1000					;R12 é o controlador de velocidade de operação -> 1000ms // 500ms // 200ms
	
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
    ALIGN                        		;Garante que o fim da seção está alinhada 
    END                          		;Fim do arquivo