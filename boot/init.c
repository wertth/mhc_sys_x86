#include "text_display.h"
int kern_entry() {
    clear();
    write("Hello MOS!!!\n", rc_black, rc_white);
    write("this is the new os", rc_red, rc_green);
    return 0;
}