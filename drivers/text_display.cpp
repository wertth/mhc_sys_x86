#include "common.h"
#include "text_display.h"
#include "mem.h"

// VGA format
// 0xB8000 ~ 0xBfa0
static uint16_t * textDisplayAddr = (uint16_t*) 0xB8000;

static uint8_t cursor_x = 0;
static uint8_t cursor_y = 0;

const static uint8_t attr = (0 << 4) | (15 & 0x0F);
const static uint16_t blank_char = (attr << 8) | 0x20;


static void cursor_move() {
    uint16_t location = cursor_y * 80 + cursor_x;


    outb(0x3D4, 14);
    outb(0x3D5, location >> 7);
    outb(0x3D5, 15);
    outb(0x3d5, location);
}

static void scroll() {
    if(cursor_y >= 25) {
        mem_cpy(textDisplayAddr+80, textDisplayAddr, 24*80);
        mem_set(textDisplayAddr+ 24*80, 80, blank_char);
        cursor_y = 24;
    }
}


void clear() {
    mem_set(textDisplayAddr,25*80, blank_char);
    cursor_x = 0 , cursor_y = 0;
    cursor_move();
}

void putc_color(char c, real_color_t back, real_color_t fore) {
    uint8_t back_color = (uint8_t)back;
	uint8_t fore_color = (uint8_t)fore;

    uint8_t attrByte = (back_color << 4) | (15 & fore_color);
    uint16_t attribute = attrByte << 8;
	// 0x08 是 退格键 的 ASCII 码
	// 0x09 是 tab 键 的 ASCII 码
	if (c == 0x08 && cursor_x) {
	      cursor_x--;
	} else if (c == 0x09) {
	      cursor_x = (cursor_x+8) & ~(8-1);
	} else if (c == '\r') {
	      cursor_x = 0;
	} else if (c == '\n') {
		cursor_x = 0;
		cursor_y++;
	} else if (c >= ' ') {
		textDisplayAddr[cursor_y*80 + cursor_x] = c | attribute;
		cursor_x++;
	}

	// 每 80 个字符一行，满80就必须换行了
	if (cursor_x >= 80) {
		cursor_x = 0;
		cursor_y ++;
	}

	// 如果需要的话滚动屏幕显示
	scroll();

	// 移动硬件的输入光标
	cursor_move();
}

// void write(char* str) {
//     write(str, rc_black, rc_white);
// }
void write(char* str, real_color_t back, real_color_t fore) {
    while(*str) {
        putc_color(*str++, back, fore);
    }
}



