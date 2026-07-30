module Rr1Mux(
    input[1:0] Input1,
    input Input2,
    input RegR,
  output logic[1:0] ReadRegA
);

//  assign ReadRegA = (RegR) ? {1'b0, Input2} : {Input1};
  always_comb begin
    if (!RegR)
        ReadRegA = Input1;
    else
        ReadRegA = {1'b0, Input2};
end

endmodule