module mux(X, Y, S, M);
   input X, Y, S;
   output M;

   assign M = X & ~S | Y & S;
endmodule // mux
