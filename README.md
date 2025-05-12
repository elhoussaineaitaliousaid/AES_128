# -AES-128-in-VHDL

## Description

This project is a VHDL implementation of the AES-128 encryption algorithm, based on the FIPS-197 standard. It features modular components and testbenches for each stage of the AES pipeline, supporting simulation with GHDL and waveform inspection via GTKWave.

## Project Structure
AES-128/
├── ghdl_simul/ # Output directory for simulation
│ ├── aes.vcd # Waveform file
│ └── work-obj93.cf # GHDL work library
├── src/ # AES implementation in VHDL
│ ├── AddKey.vhd
│ ├── byte_pack.vhd
│ ├── Mixcolomun.vhd
│ ├── ShiftRows.vhd
│ ├── suByte.vhd
│ └── top_AES.vhd # Top-level AES component
├── testbench/ # Testbenches for each component
│ ├── AddKey_tb.vhd
│ ├── Mixcolomun_tb.vhd
│ ├── ShiftRows_tb.vhd
│ ├── suByte_tb.vhd
│ └── top_tb.vhd # Global AES testbench
└── README.md

## Simulation Instructions

### Prerequisites

- [GHDL](https://github.com/ghdl/ghdl)
- [GTKWave](http://gtkwave.sourceforge.net/)

### Simulate the Full AES System

```bash
# Move to testbench directory
cd testbench

# Analyze source files and testbench
ghdl -a ../src/*.vhd top_tb.vhd

# Elaborate the testbench
ghdl -e top_tb

# Run simulation and export VCD waveform
ghdl -r top_tb --vcd=../ghdl_simul/aes.vcd

# Open waveform
gtkwave ../ghdl_simul/aes.vcd

## Simulation Instructions

### Prerequisites

- [GHDL](https://github.com/ghdl/ghdl)
- [GTKWave](http://gtkwave.sourceforge.net/)

### Simulate the Full AES System

```bash
# Move to testbench directory
cd testbench

# Analyze source files and testbench
ghdl -a ../src/*.vhd top_tb.vhd

# Elaborate the testbench
ghdl -e top_tb

# Run simulation and export VCD waveform
ghdl -r top_tb --vcd=../ghdl_simul/aes.vcd

# Open waveform
gtkwave ../ghdl_simul/aes.vcd
# Example: simulate SubBytes
ghdl -a ../src/suByte.vhd suByte_tb.vhd
ghdl -e suByte_tb
ghdl -r suByte_tb --vcd=../ghdl_simul/sub.vcd
gtkwave ../ghdl_simul/sub.vcd

