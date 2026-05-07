#include "NuMicro.h"

#include "bridge_hw_abstraction.h"
#include "bridge_host_link.h"
#include "bridge_nuvoisp_can.h"

static void systick_init(void)
{
    if (SysTick_Config(SystemCoreClock / 1000u)) {
        while (1) {
        }
    }
}

void SysTick_Handler(void)
{
    bridge_nuvoisp_can_tick_1ms();
}

int main(void)
{
    bridge_hw_board_init();
    bridge_hw_uart_init();
    systick_init();

    bridge_nuvoisp_can_init();
    host_link_init(bridge_nuvoisp_can_handle_request);

    while (1) {
        host_link_poll_uart();
        bridge_nuvoisp_can_poll();
    }
}
