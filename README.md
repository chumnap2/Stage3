# Stage3 MotorComponent Simulator

## ⚙️ Overview
This project implements a **MotorComponent** simulator for Stage3 (ChibiOS) using **F Prime** and **Julia**.  
The simulator receives RPM commands via terminal input and outputs real-time telemetry (RPM and Position).

---

## 📌 Features

- **Real-time telemetry**: Displays RPM and motor position in the terminal.
- **Command input**: Enter new target RPM at any time.
- **Optional CSV logging**: Logs telemetry automatically per session (timestamped CSV files).
- **Lightweight**: No GUI, purely terminal-based simulation.

---

## 🛠️ Requirements

- Julia 1.10+  
- JSON3.jl package: install with:

```bash
julia -e 'using Pkg; Pkg.add("JSON3")'

F Prime Stage3 repository with MotorComponent deployed
🚀 Usage

Make sure Julia is installed and packages are ready.

Run the simulator:
julia ./motor_sim_terminal_scroll.jl

Enter target RPM values when prompted:
Enter RPM: 200
[TELEMETRY] RPM=200.0  Position=20.0°

Press Ctrl+C to stop the simulator.
⚡ Quick Start One-liner

For immediate launch from anywhere:
cd ~/fprime/Stage3/minimal_chibios/motor_control && julia ./motor_sim_terminal_scroll.jl

📂 Project Structure
Stage3/
├── minimal_chibios/
│   ├── motor_control/
│   │   └── motor_sim_terminal_scroll.jl
│   ├── CMakeLists.txt
│   └── settings.cmake
├── fprime.cmake
└── README.md

⚠️ Notes

Build cache warnings or fprime-gds missing warnings can be ignored when running the simulator.

CSV logging creates a new file per session to avoid overwriting previous logs.
✅ Status
MotorComponent simulator fully functional
Real-time telemetry works
Julia integration complete
Stage3 project ready for experimentation
