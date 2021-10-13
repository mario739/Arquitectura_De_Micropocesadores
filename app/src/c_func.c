#include "c_func.h"


uint32_t c_sum (uint32_t firstOperand, uint32_t secondOperand)
{
    return (firstOperand + secondOperand);
}

uint64_t c_sum64(uint64_t firstOperand64, uint64_t secondOperand64)
{
	return (firstOperand64 + secondOperand64 );
}

void c_zeros (uint32_t * vector ,uint32_t longitud)
{
	uint32_t i;
	for(i = 0; i < longitud; i++)
	{
		vector[i] = 0;
	}
}

void c_productoEscalar32(uint32_t vectorInt[], uint32_t vectorOut[], uint32_t longitud, uint32_t escalar)
{
    for (uint32_t i = 0; i < longitud; i++)
    {
    	vectorOut[i] = vectorInt[i]*escalar;
    }
}

void c_productoEscalar16(uint16_t *vectorInt, uint16_t *vectorOut, uint32_t longitud, uint16_t escalar)
{
    for (uint32_t i = 0; i < longitud; i++)
    {
    	vectorOut[i] = vectorInt[i]*escalar;
    }
}

void c_productoEscalar12 (uint16_t* vectorInt, uint16_t* vectorOut, uint32_t longitud, uint16_t escalar)
{

	for(uint32_t i = 0 ; i < longitud ; i++)
	{
		vectorOut[i] = vectorInt[i] * escalar;
		if (vectorOut[i] > 4095)
			vectorOut[i] = 4095;
    }

}
void c_pack32to16 (int32_t * vectorInt, int16_t *vectorOut, uint32_t longitud)
{

	for(uint32_t i = 0 ; i < longitud ; i++)
		{
			vectorOut[i]=vectorInt[i]>>16;
		}
}
void c_filtroVentana10(uint16_t * vectorIn, uint16_t * vectorOut, uint32_t longitudVectorIn)
{
	    uint32_t acumulador = 0;

		for(uint32_t i = 0; i < longitudVectorIn; i++)
		{
		    uint16_t longitud = (longitudVectorIn - i);

		    if(longitud > 10)
		    {
		        longitud = 10;
		    }

			for(uint32_t j = 0;j < longitud; j++)
	        {
	            acumulador = acumulador + vectorIn[i+j];
	        }

	        vectorOut[i] = acumulador/10;
	        acumulador = 0;
		}
}



