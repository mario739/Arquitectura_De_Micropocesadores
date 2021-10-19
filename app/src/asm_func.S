.syntax unified
.thumb
.text

@ Simbolos exportados
.global asm_sum
.global asm_sum64
.global asm_svc
.global asm_zeros
.global asm_productoEscalar32
.global asm_productoEscalar16
.global asm_productoEscalar12_FNS
.global asm_productoEscalar12_FS
.global asm_pack32to16
.global asm_max
.global asm_eco
.global asm_invertir
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   uint32_t asmSum (uint32_t firstOperand, uint32_t secondOperand)
@
@ Parametros recibidos:
@   r0: firstOperand
@   r1: secondOperand
@
@ Valor de retorno:
@   r0: resultado de la suma de firstOperand y secondOperand
@
.thumb_func
    asm_sum:
        add r0, r1  @ r0 = r0 + r1
        bx lr       @ vuelve adonde fue llamada (especificamente, si "pc"
                    @ es la direccion, en el codigo del programa, de la
                    @ instruccion "bl asm_sum" usada para saltar a
                    @ esta funcion, entonces "lr" contiene ese "pc" + 4).
                    @ el valor de retorno debe quedar en el registro r0.
                    @ En este caso, r0 es el resultado de r0 + r1.

        @ Otras alternativas para el retorno
        @ mov pc,lr
        @ bx lr
        @ push {lr} ... pop {pc}



@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   extern uint64_t c_sum64(uint64_t firstOperand64, uint64_t secondOperand64)
@
@ Parametros recibidos:
@   r0,r1: firstOperand
@   r2,r3: secondOperand
@
@ Valor de retorno:
@   r0,r1: resultado de la suma de firstOperand y secondOperand
@
.thumb_func
    asm_sum64:
        add r0, r1  @ r0 = r0 + r1
        bx lr       @ vuelve adonde fue llamada (especificamente, si "pc"
                    @ es la direccion, en el codigo del programa, de la
                    @ instruccion "bl asm_sum" usada para saltar a
                    @ esta funcion, entonces "lr" contiene ese "pc" + 4).
                    @ el valor de retorno debe quedar en el registro r0.
                    @ En este caso, r0 es el resultado de r0 + r1.

        @ Otras alternativas para el retorno
        @ mov pc,lr
        @ bx lr
        @ push {lr} ... pop {pc}

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_zeros (uint32_t * vector ,uint32_t longitud);
@
@ Parametros recibidos:
@   r0: * vector
@   r1: longitud

.thumb_func
    asm_zeros:
        @ Registros usados
	    @ r2: valor cero
		mov r2, 0 @ constante cero
  			.loop:
     			str r2,[r0], 4 @sizeof(uint32_t) ==4, *vector++=r2
     			subs r1, 1      @--longitud s para operaciones aritmeticas para actualizar los bits de estado
     			bne .loop
    		 bx lr


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_productoEscalar32(uint32_t vectorInt[],uint32_t vectorOut[], uint32_t longitud
@								, uint32_t escalar);
@ parametros recibidos

@	r0 :vectorInt[]
@	r1 :vectorOut[]
@ 	r2 :longitud
@	r3 : escalar

.thumb_func
    asm_productoEscalar32:
      push {r4}   			@Se pushean el registro r4 para guardar el contexto antes del llamado a la funcion
    	.loopPE32:
		 ldr  r4,[r0],4		    @Se carga en el registro r4 el primer valor del vector de entrada y luego se le suma 4
		 					    @	para moverse cuatro posiciones
	     mul  r4,r3   			@ Se multiplica el valor del registro r4 con el escalar que se encuentra en r3
	     str  r4,[r1],4 	    @ Se guarda en vectorOut lo del r4
         subs r2, 1				@ Se decrementar el contador
	  	bne .loopPE32			@ Ejucucion condicional
	     pop  {r4}				@ Se reponen los registros para volver al contexto anterior
     	 bx lr


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_productoEscalar16(uint16_t * vectorInt,  uint16_t * vectorOut, uint32_t longitud,
@   							uint16_t escalar)
@
@ Parametros recibidos:
@   r0: * vectorInt
@   r1: * vectorOut
@   r2: longitud
@   r3: escalar
@ Parametros de función
@   r4: Registro usado para hacer las operaciones de load-store
@
.thumb_func
		asm_productoEscalar16:
    		push {r4}           	@ Se guarda el r4 para mantener el contexto anterior intacto
    		.loopPE16:
        		ldrh r4, [r0],2 	@ Se carga en r4 lo apuntado por r0 es pone sufijo h por que es media palabra
        							@  			y se recorreo 2 byter por que el dato es de 16bits
        		mul r4, r3		  	@ Se multiplica el escalar por el datos en r4
        		strh r4, [r1],2 	@ Se cargar el dato de r4 a la posicion de memoria que apunta el r1 se pone h
        							@			para especificar que es media palabra y se avanza 2 bytes en el vector
        		subs r2,1      	@ Se decrementa el contador de longitud

        	bne .loopPE16 		@ Salto condicional
    		pop	{r4}            	@ Se retorna el registro como estaba antes del llamado a la funcion
    		bx lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_productoEscalar12_FNS (uint16_t* vectorInt, uint16_t* vectorOut, uint32_t longitud, uint16_t escalar)
@
@ Parametros recibidos:
@   r0: * vectorInt
@   r1: * vectorOut
@   r2: longitud
@   r3: escalar
@ Parametros de función
@   r4: Registro usado para hacer las operaciones de load-store
@	r5: Registro usado para hacer las operaciones de load-store
@
.thumb_func
		asm_productoEscalar12_FNS:

		push {r4}
		push {r5}					@ Se guarda el r4, r5 para mantener el contexto anterior intacto
		mov r5, 0					@ Se carga 0 al registro r5
   		   .loopPE12FNS:
 				ldrh r4,[r0], 2  	@ Se carga en r4 lo apuntado por r0 es pone sufijo h por que es media palabra
				mul r4, r3		 	@ @ Se multiplica el escalar por el datos en r4 y se almacena en r4
				cmp r5, r4, lsr 12  @ Sehace la comparacion del registro r5 con r4 desplasado 12 posiciones a la derecha
				beq  .nosaturo
		     	movw r4,# 4095		@ Se carga el valor de 4095 a r4
    		 .nosaturo:
				strh r4, [r1], 2    @ Se cargar el dato de r4 a la posicion de memoria que apunta en r1 se pone h
        							@			para especificar que es media palabra y se avanza 2 bytes en el vector
				subs r2, 1  		@ Se decrementa el registro r2 que es la longitud
				bne .loopPE12FNS
		pop {r4} 					@ Se restauran los valores de r4 y r5
		pop {r5}
		bx lr


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_productoEscalar12_FS (uint16_t* vectorInt, uint16_t* vectorOut, uint32_t longitud, uint16_t escalar)
@
@ Parametros recibidos:
@   r0: * vectorInt
@   r1: * vectorOut
@   r2: longitud
@   r3: escalar
@ Parametros de función
@   r4: Registro usado para hacer las operaciones de load-store
@	r5: Registro usado para hacer las operaciones de load-store
@
.thumb_func
		asm_productoEscalar12_FS:

		push {r4}				@ Se guarda el registro r4  para mantener el contexto anterior intacto
   		   .loopPE12FS:
 				ldrh r4,[r0], 2  	@ Se carga en r4 lo apuntado por r0 es pone sufijo h por que es media palabra
				mul r4, r3		 	@ Se multiplica el escalar por el datos en r4 y se almacena en r4
				usat r4,12,r4       @ Si el valor en el registro r4 es mayor 12bits coloca 4095 en r4
				strh r4, [r1], 2    @ Se cargar el dato de r4 a la posicion de memoria que apunta en r1 se pone h
        							@			para especificar que es media palabra y se avanza 2 bytes en el vector
				subs r2, 1  		@ Se decrementa el registro r2 que es la longitud
				bne .loopPE12FS
		pop {r4} 					@ Se restauran los valores de r4
		bx lr



@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_pack32to16 (int32_t * vectorInt, int16_t *vectorOut, uint32_t longitud)
@
@ Parametros recibidos:
@   r0: * vectorInt
@   r1: * vectorOut
@   r2: longitud
@ Parametros de función
@   r4: Registro usado para hacer las operaciones de load-store

.thumb_func
		asm_pack32to16:

		push {r4}					@ Se guarda el registro r4  para mantener el contexto anterior intacto
   		   .loopPack32to16:
 				ldr r4,[r0],4  		@ Se carga en r4 lo apuntado por r0
				ssat r4,#16,r4      @ Se satura a 16bits con signo
				strh r4,[r1],2      @ Se cargar el dato de r4 a la posicion de memoria que apunta en r1 se pone h
    								@			para especificar que es media palabra y se avanza 2 bytes en el vector
				subs r2, 1  		@ Se decrementa el registro r2 que es la longitud
				bne .loopPack32to16
		pop {r4} 					@ Se restauran los valores de r4
		bx lr



@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   int32_t asm_max(int32_t * vectorInt, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: * vectorInt
@   r1: longitud
@ Parametros de función
@   r2:posicion
@	r4=
@	r3:maximo valor
@   r5: valor maximo del vector
@
.thumb_func
		asm_max:
			push {r4-r5}				@ Se guardan los reistros r4 y r5
				mov r5,r1 				@ Se carga en r5 la longitud del vector
				mov r3,r0
			.loopasmmax:
 				ldr r4,[r0],4  		    @ Se carga en r4 lo apuntado por r0
				cmp r4,r3				@ Se comparan los registro r4 y r3
				bge .menor
				mov r3,r0				@ Se carga en r3 lo del r0
				mov r2,r1
		.menor:
				subs r1, 1              @ Decrementa el contador
          		bne .loopasmmax
				sub r0, r5, r2          @ Asigna en r0 la posicion
    		pop	{r4-r5}                 @ Devuelve el contexto
    			bx lr

@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   asm_invertir (uint16_t * vector, uint32_t longitud);
@
@ Parametros recibidos:
@   r0: vectorInt
@   r1: longitud
@ Parametros de función
@   r2: registro auxiliar
@	r3: logitud
@	r4:
@	r5:vector auxiliar
   @ r7 :
   @r8:
.thumb_func
		asm_invertir:
				push {r4-r8}
				mov r3,r1
				mov r7,r0
				mov r8,r0
		.loop_bucle_one:
				ldrh r2,[r8],2
				strh r2,[r5],2
				add  r7,2
				subs r1,1
			 bne .loop_bucle_one
		.loop_bucle_dos:
				ldrh r2,[r7],-2
		        strh r2,[r0],2
				subs r3,1              @ Decrementa el contador
		    bne .loop_bucle_dos              @ Vuelve a .loop_invertir cuando Z es ditinto de cero
				pop	{r4-r8}                    @ Devuelve el contexto
				bx lr                       @ Vuelve adonde fue llamada


@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@  		asm_eco (uint16_t * vectorIn, uint16_t * vectorOut);
@
@ Parametros recibidos:
@   r0: * vectorInt
@   r1: * vectorOut
@ Parametros de función
@   r2:	logitud del vector
@	r3:	eco

.thumb_func
		asm_eco:
			push {r4-r7}		@ Se guardan los registros r4 al r7
			mov r2,10			@ Cargo al registro r2 la longitud del vector
			movw r3,2			@ Cargo al registro r3 la longitud del eco
		.loop_sineco:
			ldr  r1,[r0],4		@ Se carga en Vo lo del registro vInt
			subs r3,1			@ Se resta uno al contador
			bne .loop_sineco
			sub r2,2			@ Se resta a longitud la logitude del eco
		.loop_coneco:
			shadd16 r4, r1, r0	@ instruccion SIMDE
			str 	r4,[r1], 4  @ Se guarda el la instruccion de la suma y la division en Vou
			subs r2,1
			bne .loop_coneco
          	pop {r4-r7}
    		bx lr




@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@ Prototipo en "C":
@   void asm_svc (void)
@

.thumb_func
    asm_svc:
        svc 0
        bx lr
