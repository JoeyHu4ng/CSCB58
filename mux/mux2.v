module mux (X, Y, S, M);
   input X, Y, S;
   output M;

   reg 	  M;
   always @(X or Y or S)
     if (!S) M = X;
     else M = Y;
endmodule // mux

   
