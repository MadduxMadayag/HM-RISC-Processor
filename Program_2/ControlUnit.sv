module ControlUnit(
    input[3:0] Instruction,
    input Zero,
          Neg,
          Carry,
          Vflow,
          reset,
  output logic[2:0] MemToReg,
                RegDst,
    output logic MemWrite,
                 MemRead,
                 RegWrite,
                 RegR,
    output logic [3:0] ALUOp,
    output logic Bne,
                 Blt
                 //done
);

always_comb begin
    MemToReg  = 0;
    RegDst    = 0;
    MemWrite  = 0;
    MemRead   = 0;
    RegWrite  = 0;
    RegR      = 0;
    ALUOp     = 4'b0000;
    Bne       = 0;
    Blt       = 0;  
    //done      = 0;
    if(reset) begin
        MemToReg = 0; // to Write data Mux -> RF
        RegDst = 0; // to Write reg Mux -> RF
        MemWrite = 0; // data_memory write enable
        MemRead = 0; // data_memory read enable
        RegWrite = 0; // RF write eanble
        RegR = 0; // to Read reg 1 Mux -> RF
        ALUOp = Instruction; // OPCODE
        Bne = 0;
        Blt = 0;
        //done = 0;
    end
    else begin
        case(Instruction[3])
            'b0: begin                                 //R type
                if(Instruction[2:0] == 'b101) begin       // mov
                MemToReg = 0; // to Write data Mux -> RF
                RegDst = 1; // to Write reg Mux -> RF
                MemWrite = 0; // data_memory write enable
                MemRead = 0; // data_memory read enable
                RegWrite = 1; // RF write eanble
                RegR = 0; // to Read reg 1 Mux -> RF
                ALUOp = Instruction; // OPCODE
                Bne = 0;
                Blt = 0;
        end 
              else begin 
                MemToReg = 0; // to Write data Mux -> RF
                RegDst = 0; // to Write reg Mux -> RF
                MemWrite = 0; // data_memory write enable
                MemRead = 0; // data_memory read enable
                RegWrite = 1; // RF write eanble
                RegR = 0; // to Read reg 1 Mux -> RF
                ALUOp = Instruction; // OPCODE
                Bne = 0;
                Blt = 0;
                //done = 0;
              end
            end
            'b1: begin
                case(Instruction[2])
                    'b0: begin
                        case(Instruction[1])
                            'b0: begin                   // ldr
                                MemToReg = 2; // to Write data Mux -> RF
                                RegDst = 2; // to Write reg Mux -> RF
                                MemWrite = 0; // data_memory write enable
                                MemRead = 1; // data_memory read enable
                                RegWrite = 1; // RF write eanble
                                RegR = 1; // to Read reg 1 Mux -> RF
                                ALUOp = Instruction; // OPCODE
                                Bne = 0;
                                Blt = 0;
								//done = 0;
                            end 

                            'b1: begin                   // str 
                                MemToReg = 0;
                                RegDst = 0;
                                RegR = 1; 
                                MemWrite = 1;
                                MemRead = 0;
                                RegWrite = 0;
                                ALUOp = Instruction; // OPCODE
                                Bne = 0;
                                Blt = 0;
                                // if() Add condition where writing to specific data address ends program
                                //done = 1;
                            end
                        endcase
                    end
                    'b1: begin                            
                        if(Instruction[1:0] == 'b00) begin                   //bne
                                MemToReg = 0; // to Write data Mux -> RF
                                RegDst = 0; // to Write reg Mux -> RF
                                MemWrite = 0; // data_memory write enable
                                MemRead = 0; // data_memory read enable
                                RegWrite = 0; // RF write eanble
                                RegR = 0; // to Read reg 1 Mux -> RF
                                ALUOp = Instruction; // OPCODE
                                Bne = 1;
                                Blt = 0;
                                //done = 0;
                            end else if(Instruction[1:0] == 'b01) begin        //blt
                                MemToReg = 0; // to Write data Mux -> RF
                                RegDst = 0; // to Write reg Mux -> RF
                                MemWrite = 0; // data_memory write enable
                                MemRead = 0; // data_memory read enable
                                RegWrite = 0; // RF write eanble
                                RegR = 0; // to Read reg 1 Mux -> RF
                                ALUOp = Instruction; // OPCODE
                                Bne = 0;
                                Blt = 1;
                                //done = 0;
                            end
                        if(Instruction[1] == 'b1) begin                  // ldi
                                MemToReg = 1; // to Write data Mux -> RF
                                RegDst = 3; // to Write reg Mux -> RF
                                MemWrite = 0; // data_memory write enable
                                MemRead = 1; // data_memory read enable
                                RegWrite = 1; // RF write eanble
                                RegR = 1; // to Read reg 1 Mux -> RF
                                ALUOp = Instruction; // OPCODE
                                Bne = 0;
                                Blt = 0;
                                //done = 0;
                            end
                    end
                endcase
            end

        endcase
    end 
end



endmodule