#include "ch.h"
#include "hal.h"

static THD_WORKING_AREA(waThread1, 128);
static THD_FUNCTION(Thread1, arg) {
    (void)arg;
    chRegSetThreadName("blinker");
    while (true) {
        palTogglePad(GPIOD, GPIOD_LED12);
        chThdSleepMilliseconds(500);
    }
}

int main(void) {
    halInit();
    chSysInit();
    chThdCreateStatic(waThread1, sizeof(waThread1), NORMALPRIO, Thread1, NULL);
    while (true) {
        chThdSleepMilliseconds(1000);
    }
}
