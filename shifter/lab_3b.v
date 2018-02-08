module lab_3b(SW, KEY, LEDR, HEX4, HEX5);
	input [17:0] SW;
	input [3:0] KEY;
	output [7:0] LEDR;
	output [7:0] HEX4, HEX5;
	
	shifter my_shifter(
		.loadVal(SW[7:0]),
		.reset_n(SW[9]),
		.clk(KEY[0]),
		.Load_n(SW[17]),
		.ShiftRight(SW[16]),
		.ASR(SW[15]),
		.OUT(LEDR[7:0]),
		.most(HEX5),
		.least(HEX4)
		);
endmodule

module shifter(loadVal, Load_n, ShiftRight, ASR, clk, reset_n, OUT, most, least);
	input [7:0] loadVal;
	input Load_n;
	input ShiftRight;
	input ASR;
	input clk;
	input reset_n;
	output [7:0] OUT;
	
	shifter_bit part7(loadVal[7], ASR ? OUT[7] : 0, ShiftRight, Load_n, clk, reset_n, OUT[7]);
	shifter_bit part6(loadVal[6], OUT[7], ShiftRight, Load_n, clk, reset_n, OUT[6]);
	shifter_bit part5(loadVal[5], OUT[6], ShiftRight, Load_n, clk, reset_n, OUT[5]);
	shifter_bit part4(loadVal[4], OUT[5], ShiftRight, Load_n, clk, reset_n, OUT[4]);
	shifter_bit part3(loadVal[3], OUT[4], ShiftRight, Load_n, clk, reset_n, OUT[3]);
	shifter_bit part2(loadVal[2], OUT[3], ShiftRight, Load_n, clk, reset_n, OUT[2]);
	shifter_bit part1(loadVal[1], OUT[2], ShiftRight, Load_n, clk, reset_n, OUT[1]);
	shifter_bit part0(loadVal[0], OUT[1], ShiftRight, Load_n, clk, reset_n, OUT[0]);
	
	hex_display most_hex(
		.IN(OUT[7:4]),
		.OUT(most)
		);
	
	hex_display least_hex(
		.IN(OUT[3:0]),
		.OUT(least)
		);

endmodule

module shifter_bit(load_val, in, shift, load_n, clk, reset_n, out);
	input load_val;
	input in;
	input shift;
	input load_n;
	input clk;
	input reset_n;
	output out;
	
	wire y0, y1;
	
	mux2to1 mux_of_in(out, in, shift, y0);
	mux2to1 mux_of_avl(load_val, y0, load_n, y1);
	dflipflop my_dfilpflop(out, y1, clk, reset_n);
endmodule

module dflipflop(q, d, clk, reset_n);
	input reset_n;
	input clk;
	input d;
	output q;
	reg q;
	
	always @(posedge clk)
	begin
		if (reset_n == 1'b0)
			q <= 0;
		else
			q <= d;
	end
endmodule

module mux2to1(x, y, s, m);
    input x; //selected when s is 0
    input y; //selected when s is 1
    input s; //select signal
    output m; //output
  
    assign m = s ? y : x;
	
endmodule

// 7 segment decoder from lab1 part3
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
