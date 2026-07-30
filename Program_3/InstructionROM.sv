module InstructionROM (
  input       [11:0] prog_ctr,    
  output logic[ 8:0] mach_code);

  logic[8:0] core[2**12];
  initial							    
    $readmemb("P3Tmachinecode.txt",core);

  always_comb  mach_code = core[prog_ctr];

endmodule