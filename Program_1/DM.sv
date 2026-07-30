module DM(
    input[4:0] DataAddress,
    input WriteEn,
          ReadEn,
    input[7:0] DataIn,
    input clk,
          reset,
    output logic[7:0] DataOut
);

 logic [7:0] mem_core[32];

always_comb begin
    if(ReadEn)begin
        DataOut = mem_core[DataAddress];
    end
    else
        DataOut = 8'bZ;
end
always_ff @ (posedge clk)
    if(WriteEn) begin        
        mem_core[DataAddress] = DataIn;
end

endmodule