module Lut(
  input [7:0] Addr,
    output logic[11:0] Target
);

    // Internal memory to hold the LUT values
    logic [11:0] mem [0:63]; // Change size as needed

    // Initialize LUT from file
    initial begin
      $readmemb("P3TLUT.txt", mem); // Change as needed
    end

    // Output logic
    always_comb begin
      Target = mem[Addr-1];
    end

endmodule