#pragma once

#include <stdint.h>


extern uint32_t asm_sum (uint32_t firstOperand, uint32_t secondOperand);
extern uint64_t asm_sum64(uint64_t firstOperand64, uint64_t secondOperand64);
extern void asm_zeros (uint32_t * vector ,uint32_t longitud);
extern void asm_productoEscalar32(uint32_t *vectorInt,uint32_t *vectorOut,uint32_t longitud,uint32_t escalar);
extern void asm_productoEscalar16(uint16_t *vectorInt,uint16_t *vectorOut,uint32_t longitud,uint16_t escalar);
extern void asm_productoEscalar12_FNS(uint16_t *vectorInt,uint16_t *vectorOut,uint32_t longitud,uint16_t escalar);
extern void asm_productoEscalar12_FS(uint16_t *vectorInt,uint16_t *vectorOut,uint32_t longitud,uint16_t escalar);
extern void asm_eco (uint16_t * vectorIn, uint16_t * vectorOut);
extern void asm_pack32to16 (int32_t * vectorInt, int16_t *vectorOut, uint32_t longitud);
extern int32_t asm_max(int32_t * vectorInt, uint32_t longitud);
extern void asm_svc (void);

