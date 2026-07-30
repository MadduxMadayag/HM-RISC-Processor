module ProgramCounter(
    input clk,
    input reset,
    //input req,
    //input done,
    input BranchEn,
    input start,
    input[11:0] Target,
    output logic[11:0] PC
);

always_ff @ (posedge clk)
  if(reset || start)
        PC <= 0;
  //else if(start)
        //PC <= PC;
    else if(BranchEn) begin // Absolute branching
        PC <= Target;
    end
    else 
    PC <= PC + 1;

endmodule