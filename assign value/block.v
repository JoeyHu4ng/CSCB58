module block(c, a, b, clk);
   output c, b;
   input  a, clk;
   reg 	  c, b;
   always @(posedge clk)
     begin
	b = a;
	c = b;
     end
endmodule // block
