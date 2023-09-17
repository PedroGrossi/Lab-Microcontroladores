	THUMB											; Instruções do tipo Thumb-2
	AREA  DATA, ALIGN=2
	AREA    |.text|, CODE, READONLY, ALIGN=2

	IMPORT  GPIO_Init
	IMPORT  PortJ_Input	
	
	EXPORT	Testar_Chaves

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
	CMP		R12, #1000
	MOVEQ	R12, #500
	BXEQ 	R10
	CMP		R12, #500
	MOVEQ	R12, #200
	BXEQ 	R10
	MOV		R12, #1000
	BX	 	R10
Verifica_Ambas
	CMP		R0, #2_00000000			 	;Verifica se ambas as chaves est?o pressionadas
	BXNE 	R10        		 			;	Se o teste falhou, pula
	CMP 	R4, #0
	MOVEQ	R4, #1
	MOVNE	R4, #0
	CMP		R12, #1000
	MOVEQ	R12, #500
	BXEQ 	R10
	CMP		R12, #500
	MOVEQ	R12, #200
	BXEQ 	R10
	MOV		R12, #1000
	BX 		R10

	ALIGN                        		;Garante que o fim da seção está alinhada 
    END                          		;Fim do arquivo