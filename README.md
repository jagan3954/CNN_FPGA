<div align="center">

# 🚀 RTL-Based CNN Accelerator on Zynq-7000 SoC

![Platform](https://img.shields.io/badge/Platform-Zynq--7000%20%7C%20PYNQ--Z2-orange?style=for-the-badge)
![Design](https://img.shields.io/badge/Design-RTL%20Verilog-blue?style=for-the-badge)
![Interface](https://img.shields.io/badge/Interface-AXI4%20%7C%20AXI%20DMA-green?style=for-the-badge)
![Clock](https://img.shields.io/badge/Clock-100%20MHz-yellow?style=for-the-badge)

</div>

---

## 📌 Project Overview

This project implements a **custom RTL-based Convolutional Neural Network (CNN) accelerator** on the **Xilinx Zynq-7000 SoC (xc7z020clg400-1)**.

The accelerator is written entirely in **Verilog (RTL)** and integrated with the ARM Cortex-A9 Processing System using **AXI DMA** for high-speed data transfer between DDR memory and programmable logic.

Unlike HLS-based accelerators, this design provides:

- Full control over datapath architecture  
- Explicit DSP48E1 mapping for convolution  
- Custom buffering and pipelining  
- Deterministic cycle-accurate timing  

The system operates at **100 MHz** and is deployed on a **PYNQ-Z2 board** for performance benchmarking using Python.

---

## 🧠 Why FPGA Hardware Acceleration?

| Concern | CPU-Only (ARM) | RTL FPGA Accelerator |
|----------|----------------|----------------------|
| Convolution Execution | Sequential | Parallel MAC units |
| Inference Latency | High | Deterministic & Low |
| Timing Predictability | Variable | Cycle-Accurate |
| DSP Utilization | None | 48 DSP48E1 used |
| Power Efficiency | Moderate | Optimized PL datapath |

This project demonstrates efficient CNN inference using handcrafted RTL logic.

---

## 🏗️ System Architecture

The system is partitioned across the heterogeneous Zynq architecture:

### 🔹 Processing System (PS)
- ARM Cortex-A9 @ 650 MHz  
- Configures AXI DMA  
- Controls accelerator via AXI-Lite  
- Runs Python (PYNQ) for benchmarking  

### 🔹 Programmable Logic (PL)
- Custom CNN accelerator (RTL)  
- Convolution layers  
- ReLU activation  
- Max-pooling blocks  
- Fully connected classifier  
- Comparator (ArgMax)  

### 🔹 Data Flow

```
DDR Memory
   │
   ▼
AXI MM2S (DMA)
   │
   ▼
CNN Accelerator (PL)
   │
   ▼
AXI S2MM (DMA)
   │
   ▼
DDR Memory → ARM reads result
```

---

## 🧠 CNN Architecture

### Network Topology

| Layer | Operation | Description |
|-------|----------|-------------|
| Conv1 | 3×3 Convolution | Feature extraction |
| ReLU1 | Activation | max(0, x) |
| Pool1 | MaxPool | Downsampling |
| Conv2 | 3×3 Convolution | Deeper features |
| ReLU2 | Activation | Non-linearity |
| Pool2 | MaxPool | Dimension reduction |
| FC | Fully Connected | Classification |
| Comparator | ArgMax | Output class index |

---

## ⚙️ RTL Module Hierarchy

```
cnn_accelerator
│
├── conv1_layer
│   ├── conv1_buf
│   └── conv1_calc
│
├── conv2_layer
│   ├── conv2_buf_1
│   ├── conv2_buf_2
│   ├── conv2_buf_3
│   └── conv2_calc_1
│   └── conv2_calc_2
│   └── conv2_calc_3
│
├── maxpool_relu
├── fully_connected
└── comparator
```

The design follows a streaming pipeline architecture to maximize throughput while minimizing BRAM usage.

---

## 🔌 AXI Integration

### AXI Interfaces Used

- **AXI4-Lite** → Control register interface  
- **AXI4-Stream** → Data streaming  
- **AXI DMA** → DDR ↔ PL transfer  
- **AXI HP0 Port** → High-performance memory access  

### Base Address Mapping

| Component | Base Address |
|------------|-------------|
| AXI DMA | `0x40400000` |
| CNN Accelerator | `0x43C00000` |
| DDR HP0 Range | `0x00000000 – 0x1FFFFFFF` |

---

## 📊 FPGA Resource Utilization

**Device:** xc7z020clg400-1  
**Vivado Version:** 2025.2  

| Resource | Used | Available | Utilization |
|----------|------|-----------|-------------|
| LUT | 3,590 | 53,200 | 6.75% |
| Registers | 3,869 | 106,400 | 3.64% |
| BRAM | 2 | 140 | 1.43% |
| DSP48E1 | 48 | 220 | 21.82% |

✔ Efficient LUT usage  
✔ Controlled BRAM usage  
✔ DSP-optimized convolution engine  

---

## 🔋 Power Analysis

| Parameter | Value |
|------------|--------|
| Total On-Chip Power | 1.456 W |
| Dynamic Power | 1.320 W |
| Static Power | 0.136 W |
| PS7 Contribution | 1.26 W |
| DSP Power | 0.033 W |

Most power is consumed by the Processing System rather than the accelerator logic.

---

## 🚀 Performance Benchmarking

Testing performed using PYNQ Python overlay.

### FPGA Inference

- Average Latency: **~0.689 ms**
- Estimated Throughput: **~1450 FPS**
- Clock Frequency: **100 MHz**

### CPU Baseline (ARM Only)

- Higher latency  
- Non-deterministic timing  
- No parallel MAC execution  

Hardware acceleration demonstrates deterministic, low-latency inference.

---

## 🛠️ Tools Used

- Vivado 2025.2  
- Verilog RTL  
- AXI DMA IP  
- PYNQ Framework  
- Python 3  
- Jupyter Notebook  

---

## 📂 Repository Structure

```
rtl-cnn-zynq/
│
├── rtl/
│   ├── conv1_layer.v
│   ├── conv2_layer.v
│   ├── fully_connected.v
│   └── cnn_top.v
│
├── vivado/
│   ├── block_design.png
│   ├── bitstream.bit
│   └── design.hwh
│
├── software/
│   ├── fpga_benchmark.ipynb
│   └── dma_control.py
│
├── docs/
│   └── project_report.pdf
│
└── README.md
```

---

## 🎯 Key Achievements

- Fully functional RTL CNN accelerator  
- AXI DMA integration  
- Successful 100 MHz timing closure  
- DSP-optimized convolution engine  
- Deterministic hardware inference  
- Low FPGA resource footprint  

---

## 🎓 Academic Context

Department of Electronics and Communication Engineering  
Saveetha Engineering College  
Academic Year: 2025–2026  
Mentor: Dr. Navaneethan S  

---

<div align="center">

Built on Zynq-7000 · Designed in RTL · Accelerated by AXI DMA

</div>
