// Code your design here
//`include "fix2flt.sv"
//`include "fix2flt0.sv"
`include "Top_level.sv"
`include "Top_level0.sv"
`include "Alu.sv"
`include "ControlUnit.sv"
`include "DM.sv"
`include "data_mem.sv"
`include "InstructionROM.sv"
`include "Lut.sv"
//`include "P1TLUT.txt"
//`include "P1Tmachinecode.txt"
`include "ProgramCounter.sv"
`include "RegFile.sv"
`include "Rr1Mux.sv"
`include "WriteDMux.sv"
`include "WriteRMux.sv"

    // Enable waveform dumping
 //   $dumpfile("dump.vcd");
   // $dumpvars(0, int2flt_tb);