# Cache Simulator in SystemVerilog

A synthesizable RTL implementation of a cache simulator in **SystemVerilog**, featuring both **Direct-Mapped** and **2-Way Set Associative** cache architectures. The project demonstrates cache organization, tag matching, hit/miss detection, and FIFO-based replacement.

## Features

- Direct-Mapped Cache
- 2-Way Set Associative Cache
- FIFO Replacement Policy
- Read and Write Operations
- Cache Hit/Miss Detection
- SystemVerilog Testbench

## Project Structure

```
Cache-Simulator/
├── RTL/
├── Testbench/
├── Images/
└── README.md
```

## Simulation

Simulation was performed using **Icarus Verilog**, and waveforms were generated using **GTKWave**.

```bash
iverilog -g2012 -o cache_sim RTL/cache.sv RTL/cache_2way.sv Testbench/cache_tb.sv
vvp cache_sim
gtkwave dump.vcd
```

## Future Improvements

- LRU Replacement Policy
- Write-Back Cache
- Configurable Cache Parameters
- N-Way Set Associative Cache
- Cache Performance Statistics
