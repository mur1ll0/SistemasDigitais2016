module Cubo_move_VGA(
		input CLOCK_50,
		input [3:0] KEY,
		input [9:0] SW,
		output [3:0] VGA_R,
		output [3:0] VGA_G,
		output [3:0] VGA_B,
		output VGA_HS,
		output VGA_VS
		);
		
	integer h_count, v_count, x_pos, y_pos, size;
	
	reg [3:0] Red;
	reg [3:0] Green;
	reg [3:0] Blue;
	
	reg CLK_25;
	reg clock_state;
	
	assign VGA_R = Red;
	assign VGA_G = Green;
	assign VGA_B = Blue;
	assign VGA_HS = (h_count >= 660 && h_count <= 756) ? 0:1;
	assign VGA_VS = (v_count >= 494 && v_count <= 495) ? 0:1;
	
	always @(posedge CLOCK_50) begin
		if (clock_state == 0) begin
			CLK_25 = ~CLK_25;
		end
		else begin
			clock_state = ~clock_state;
		end
	end
	
	always @(posedge CLK_25) begin
		if (SW[0] == 0) begin
			h_count <= 0;
			v_count <= 0;
			x_pos <= 300;
			y_pos <= 220;
			size <= 50;
		end
		else begin
			if (h_count < 799) begin
				h_count <= h_count + 1;
			end
			else begin
				h_count <= 0;
				if (v_count < 524) begin
					v_count <= v_count + 1;
				end
				else begin
					if(KEY[3] == 0) begin
						if(x_pos > 1) x_pos <= x_pos - 3;
					end
					else if(KEY[2] == 0) begin
						if(x_pos < 640-size) x_pos <= x_pos + 3;
					end
					else if(KEY[1] == 0) begin
						if(y_pos < 480-size) y_pos <= y_pos + 3;
					end
					else if(KEY[0] == 0) begin
						if(y_pos > 1) y_pos <= y_pos - 3;
					end
					v_count <= 0;
				end
			end
		end
	end
	
	//Desenhar Figura
	always @(h_count or v_count) begin
		if (v_count < 480 && h_count < 640) begin
			if (v_count >= y_pos && v_count <= y_pos+size) begin
				if (h_count >= x_pos && h_count <= x_pos+size) begin
					Red <= 4'b1010;
					Green <= 4'b0010;
					Blue <= 4'b1101;
				end
				else begin
					Red <= 4'b1111;
					Green <= 4'b1111;
					Blue <= 4'b1111;
				end
			end
			else begin
				Red <= 4'b1111;
				Green <= 4'b1111;
				Blue <= 4'b1111;
			end
		end
		//Se nao estiver dentro da tela, não joga cor nenhuma
		else begin
			Red <= 4'b0000;
			Green <= 4'b0000;
			Blue <= 4'b0000;
		end
	end
	
endmodule
