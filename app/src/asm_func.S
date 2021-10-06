.syntax unified
.thumb
.text

@ Simbolos exportados
.global asm_sum
.global asm_sum64
.global asm_svc
.global asm_zeros
.global asm_productoEscalar32

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
@   void asm_productoEscalar32(uint32_t *vectorInt,uint32_t *vectorOut, uint32_t longitud
@								, uint32_t escalar);
@ parametros recibidos

@	r0 :*vector
@	r1 :*vectorOut
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
@   void asm_svc (void)
@

.thumb_func
    asm_svc:
        svc 0
        bx lr
