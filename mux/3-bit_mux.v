module mux(X, Y, S, M);
   input [2:0] X, Y;
   input S;
   output [2:0] M;

   assign M[0] = X[0] & ~S | Y[0] & S;
   assign M[1] = X[1] & ~S | Y[1] & S;
   assign M[2] = X[2] & ~S | Y[2] & S;
endmodule // mux
