	THUMB											; Instruções do tipo Thumb-2
	AREA  DATA, ALIGN=2
	AREA    |.text|, CODE, READONLY, ALIGN=2

	IMPORT  GPIO_Init
	IMPORT  PortN_Output
	IMPORT  PortF_Output	
	
	EXPORT	Acender_Leds

passeio_N	DCB	2_0010, 2_0001, 0000, 0000, 0000, 2_0001
passeio_F	DCB	0, 0, 2_10000, 2_1, 2_10000, 0
contador_N	DCB	2_0000, 2_00000, 2_00000, 2_00000, 2_0001, 2_0001, 2_0001, 2_0001, 2_0010, 2_0010, 2_0010, 2_0010, 2_0011, 2_0011, 2_0011, 2_0011
contador_F	DCB	2_0000, 2_0001, 2_10000, 2_10001, 2_0000, 2_0001, 2_10000, 2_10001, 2_0000, 2_0001, 2_10000, 2_10001, 2_0000, 2_0001, 2_10000, 2_10001		

Acender_Leds
	MOV		R10, LR
	CMP 	R4, #0
	BLEQ	Passeio
	BLNE	Contador
	
Passeio
	LDR 	R6, =passeio_N
	LDR 	R7, =passeio_F
	LDR 	R0, [R6, R5]                   	
	BL		PortN_Output			 	
	LDR 	R0, [R7, R5]   
	BL		PortF_Output
	CMP 	R5, #5
	ADDNE 	R5, R5, #1
	MOVEQ 	R5, #0
	BX		R10
	
Contador
	LDR 	R8, =contador_N
	LDR 	R9, =contador_F
	LDR 	R0, [R8, R11]                   	
	BL		PortN_Output			 	
	LDR 	R0, [R9, R11]   
	BL		PortF_Output
	CMP 	R11, #15
	ADDNE 	R11, R11, #1
	MOVEQ 	R11, #0
	BX		R10

	ALIGN                        		;Garante que o fim da seção está alinhada 
    END                          		;Fim do arquivo