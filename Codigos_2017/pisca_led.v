module calculo(
		input clock,
		output state
		);
		reg [27:0] r1;
		reg st;
		assign state = st;
		always @(negedge clock) begin
			r1 <= r1 + 1;
			if (r1 == 50000000) begin
				st <= ~st;
				r1 <= 0;
			end
		end
endmodule

module Principal(
		input CLOCK_50,
		output [7:0] LEDG
		);
		wire state;
		calculo Batata(CLOCK_50, state);
		assign LEDG[0] = state;
endmodule
