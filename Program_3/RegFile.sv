module RegFile(
    input clk,
          reset,         // <- Reset signal
          WriteEn,
  		  done,
  input[1:0] RaddrA,
    input [2:0]  RaddrB, Waddr,
    input [7:0] DataIn,
    output logic [7:0] DataOutA,
                      DataOutB,
                      DataOutC
);

logic [7:0] Registers[8];

assign DataOutA = Registers[RaddrA];
assign DataOutB = Registers[RaddrB];
assign DataOutC = Registers[0];

always_ff @ (posedge clk) begin
  if (reset || done) begin
    // Reset all registers to 0
    for (int i = 0; i < 8; i++)
      Registers[i] <= 8'd0;
  end else if (WriteEn) begin
    Registers[Waddr] <= DataIn;
  end
end

endmodule