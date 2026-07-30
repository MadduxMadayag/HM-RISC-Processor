# HM Processor

A custom 9-bit load-store processor designed in SystemVerilog. The HM architecture was developed under a constrained instruction width while remaining capable of executing three floating-point benchmark programs.

## Design Philosophy

HM is a register-register (load-store) architecture inspired by MIPS and ARM while constrained to a 9-bit instruction format. The primary design goals were:

- Execute all three required benchmark programs efficiently
- Maximize hardware simplicity within a limited ISA
- Minimize software complexity whenever possible
- Support floating-point operations through software routines

## Architecture Overview

### Processor Characteristics

| Feature | Specification |
|----------|---------------|
| Instruction Width | 9 bits |
| Architecture | Register-register / Load-store |
| Registers | 8 General Purpose |
| Data Memory | 32 addresses |
| Branching | Exact-address LUT |
| Immediate Width | 6 bits |

### Architecture Diagram

![Alt Text](HM_Architecture.png)


## Instruction Set

| Type | Format | Instructions |
|------|--------|--------------|
| R | 1 bit type, 3 bits opcode, 2 bit source registers, 3 bit target register | ADD, AND, CMP, LSL, LSR, MOV, ORR, NOT |
| M | 2 bits type, 1 bit opcode, 1 bit reg, 5 bit memory address | LDR, STR |
| B | 3 bits type, 1 bit opcode, 5 bits register  | BNE, BLT |
| I | 3 bits type, 6 bits immediate | LDI |

## Software Implementation

### Program 1 – Fixed-Point to Floating-Point Conversion
Converts a signed 16-bit fixed-point integer into the custom floating-point format by extracting the sign, normalizing the mantissa, computing the exponent, and assembling the final floating-point representation.

### Program 2 – Floating-Point to Fixed-Point Conversion
Converts the custom floating-point format back into a signed 16-bit fixed-point integer by recovering the sign, exponent, and mantissa, handling overflow cases, and reconstructing the original value through software-based shifting operations.

### Program 3 – Floating-Point Addition
Adds two floating-point values by aligning their exponents, shifting the smaller mantissa, performing the addition, normalizing the result, and storing the final floating-point value back to memory.

## Results

- Program 1: **101/101**
- Program 2: **37/37**
- Program 3: **12/12**

## Authors

**Maddux Madayag & Yu-Han Lou**
