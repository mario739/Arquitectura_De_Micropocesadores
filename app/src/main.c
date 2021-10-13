#include "board.h"
#include "c_func.h"
#include "asm_func.h"

#include <stdlib.h>
#include <stdnoreturn.h>


// Variable que se incrementa cada vez que se llama al handler de interrupcion
// del SYSTICK.
static volatile uint32_t s_ticks = 0;


// Inicia soporte de la placa y periodo de la interrupcion del SYSTICK
// cada 1 milisegundo.
static void Inicio (void)
{
    Board_Init ();
    SystemCoreClockUpdate ();
    SysTick_Config (SystemCoreClock / 1000);
}
static void Zeros(void)
{
    uint32_t vector[8]={(uint32_t)-1,(uint32_t)-2,(uint32_t)-3,(uint32_t)-4,(uint32_t)-5,(uint32_t)-6,(uint32_t)-7,(uint32_t)-8};
    asm_zeros(vector,8);

}



static void ProductoEscalar32(void)
{
	uint32_t asm_vectorInt[8]={1,2,3,4,5,6,7,8};
	uint32_t asm_vectorOut[8]={0,0,0,0,0,0,0,0};

	uint32_t c_vectorInt[8]={6,5,3,2,6,7,8,9};
	uint32_t c_vectorOut[8]={0,0,0,0,0,0,0,0};

 	uint32_t escalar=2;

 	c_productoEscalar32(c_vectorInt, c_vectorOut,8,escalar);
 	asm_productoEscalar32(asm_vectorInt,asm_vectorOut,8,escalar);
}


static void ProductoEscalar16(void)
{
	uint16_t asm_vectorInt[8]={1,2,3,4,5,6,7,8};
	uint16_t asm_vectorOut[8]={0,0,0,0,0,0,0,0};

	uint16_t c_vectorInt[8]={2,4,6,8,10,12,14,16};
	uint16_t c_vectorOut[8]={0,0,0,0,0,0,0,0};

 	uint16_t escalar=2;

 	c_productoEscalar16(c_vectorInt,c_vectorOut,8,escalar);
 	asm_productoEscalar16(asm_vectorInt,asm_vectorOut,8,escalar);
}


static void ProductoEscalarConSaturacion12(void)
{
	uint16_t asm_vectorInt[8]={1,2,3,4,5,6,7,8};
	uint16_t asm_vectorOut[8]={0,0,0,0,0,0,0,0};

	uint16_t c_vectorInt[8]={2,4,6,8,10,12,14,16};
    uint16_t c_vectorOut[8]={0,0,0,0,0,0,0,0};


	uint16_t escalar=1500;

	//c_productoEscalar12 (c_vectorInt,c_vectorOut,8,escalar);
    asm_productoEscalar12_FNS(asm_vectorInt,asm_vectorOut,8,escalar);
}



// Segun la configuracion realizada en Inicio(), este handler de interrupcion
// se ejecutara cada 1 milisegundo.
void SysTick_Handler (void)
{
    ++ s_ticks;
}


static void Suma (void)
{
    const uint32_t A = 20;
    const uint32_t B = 30;

    const uint64_t A64=0x1111111111111111;
    const uint64_t B64=0x2233445566778899;

    const uint64_t SumResult64_C=c_sum64(A64,B64);
    const uint64_t SumResult64_Asm=asm_sum64(A64,B64);

    const uint32_t SumResult_C = c_sum (A, B);
    const uint32_t SumResult_Asm = asm_sum (A, B);

    // Actividad de debug: SumResult_C y SumResult_Asm deberian contener el
    // mismo valor.
    __BKPT (0);

    (void) SumResult_C;
    (void) SumResult_Asm;
}


static void LlamandoAMalloc (void)
{
    // De donde saca memoria malloc?
    // (se vera en clase)
    void * ptr = malloc (2048);

    (void) ptr;
}


static void PrivilegiosSVC (void)
{
    // Obtiene valor del registro de 32 bits del procesador llamado "control".
    // El registro guarda los siguientes estados:
    // bit 2: Uso de FPU en el contexto actual. Usado=1, no usado=0.
    // bit 1: Mapeo del stack pointer(sp). MSP=0, PSP=1.
    // bit 0: Modo de ejecucion en Thread. Privilegiado=0, No privilegiado=1.
    //        Recordar que este valor solo se usa en modo Thread. Las
    //        interrupciones siempre se ejecutan en modo Handler con total
    //        privilegio.
    uint32_t x = __get_CONTROL ();

    // Actividad de debug: Ver registro "control" y valor de variable "x".
    __BKPT (0);

    x |= 1;
    // bit 0 a modo No privilegiado.
    __set_CONTROL (x);

    // En este punto se estaria ejecutando en modo No privilegiado.
    // Lectura del registro "control" para confirmar.
    x = __get_CONTROL ();

    // Actividad de debug: Ver registro "control" y valor de variable "x".
    __BKPT (0);

    x &= ~1u;
    // Se intenta volver a modo Privilegiado (bit 0, valor 0).
    __set_CONTROL (x);

    // Confirma que esta operacion es ignorada por estar ejecutandose en modo
    // Thread no privilegiado.
    x = __get_CONTROL ();

    // Actividad de debug: Ver registro "control" y valor de variable "x".
    __BKPT (0);

    // En este punto, ejecutando en modo Thread no privilegiado, la unica forma
    // de volver a modo privilegiado o de realizar cualquier cambio que requiera
    // modo privilegiado, es pidiendo ese servicio a un hipotetico sistema
    // opertivo de tiempo real.
    // Para esto se invoca por software a la interrupcion SVC (Supervisor Call)
    // utilizando la instruccion "svc".
    // No hay intrinsics para realizar esta tarea. Para utilizar la instruccion
    // es necesario implementar una funcion en assembler. Ver el archivo suma.S.
    asm_svc ();

    // El sistema operativo (el handler de SVC) deberia haber devuelto el modo
    // de ejecucion de Thread a privilegiado (bit 0 en valor 0).
    x = __get_CONTROL ();

    // Fin del ejemplo de SVC
}



// Handler de la interrupcion "SVC" (Supervisor Call).
// Usado por el ejemplo "EjemploPrivilegiosSVC".
void SVC_Handler (void)
{
    // Se obtiene el valor del registro "control". El bit 0 indica el nivel
    // de privilegio en modo "Thread". Deberia ser 1: No privilegiado.
    uint32_t x = __get_CONTROL ();

    // Borra el bit 0. Nuevo valor 0: privilegiado.
    x &= ~1u;

    // Asigna el nuevo valor al registro "control". Esta operacion deberia
    // ejecutarse ya que todo manejador de interrupciones se ejecuta en modo
    // "Handler" con total privilegio.
    __set_CONTROL (x);
}


noreturn void LoopInfinito (void)
{
    while (1)
    {
        // Procesador en modo espera hasta que ocurra una interrupcion
        // (Bajo consumo)
        __WFI();
    }
}


int main (void)
{
    Inicio ();
    //Zeros();
    //ProductoEscalar32();
    //ProductoEscalar16();
    ProductoEscalarConSaturacion12();
    //Suma ();

    //PrivilegiosSVC ();

    //LlamandoAMalloc ();

    LoopInfinito ();
}
