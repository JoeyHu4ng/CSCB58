module lab_2c(SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);
    input [10:0] SW;
    output [7:0] LEDR;
    output [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
    
    hex_display hex_A(
                .IN(SW[7:4]),
                .OUT(HEX2[7:0])
                );
    
    hex_display hex_B(
                .IN(SW[3:0]),
                .OUT(HEX0[7:0])
                );

    hex_display hex_C(
                .IN(4'b0000),
                .OUT(HEX1[7:0])
                );

    hex_display hex_D(
                .IN(4'b0000),
                .OUT(HEX3[7:0])
                );
                
    alu my_alu(
                .A(SW[7:4]),
                .B(SW[3:0]),
                .func(SW[10:8]),
                .ALUOUT(LEDR[7:0]),
                .HEX1(HEX4[7:0]),
                .HEX2(HEX5[7:0])
                );
endmodule

module alu(A, B, func, ALUOUT, HEX1, HEX2);
    input [3:0] A, B;
    input [2:0] func;
    output [7:0] ALUOUT, HEX1, HEX2;
    reg [7:0] ALUOUT;
    
    wire [7:0] y;
    assign y[7:5] = 3'b000;
    
    adder_4bit adder(1'b0, A, B, y[3:0], y[4]);
	 
	 hex_display hex_A(
							.IN(ALUOUT[3:0]),
							.OUT(HEX1[7:0])
							);
							
	 hex_display hex_B(
							.IN(ALUOUT[7:4]),
							.OUT(HEX2[7:0])
							);
    
    always @(*)
        begin
            case (func)
                3'b000: ALUOUT[7:0] = y[7:0];
                3'b001: ALUOUT[7:0] = A + B;
                3'b010: begin
                    ALUOUT[3:0] = A ^ B;
                    ALUOUT[7:4] = A | B;
                    end
                3'b011: ALUOUT[7:0] = |A | |B;
                3'b100: ALUOUT[7:0] = &A & &B;
                3'b101: ALUOUT[7:0] = {A[3:0], B[3:0]};
                default: ALUOUT[7:0] = 8'b00000000;
            endcase
        end
endmodule

module adder(cin, a, b, s, cout);
   input cin;
   input a;
   input b;
   output cout;
   output s;

   assign s = a ^ b ^ cin;
   assign cout = a & b | a & cin | b & cin;
endmodule // adder

module adder_4bit(cin, A, B, S, cout);
   input [3:0] A, B;
   input       cin;
   output [3:0] S;
   output       cout;
   wire [2:0]   y;

   adder part1(cin, A[0], B[0], S[0], y[0]);
   adder part2(y[0], A[1], B[1], S[1], y[1]);
   adder part3(y[1], A[2], B[2], S[2], y[2]);
   adder part4(y[2], A[3], B[3], S[3], cout);
endmodule // adder_4bit

module hex_display(IN, OUT);
    input [3:0] IN;
	 output reg [7:0] OUT;
	 
	 always @(*)
	 begin
		case(IN[3:0])
			4'b0000: OUT = 7'b1000000;
			4'b0001: OUT = 7'b1111001;
			4'b0010: OUT = 7'b0100100;
			4'b0011: OUT = 7'b0110000;
			4'b0100: OUT = 7'b0011001;
			4'b0101: OUT = 7'b0010010;
			4'b0110: OUT = 7'b0000010;
			4'b0111: OUT = 7'b1111000;
			4'b1000: OUT = 7'b0000000;
			4'b1001: OUT = 7'b0011000;
			4'b1010: OUT = 7'b0001000;
			4'b1011: OUT = 7'b0000011;
			4'b1100: OUT = 7'b1000110;
			4'b1101: OUT = 7'b0100001;
			4'b1110: OUT = 7'b0000110;
			4'b1111: OUT = 7'b0001110;
			
			default: OUT = 7'b0111111;
		endcase

	end
endmodule
