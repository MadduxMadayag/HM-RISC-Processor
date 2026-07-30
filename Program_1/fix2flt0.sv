module int2flt(		   // you will have the same 3 ports
    input        reset,	   // init/reset, active high
			     start,    // start next program
	             clk,	   // clock -- posedge used inside design
                 //req,      // request signal by prof's test bench
    output logic done	   // done flag from DUT
    );

wire [11:0] PgmCtr,        // program counter
			PCTarg;
wire [8:0] Instruction;   // our 9-bit opcode
wire [7:0] ReadA, ReadB, ReadC;  // reg_file outputs
wire [7:0] //InA,       	   // ALU operand inputs
            ALU_out;       // ALU result
wire [7:0] RegWriteValue, // data in to reg file
            //MemWriteValue, // data in to data_memory
	   	    MemReadValue;  // data out from data_memory
logic        MemWrite,	   // data_memory write enable
			MemRead,	   // data_memory read enable
			RegWrite,	   // reg_file write enable
            RegR,          // to Read reg 1 Mux
			Neg,           // ALU output Negative flag
			Zero,   	   // ALU output Zero flag
			Carry,         // ALU output add Carry out 
            SCarry,
			Vflow,         // ALU output Overflow flag
            Bne,	   	   // BNE enable
			Blt;	   // BLT enable
  //Zero_reg,
  //Bne_reg,
  
wire        BranchEn;	   // to program counter: branch enable 	// Imp
wire [1:0] 	ReadRegA;      // Read Reg A input into RF
wire [2:0]  WriteReg,	// to Write reg
  			MemToReg, // to Write data Mux	 
  	 	   RegDst;       // to Write reg Mux
wire [3:0] ALUOp;         // to ALU
wire [6:0] Immediate;      
//logic[15:0] CycleCt;	   // standalone; NOT PC

 logic  C_in, 				  // add Carry into the ALU  
        SC_in;
  		
//	    zeroQ;                    // registered zero flag from ALU 
//logic BranchEn_reg;
  
  assign BranchEn = (Bne == 1 && Zero == 0) || ((Neg ^ Vflow) && Blt == 1); // problem if two negative

 // assign BranchEn = (Bne  == 1 && Zero == 0) ? 1'b1 : 1'b0;// || ((Neg ^ Vflow) && Blt);
  
// Program Counter + Fetch
ProgramCounter PC (
    .clk(clk),
    .reset(reset),
    .start(start),
    //.done(done),
    //.req(req),
  .BranchEn(BranchEn), //BranchEn_reg),
    .Target(PCTarg),
    .PC(PgmCtr)
);

//
InstructionROM IR(
    .prog_ctr(PgmCtr),
    .mach_code(Instruction)
    );

// Control Unit
ControlUnit CU (
    .Instruction(Instruction[8:5]),
  .Zero(Zero_reg),
    .Neg(Neg),
	.Carry(Carry),
	.Vflow(Vflow),
    .MemToReg(MemToReg),
    .RegDst(RegDst),
    .RegR(RegR),
    .MemWrite(MemWrite),
    .MemRead(MemRead),
    .RegWrite(RegWrite),
    .ALUOp(ALUOp),
  .Bne(Bne),
    .Blt(Blt),
    .reset(reset)
    //.done(done)
);


Lut LUT(
	.Addr(ReadC),
	.Target(PCTarg)
);

RegFile RF (
    .clk(clk),
    .WriteEn(RegWrite), 
    .RaddrA(ReadRegA),        
    .RaddrB(Instruction[2:0]),
    .Waddr(WriteReg),
    .DataIn(RegWriteValue), 
    .DataOutA(ReadA), 
    .DataOutB(ReadB),
  .DataOutC(ReadC),
  .reset(reset),
  .done(done)
);

Alu ALU  (
    .InputA(ReadA), 
    .InputB(ReadB), 
    .C_in(C_in),
    .SC_in(SC_in),
    .OP(ALUOp),
    .Out(ALU_out),
    .Neg(Neg),
    .Zero(Zero),
    .Carry(Carry),
    .SCarry(SCarry),
    .Vflow(Vflow)	                              
);

Rr1Mux RR1MUX (
    .Input1(Instruction[4:3]),
    .Input2(Instruction[5]),
    .RegR(RegR),
    .ReadRegA(ReadRegA)
);

WriteRMux WRITERMUX (
    .Input1(Instruction[2:0]),
    .Input2(Instruction[4:3]),
    .Input3(Instruction[5]),
    .RegDst(RegDst),
    .WriteReg(WriteReg)
);

WriteDMux WRITEDMUX (
    .Input1(ALU_out),
    .Input2(Instruction[5:0]),
    .Input3(MemReadValue),
    .MemToReg(MemToReg),
    .RegWriteValue(RegWriteValue)
);

/*
AluMux ALUMUX (
    .Input1(ReadA),
    .Input2(ReadC),
    .Bne(Bne),
    .Blt(Blt),
    .OutputAluMux(InA)
);
*/

DM DM1(
    .DataAddress(Instruction[4:0]), 
    .WriteEn(MemWrite), 
    .ReadEn(MemRead),
    .DataIn(ReadA), 
    .DataOut(MemReadValue), 
    .clk(clk),
    .reset(reset)
);

// registered flags from ALU
  always_ff @(posedge clk) begin
    C_in <= Carry; 
    SC_in <= SCarry;
  end
//  always_ff @(posedge clk or posedge reset) begin
//    if (reset)
//        BranchEn_reg <= 0;
//    else
//        BranchEn_reg <= BranchEn;
//end


assign done = PgmCtr == 173; //Number to be determined based on what program is running

endmodule