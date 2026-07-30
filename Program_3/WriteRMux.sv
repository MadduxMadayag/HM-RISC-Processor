module WriteRMux (
    input[2:0] Input1,
    input[1:0] Input2,
    input Input3,
    input[2:0] RegDst,
    output logic[2:0] WriteReg
);

always_comb begin
    WriteReg = 'b000;
    if(RegDst == 0) begin
         WriteReg= Input1;
    end
    else if(RegDst == 1)begin
        WriteReg = {1'b0, Input2};
    end
    else if(RegDst == 2) begin
        WriteReg = {2'b0, Input3};
    end
    else if(RegDst == 3) begin
        WriteReg = 'b000;
    end
end

endmodule