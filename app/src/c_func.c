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
