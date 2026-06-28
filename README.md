# Elevator Controller using SystemVerilog

A digital **Elevator Controller** implemented in **SystemVerilog** using a **Finite State Machine (FSM)** architecture. This project demonstrates RTL design, state machine implementation, and functional verification through a custom testbench using **Xilinx Vivado**.

---

## Project Overview

The controller processes floor requests and controls the movement of the elevator between floors. The design is implemented as a synchronous FSM that manages elevator states such as idle, moving, and servicing requests.

This project focuses on writing clean, synthesizable RTL and verifying its functionality through simulation.

---

## Features

* FSM-based elevator controller
* SystemVerilog RTL implementation
* Floor request handling
* Elevator movement control
* Reset support
* Functional verification using a SystemVerilog testbench
* Vivado-compatible project structure

---

## Project Structure

```text
elevator_using_sv/
│
├── elevator_using_sv.xpr
├── constraints.xdc
├── .gitignore
├── README.md
│
├── elevator_using_sv.srcs/
│   ├── sources_1/
│   │     └── elevator.sv
│   │
│   └── sim_1/
│         ├── elevator_tb.sv
│         └── elevator_tb.v
│
└── Reports/
```

---

## Skills Demonstrated

* RTL Design
* SystemVerilog
* Finite State Machine (FSM)
* Sequential & Combinational Logic
* Functional Verification
* Testbench Development
* FPGA Design Flow
* Xilinx Vivado

---

## Tools Used

| Tool             | Purpose                              |
| ---------------- | ------------------------------------ |
| SystemVerilog    | RTL Design                           |
| Xilinx Vivado    | Design Entry, Simulation & Synthesis |
| Vivado Simulator | Functional Verification              |

---

## Getting Started

Clone the repository:

```bash
git clone https://github.com/jayjain2365/elevator_using_sv.git
```

Open the project in **Xilinx Vivado** and load:

```text
elevator_using_sv.xpr
```

Run Behavioral Simulation to verify the design or synthesize the project for FPGA implementation.

---

## Future Improvements

* Support for configurable number of floors
* Request prioritization
* Door timing controller
* Emergency stop functionality
* Hardware demonstration on FPGA

---

## Author

**Jay Jain**

Electronics & Communication Engineering Student

Aspiring RTL Design & Design Verification Engineer

**Areas of Interest**

* RTL Design
* Digital Design
* SystemVerilog
* FPGA Design
* Functional Verification

GitHub: https://github.com/jayjain2365
