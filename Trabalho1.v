module Values(
    input clk,
        output fio
   );

   assign fio = clk;

endmodule

module Teste;

    reg clk;
	wire fio;
	  
	always #5 clk = ~clk;


    Values TESTANDO(clk
                  , fio
                  );

    initial begin
        $dumpvars(0, TESTANDO);
        #10;
		clk <= 0;
        #500;
        $finish;
    end
endmodule
