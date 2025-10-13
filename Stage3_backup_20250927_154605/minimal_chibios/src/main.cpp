#include "ch.h"
#include "hal.h"

int main() {
    chSysInit();
    while (true) {
        chThdSleepMilliseconds(500);
    }
    return 0;
}
