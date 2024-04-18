#ifndef MEM
#define MEM
#ifdef __cplusplus
extern "C" {
#endif

#include "types.h"
// void mem_set(void* dst, uint32_t len, uint32_t val);

void mem_cpy(void* src, void* dst, uint32_t len);

#ifdef __cplusplus
}
#endif

#ifdef __cplusplus
template <typename T = int32_t>
void mem_set(void* dst, uint32_t len, T val) {
    T* typedDst = static_cast<T*> (dst);
    for(uint32_t i = 0; i < len; ++i) {
        typedDst[i] = val;
    }
}
#endif

#endif