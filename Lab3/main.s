; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Ex4: Uso de GPIO com interrup�ao
; Prof. Guilherme de S. Peron	- 12/03/2018
; Prof. Marcos E. P. Monteiro	- 12/03/2018
; Prof. DaLuz           		- 25/02/2022

;################################################################################
; Este programa espera o usu�rio apertar a chave USR_SW1 e/ou a chave USR_SW2.
; Caso o usu�rio pressione a chave USR_SW1, acender� o LED2. Caso o usu�rio pressione 
; a chave USR_SW2, acender� o LED1. Caso as duas chaves sejam pressionadas, os dois 
; LEDs acendem.
;################################################################################

;################################################################################
        THUMB                        ; Instru��es do tipo Thumb-2
;################################################################################
; Defini��es de Valores
BIT0	EQU 2_0001
BIT1	EQU 2_0010
;################################################################################
; �rea de Dados - Declara��es de vari�veis
		AREA  DATA, ALIGN=2
		; Se alguma vari�vel for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a vari�vel <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma vari�vel de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posi��o da RAM		
;################################################################################
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a fun��o Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma fun��o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun��o <func>
		IMPORT  GPIO_Init
        IMPORT  PortN_Output
        IMPORT  PortJ_Input
;################################################################################
; Fun��o main()
Start  			
	BL		GPIO_Init					;Chama a subrotina que inicializa os GPIO

MainLoop
	CMP		R4, #1						;Passou pela IRQ?
	BEQ		IRQAtivada					;Sim: ==> Tratar o retorno da IRQ
	B		MainLoop					;Volta para o la�o principal	
IRQAtivada
	CMP		R5,#3						;Bot�o pressionado SW1 Brd Subida
	BEQ		ApagaLed					;
	CMP		R5,#2						;Bot�o pressionado SW2 Brd descida
	BEQ		LigaLed						;
	B		MainLoop					;outros casos de bot�es n�o tratar
LigaLed	
	MOV		R4,#0						;Flag=0
	MOV		R0,#10						;Led ON
	BL		PortN_Output				;Liga Led
	B		MainLoop
ApagaLed
	MOV		R4,#0						;Flag=0
	MOV		R0,#01						;Led OFF
	BL		PortN_Output				;Desliga Led
	B		MainLoop

    ALIGN                        		;Garante que o fim da se��o est� alinhada 
    END                          		;Fim do arquivo