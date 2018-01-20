module mux(X, Y, S, M);
   parameter N = 3;
   input [N:1] X, Y;
   input       S;
   output [N:1] M;

   assign M = S ? Y : X;
endmodule // mux
