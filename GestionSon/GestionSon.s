	PRESERVE8
	THUMB   
		
	export GestionSon_callback
	export GestionSon_Start
		
	import Son
	import LongueurSon
		
	import ServJeuLASER_WritePWMSoundVal
	import PWM_Set_Value_TIM3_Ch3
    
	;include GestionSon.inc

; ====================== zone de réservation de données,  ======================================
;Section RAM (read only) :
	area    mesdata,data,readonly


;Section RAM (read write):
	area    maram,data,readwrite
GestionSon_Index DCD 0
	export GestionSon_Index	;index actuel

SortieSon DCD 0 
	export SortieSon		;echantillon


	
; ===============================================================================================

		
;Section ROM code (read only) :		
	area    moncode,code,readonly
		
; écrire le code ici	

GestionSon_Start proc
	ldr r0, =GestionSon_Index 	;1 charge adresse de Gestion dans R0
	
	ldr r1,[r0] 				;1 charge valeur de R0(Gestion) dans R1
	mov r1, #0 					;1 reset de gestion idex
	
	str r1, [r0] 				;1 stocke R1 dans R0 (Gestion)
	;bl GestionSon_callback		;reset alors saut à callback
	bx lr
	endp
	

	
GestionSon_callback proc
	push {r4-r11,lr}			;sauvegarde des registres non modifiable
	
	
	
	;charge GestionSon_Index dans R2
	ldr r1, =GestionSon_Index 	;1 charge adresse de Gestion dans R1
	ldr r2,[r1] 				;1 charge valeur de R1(Gestion) dans R2
	
	;charge LongueurSon dans R3
	ldr r3, =LongueurSon		;2 charge adresse LongueurSon dans R3
	ldr r3, [r3]				;2 charge valeur de R3 (LongueurSon) dans R3
	
	;fin si GestionSon_Index >= LongueurSon
	cmp r2, r3					;2 compare index GestionSon et LongueurSon, 
	

	bge fin_callback		;2 jump si greater or equal sur fin_callback

	
	;charge Son dans R4 et Son(index) dans R6
	ldr r4, =Son				;3 charge adresse de Son dans R4
	
	add r5, r2, r2				;3 r5 = index (short int = 2 octets)
	add r5, r5, r4				;3 r5 = &Son(0+ décalage)
	ldrsh r6,[r5]				;3 recuperation des 16 bits signé dans r6
	
	;ldrsh r6,[r5,r4, lsl #1] à verifier
	
	
	;Faire ratio de l'echantillon
	mov r5,#720					; r5 = 720
	add r6, r6, #32768			; echantillon += 32768
	mul r6, r6,r5				; echantillon *= 720
	asr r6, r6, #16				; echantillon = echantillon >>16 ou 15
	;TEST
	
	
	;PAS FAIRE MODULO
;	R6 modulo 719
;	add r6, r6, #32768			;4 ajout borne max
;	mov r5,#719
;	
;	cmp r6,r5					;4 compare r6 avec 719
;	ble fin_modulo				;4 si r6 <= 719 jump fin_modulo
;	;sub r6,r6,#720				;4 R6 = R6 - 719
;	;b debut_modulo	;4 jump direct à debut_modulo pour retester
;	
;	udiv r8, r6, r5				;4 r8 = r6/r5
;	mul r8, r8, r5				;4 r8*r5
;	sub r6, r6,r8				;4 r6=r6-r8
;fin_modulo
	
	;5 r6 modulé dans SortieSon
	ldr r7, =SortieSon 			;5 charge adresse de SortieSon dans R7
	str r6, [r7] 				;5 stocke R6 dans R7(SortieSon)
	

	;incrementation Gestion car réussi
	add r2, r2, #1 				;1 incrementation
	str r2, [r1] 				;1 stocke R2 dans R1 (Gestion)
	
	
	;6 On va PWM la valeur
	mov r0, r6 					;6 retourne R0
	
	push{r0-r3}
	bl PWM_Set_Value_TIM3_Ch3;ServJeuLASER_WritePWMSoundVal ;6 valeur return dans portb.0
	pop{r0-r3}

	
	
	
	
	mov r0, r2 					;1 retourne R0 j'crois inutile
fin_callback
	pop {r4-r11,lr}			;restaurer les registres non modifiable
	bx lr
	endp

		
		
	END	