#include "mem.h"

#ifdef __cplusplus


// template void mem_set<uint32_t>(void* dst, uint32_t len, uint32_t val);
// template void mem_set<int>(void* dst, uint32_t len, int val);
#endif
void mem_cpy(void* dst, void* src, uint32_t len) {
    uint8_t* s = static_cast<uint8_t*>(src);
    uint8_t* d = static_cast<uint8_t*>(dst);
    if (dst >= src) {
        s += len - 1;
        d += len - 1;
        for (int32_t i = len - 1; i >= 0; --i) {
            d[i] = s[i]; // 直接逆向复制
        }
    } else {
        for (uint32_t i = 0; i < len; ++i) {
            d[i] = s[i]; // 正向复制
        }
    }
}