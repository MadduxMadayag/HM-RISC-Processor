module Alu(
    input [7:0] InputA,
                InputB,
    input C_in,
          SC_in,
    input [3:0] OP,        
    output logic [7:0] Out,
    output logic Neg,
                 Zero,
                 Carry,
                 SCarry,
                 Vflow
);


always_comb begin
    Out = 0;                             // No Op = default
    Neg = 0;
    Zero = 0;
    Vflow = 0;
    Carry = 0;
    SCarry= 0;
    if(OP[3]==0) begin
        case(OP[2:0])

            'b000 : begin                    // add 
                {Carry,Out} = {1'b0,InputA} + {1'b0,InputB} + {8'b00000000,C_in};
            end

            'b001 : begin                    //and
                Out = InputA & InputB;
            end

            'b010 : begin                    //cmp
                //{Vflow, Out} = InputA - InputB;
                Out = InputA - InputB;
                Vflow = (InputA[7] != InputB[7]) && (InputA[7] != Out[7]);
                case(Out)
                    'b0     : Zero = 1'b1;
                    default : Zero = 1'b0;
                endcase
                case(Out[7])
                    'b1     : Neg = 1'b1;
                    default : Neg = 1'b0;
                endcase
            end
            // lsl
            'b011: begin
                {SCarry, Out} = {InputA, SC_in};
            end

            // lsr
            'b100: begin
                {Out, SCarry} = {SC_in, InputA};
            end

            'b101 : begin                    //mov
                Out = InputB;
            end
            'b110 : begin                    //orr
                Out = InputA | InputB;
            end

            'b111 : begin                    //not
                Out = ~InputB;
            end
        endcase
    end 
    else begin
        if(OP[2]==0) begin
            case(OP[1])
                'b1 : begin                    //str
                    Out = InputA;
                end
            endcase
        end else begin                         //bne, blt
            //{Vflow, Out} = InputA - InputB;
            Out = InputA - InputB;
            if(InputA == 'b10000000 || InputA == 'b10000001 || InputA == 'b10000010 || InputA == 'b10000011) begin
                Vflow = InputA<InputB;
            end else begin
                Vflow = (InputA[7] != InputB[7]) && (InputA[7] != Out[7]);
            end
            case(Out)
                'b0     : Zero = 1'b1;
                default : Zero = 1'b0;
            endcase
            case(Out[7])
                'b1     : Neg = 1'b1;
                default : Neg = 1'b0;
            endcase
        end
    end
    
end


endmodule