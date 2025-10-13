# 🚀 Stage3: F´ ↔ Julia Integration (MotorComponent Real Data)

This project demonstrates a **Stage3 NASA F´ deployment** integrated with a **Julia-based simulator**.  
The setup links **real-time F´ telemetry** from a `MotorComponent` to Julia via **UDP**, enabling visual and numerical analysis of motor control data.

---

## ⚙️ Project Structure

This deployment is **centered around a single `MotorComponent`**, which:
- Receives **RPM commands** (e.g., `SET_RPM`).
- Computes or simulates the motor’s angular position.
- Sends back **telemetry packets** containing `RPM` and `Position` data to Julia via UDP.

### Directory Layout

Stage3/
├── minimal_chibios/
│ ├── Components/
│ │ └── MotorComponent/
│ │ ├── include/
│ │ │ └── MotorComponent.hpp
│ │ └── src/
│ │ └── MotorComponent.cpp
│ ├── src/
│ │ └── main.cpp
│ ├── stm32f407.ld
│ └── settings.cmake
└── motor_control/
└── motor_sim_terminal_scroll.jl

---

## 🧠 Julia ↔ F´ Integration

### Communication
- UDP port **9000** is used for bidirectional communication.
- Julia sends JSON commands such as:
  ```json
  { "cmd": "SET_RPM", "value": 200 }

F´ MotorComponent receives and processes these commands.

The component responds with JSON telemetry, e.g.:
{ "telemetry": { "RPM": 200.0, "Position": 20.0 } }

{ "telemetry": { "RPM": 200.0, "Position": 20.0 } }

./motor_sim_terminal_scroll.jl
[MotorComponent] Listening on UDP port 9000
Type new target RPM (e.g., 200) and press Enter. Ctrl+C to stop.

Enter RPM: 200
[TELEMETRY] RPM=200.0  Position=20.0°

🧩 Build Instructions
F´ Native Build
cd ~/fprime/Stage3/minimal_chibios
fprime-util generate
fprime-util build

STM32 Firmware Build
cmake -S . -B build-stm32 \
      -DFPRIME_PROJECT_ROOT=. \
      -DFPRIME_FRAMEWORK_PATH=../.. \
      -DCMAKE_TOOLCHAIN_FILE=toolchain-arm-none-eabi.cmake
cmake --build build-stm32

🧪 Julia Environment Setup
julia
import Pkg
Pkg.add(["Sockets", "JSON3"])

Then run the simulator:
./motor_sim_terminal_scroll.jl

📡 Telemetry Flow Summary
flowchart LR
    Julia[Julia Simulator] -->|UDP JSON cmd| Fprime[F´ MotorComponent]
    Fprime -->|UDP JSON telemetry| Julia
    Fprime -->|Control signals| STM32_Hardware[STM32 HAL]

💾 Version Control Notes

All build artifacts are excluded via .gitignore

Primary tracked directories:

Components/MotorComponent/

motor_control/motor_sim_terminal_scroll.jl

src/, settings.cmake, and CMakeLists.txt
🛰️ Credits

Developed as part of the Stage3 F´–Julia Integration Pipeline,
bridging embedded real-time control (NASA F Prime) with Julia for dynamic simulation and visualization.

