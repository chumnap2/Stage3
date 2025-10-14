# Stage4: MotorComponent + Real Hardware Interface

## Overview
Stage4 integrates the `MotorComponent` with real hardware (STM32 + VESC) while maintaining the same Julia telemetry interface.  
Currently, a mock firmware simulates motor RPM and position for testing without hardware.

## Mock Hardware Setup
cd ~/fprime/Stage3/Stage4/Firmware/STM32
g++ main.cpp motor_driver.cpp -o motor_mock -std=c++17
./motor_mock

## Julia Telemetry Visualization
cd ~/fprime/Stage3/Stage4
julia Telemetry/motor_telemetry.jl

> Ensure `GLMakie` and `Sockets` are installed:
import Pkg
Pkg.add(["GLMakie", "Sockets"])

## Transition to Real STM32 + VESC
- Replace `motor_driver.cpp` with real STM32 + ChibiOS UART implementation.
- Wire STM32 TX/RX/GND to VESC (and common GND with motor power supply).  
- Julia visualizer works with real telemetry if UDP format `[Float32 rpm, Float32 position]` is preserved.  
- Safety: limit maximum RPM and monitor motor faults.

## Notes
- Stage4 firmware tagged **v4.0**.  
- Mock firmware is for testing pipeline and dashboards before real hardware.  

## References
- [ChibiOS Documentation](http://www.chibios.org/dokuwiki/doku.php)
- [VESC UART Protocol](https://vesc-project.com)
- [GLMakie.jl](https://makie.juliaplots.org/stable/)

## Wiring Diagram (STM32 → VESC → Motor)


  +-----------------+          +-----------+          +-----------+
  |     STM32       | UART     |   VESC    | PWM/FOC  |  BLDC     |
  |                 |--------->|           |--------->|  Motor    |
  |  TX  RX  GND    |          |  TX  RX   |          |           |
  +-----------------+          +-----------+          +-----------+


- Connect **STM32 TX → VESC RX**, **STM32 RX → VESC TX**, and **common GND**.  
- VESC drives the motor; STM32 sends commands and receives telemetry via UART.  
- Julia telemetry listens to UDP packets forwarded from STM32.

## Switching from Mock to Real Hardware

1. Replace `motor_driver.cpp` and `motor_driver.hpp` with the STM32 + ChibiOS UART implementation.
2. Connect STM32 TX/RX/GND to VESC (see wiring diagram above).
3. Flash STM32 firmware to the board using your usual ChibiOS/STM32 toolchain.
4. Start the STM32 firmware; it will send live UDP telemetry to the same port (`9000`) used by the mock.
5. Launch Julia telemetry visualizer as before:
   ```bash
   julia Telemetry/motor_telemetry.jl

Confirm that RPM and position plots update with real hardware data.

Monitor motor and VESC for faults; respect maximum RPM limits.
The Julia visualizer does not need changes; it works identically with mock or real telemetry.

## Quick Start (Mock Firmware + Julia Telemetry)

1. Open a terminal and navigate to the firmware folder:
```bash
cd ~/fprime/Stage3/Stage4/Firmware/STM32

Compile the mock firmware (if not already compiled):
g++ main.cpp motor_driver.cpp -o motor_mock -std=c++17

Run the mock firmware:
./motor_mock

Open another terminal, navigate to Stage4 folder:
cd ~/fprime/Stage3/Stage4

Launch the Julia telemetry visualizer:
julia Telemetry/motor_telemetry.jl

You will see live RPM and position plots in the Makie window.

Terminal shows numeric telemetry alongside the plot.

This workflow works identically with mock firmware or real STM32 + VESC hardware.
