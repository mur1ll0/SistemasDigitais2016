module BlinkLed(
	input CLOCK_50,
	output [7:0] LEDG);
	
	reg [32:0] cont;
	reg state;
	
	assign LEDG[0] = state;
	
	always @ (posedge CLOCK_50) begin
		cont = cont + 1;
		if (cont == 50000000 && state == 0) begin
			state <= 1;
			cont <= 0;
		end
		else if (cont == 50000000 && state == 1) begin
			state <= 0;
			cont <= 0;
		end
	end
endmodule
	
