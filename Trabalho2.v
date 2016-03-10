module BlinkLed(
	input CLOCK_50,
	input [3:0] KEY,
	output [7:0] LEDG);
	
	reg [32:0] cont;
	reg [7:0] state;
	
	assign LEDG[0] = state[0];
	
	always @ (posedge CLOCK_50 or posedge KEY[0]) begin
		cont = cont + 1;
		if (cont == 50000000 && state[0] == 0) begin
			state[0] <= 1;
			cont <= 0;
		end
		else if (cont == 50000000 && state[0] == 1) begin
			state[0] <= 0;
			cont <= 0;
		end
		if (KEY[0] == 1) begin
			state[0] <= 0;
			cont <= 0;
		end
	end
endmodule
	