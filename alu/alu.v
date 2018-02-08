module lab_3a(SW, KEY, LEDR, HEX0, HEX4, HEX5);
  input [17:0] SW;
  input [3:0] KEY;
  output [7:0] LEDR;
  output [7:0] HEX0, HEX4, HEX5;
  
  hex_display A(
    .IN(SW[3:0]),
    .OUT(HEX0[7:0])
    );
  
  alu my_alu(
    .A(SW[3:0]),
    .reset(SW[9]),
    .func(SW[17:15]),
    .clk(KEY[0]),
    .OUT(LEDR[7:0]),
    .most(HEX5[7:0]),
    .least(HEX4[7:0])
    );
endmodule

module alu(A, func, clk, OUT, most, least, reset);
  input [3:0] A;
  input [2:0] func;
  input clk;
  input reset;
  output [7:0] OUT;
  output [7:0] most, least;
  wire [7:0] y0; // wire to connect adder
  reg [7:0] y1; // connect the output of alu and the registe
  wire [3:0] B;
  assign B = OUT[3:0];
  
  adder_4bit case_zero(1'b0, A, B, y0[3:0], y0[4]);
  
  always @(*)
  begin
    case(func)
      3'd0: y1 = y0;
      3'd1: y1 = A + B;
      3'd2: begin
        y1[3:0] = A ^ B;
        y1[7:4] = A | B;
        end
      3'd3: y1 = |A | |B;
      3'd4: y1 = &A & &B;
      3'd5: y1 = B << A;
      3'd6: y1 = B >>> A;
      3'd7: y1 = A * B;
      default: y1 = 8'd0;
    endcase
  end
  
  dflipflop out_reg(
    .q(OUT),
    .d(y1),
    .clk(clk),
    .reset_n(reset)
    );
  
  hex_display most_hex(
    .IN(OUT[7:4]),
    .OUT(most)
    );
  
  hex_display least_hex(
    .IN(OUT[3:0]),
    .OUT(least)
    );
  
endmodule

module dflipflop(q, d, clk, reset_n);
  input reset_n;
  input clk;
  input [7:0] d;
  output [7:0] q;
  reg [7:0] q;
  
  always @(posedge clk)
  begin
    if (reset_n == 1'b0)
      q <= 0;
    else
      q <= d;
  end
endmodule


// adders from lab2 part2
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
