<div align="center">

# Design and Implementation of a Hardware-Accelerated CNN on Zynq-7000 SoC using AXI DMA

![Platform](https://img.shields.io/badge/Platform-PYNQ--Z2%20%7C%20Zynq--7000-orange?style=for-the-badge)
![RTL](https://img.shields.io/badge/Design-Custom%20Verilog%20RTL-blue?style=for-the-badge)
![Framework](https://img.shields.io/badge/Framework-PYNQ%20%7C%20Vivado%202025.2-green?style=for-the-badge)
![Language](https://img.shields.io/badge/Language-Verilog%20%7C%20Python%20%7C%20C%2B%2B-yellow?style=for-the-badge)

*High-Throughput Edge AI Inference via Custom RTL*

</div>

---

## 📌 Project Overview

This repository contains the RTL source code, Vivado project files, and Python deployment scripts for a **hardware-accelerated Convolutional Neural Network (CNN)**. Designed for real-time inference on a **Xilinx Zynq-7000 System-on-Chip (xc7z020clg400-1)**, this project completely bypasses High-Level Synthesis (HLS) in favor of pure, hand-coded Verilog RTL.

By designing a deeply pipelined streaming microarchitecture, this accelerator eliminates the memory bottlenecks traditional architectures face, delivering strictly deterministic execution and ultra-low latency for Edge AI applications.

### 🚀 Key Performance Metrics

| Metric | CPU Baseline (ARM Cortex-A9) | FPGA Accelerator (Custom RTL) | Improvement |
|---|---|---|---|
| **Inference Latency** | 85.4 ms | **0.689 ms** | **~124x Faster** |
| **Effective Throughput**| 11.7 FPS | **1,450 FPS** | **~124x Higher** |
| **Logic Power** | ~1.260 W | **~0.050 W (50 mW)** | Massive efficiency gain |
| **Execution Stability** | Variable (OS Jitter) | **Cycle-Accurate Determinism**| Absolute Stability |

---

## 🏗️ System Architecture

The design is partitioned across the heterogeneous Zynq SoC to maximize hardware efficiency and software flexibility:

* **Processing System (PS):** The ARM Cortex-A9 runs a Python-based PYNQ overlay, allocates contiguous DDR memory, writes control signals via **AXI4-Lite**, and orchestrates memory transfers.
* **Programmable Logic (PL):** The custom RTL CNN IP runs at a synchronous **100 MHz**. It computes convolutions, ReLU activations, Max Pooling, and Dense layer classifications.
* **Data Transport:** **AXI4-Stream via DMA** handles high-bandwidth image data transport, bypassing the CPU loop entirely.

```text
┌─────────────────────────────────────────────────────────────────────┐
│                        Zynq-7000 SoC (xc7z020)                      │
│                                                                     │
│   ┌──────────────────────────┐      ┌───────────────────────────┐   │
│   │   Processing System (PS) │      │  Programmable Logic (PL)  │   │
│   │   ARM Cortex-A9 @ 650MHz │      │  Custom Verilog RTL @ 100MHz│   │
│   │                          │      │                           │   │
│   │  ① Python PYNQ script    │ AXI  │  ┌─────────────────────┐  │   │
│   │  ② Allocate contiguous   │-Lite │  │   cnn_accel_0 (IP)  │  │   │
│   │     DDR image buffer     │◄────►│  │                     │  │   │
│   │  ③ Write 0x81 to control │      │  │  Line Buffers/FIFOs │  │   │
│   │  ④ Trigger DMA (MM2S)    │      │  │  Conv1 + ReLU       │  │   │
│   │  ⑤ Poll DMA Receive      │      │  │  Conv2 + ReLU       │  │   │
│   │  ⑥ Read output class ID  │      │  │  MaxPool 2x2        │  │   │
│   │                          │      │  │  Fully Connected    │  │   │
│   └──────────────────────────┘      │  │  Comparator Bypass  │  │   │
│                ▲                    │  └─────────────────────┘  │   │
│                │                    │             ▲             │   │
│           AXI SmartConnect          │             │ AXI4-Stream │   │
│                │                    │             ▼             │   │
│   ┌────────────▼─────────────┐      │  ┌─────────────────────┐  │   │
│   │      Shared DDR3 RAM     │◄─────┼──┤     AXI DMA IP      │  │   │
│   └──────────────────────────┘      │  └─────────────────────┘  │   │
└─────────────────────────────────────┴───────────────────────────┘
