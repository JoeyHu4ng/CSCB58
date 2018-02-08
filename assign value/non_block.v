module non_block(c, a, b, clk);
   output c, d;
   input  a, clk;
   reg 	  c, d;
   always @(posedge clk)
     begin
	b <= a;
	c <= b;
     end
endmodule // non_block
