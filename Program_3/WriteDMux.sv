module WriteDMux(
    input[7:0] Input1,
    input[5:0] Input2,
    input[7:0] Input3,
    input[2:0] MemToReg,
    output logic[7:0] RegWriteValue
);

always_comb begin
    RegWriteValue = 'b00000000;
    if(MemToReg == 0) begin
        RegWriteValue = Input1;
    end
    else if(MemToReg == 1)begin
        RegWriteValue = {2'b0, Input2};
    end
    else if(MemToReg == 2)begin
        RegWriteValue = Input3;
    end
end

endmodule