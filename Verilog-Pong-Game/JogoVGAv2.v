module calcCircle(
		input [9:0] px,
		input [9:0] py,
		input [9:0] cx,
		input [9:0] cy,
		input [9:0] size,
		output result
		);
		
		wire signed [10:0] s1;
		wire signed [10:0] s2;
		wire signed [20:0] m1;
		wire signed [20:0] m2;
		wire signed [21:0] s3;
		wire signed [15:0] m3;
		
		assign s1 = px - cx;
		assign s2 = py - cy;
		assign m1 = s1 * s1;
		assign m2 = s2 * s2;
		assign s3 = m1 + m2;
		assign m3 = size * size;
		
		assign result = s3 < m3;

endmodule

module JogoVGAv2(
		input CLOCK_50,
		input [3:0] KEY,
		input [9:0] SW,
		output [3:0] VGA_R,
		output [3:0] VGA_G,
		output [3:0] VGA_B,
		output VGA_HS,
		output VGA_VS
		);
	
	///////////////////
	//   VARIABLES   //
	///////////////////
	
	reg [9:0] x_pos1;
	reg [9:0] y_pos1;
	reg [9:0] x_pos2;
	reg [9:0] y_pos2;
	
	reg [9:0] ball_x_pos;
	reg [9:0] ball_y_pos;
	
	
	reg [9:0] size_c;
	reg [9:0] speed;
	reg [9:0] size;
	
	reg signed [2:0] UD;
	reg LR;
	
	wire result;
	
	calcCircle C(h_count, v_count, ball_x_pos, ball_y_pos, size_c, result);
	
	/////////////////////
	//   VGA CONTROL   //
	/////////////////////
	
	reg [9:0] h_count;
	reg [9:0] v_count;
	
	reg [3:0] Red;
	reg [3:0] Green;
	reg [3:0] Blue;
	
	reg CLK_25;
	reg clock_state;
	
	assign VGA_R = (h_count < 640 && v_count < 480)? Red:4'b0000;
	assign VGA_G = (h_count < 640 && v_count < 480)? Green:4'b0000;
	assign VGA_B = (h_count < 640 && v_count < 480)? Blue:4'b0000;
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
		if (SW[9] == 0) begin
			speed <= 3;
			UD <= 0;
			ball_x_pos <= 320;
			ball_y_pos <= 240;
		end
		
		if (SW[0] == 0) begin
			UD <= 0;
			LR <= 0;
			size_c <= 15;
			size <= 40;
			x_pos1 <= 40;
			y_pos1 <= 220;
			x_pos2 <= 585;
			y_pos2 <= 220;
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
				
					////////////////////
					//   GAME LOGIC   //
					////////////////////
					
					//PLAYER 1
					if(KEY[3] == 0 && y_pos1 > 5) begin
						y_pos1 <= y_pos1 - 5;
					end
					else if(KEY[2] == 0 && y_pos1 < 475 - size) begin
						y_pos1 <= y_pos1 + 5;
					end
					
					//PLAYER 2
					if(KEY[0] == 0 && y_pos2 > 5) begin
						y_pos2 <= y_pos2 - 5;
					end
					else if(KEY[1] == 0 && y_pos2 < 475 - size) begin
						y_pos2 <= y_pos2 + 5;
					end
					
					//BALL					
					if (LR == 0) begin
						if (ball_x_pos - size_c <= x_pos1 + 15 && ball_y_pos >= y_pos1 && ball_y_pos <= y_pos1 + size) begin
							LR <= 1;
							// only work for size == 40
							if (ball_y_pos < x_pos1 + 5) begin
								UD <= -3;
							end
							else if (ball_y_pos >= x_pos1 + 5 && ball_y_pos < 10) begin
								UD <= -2;
							end
							else if (ball_y_pos >= x_pos1 + 10 && ball_y_pos < 18) begin
								UD <= -1;
							end
							else if (ball_y_pos >= x_pos1 + 18 && ball_y_pos < 22) begin
								UD <= 0;
							end
							else if (ball_y_pos >= x_pos1 + 22 && ball_y_pos < 30) begin
								UD <= +1;
							end
							else if (ball_y_pos >= x_pos1 + 30 && ball_y_pos < 35) begin
								UD <= +2;
							end
							else if (ball_y_pos >= x_pos1 + 35) begin
								UD <= +3;
							end
						end
						else if (ball_x_pos - size_c <= 5) begin
							speed <= 0;
							UD <= 0;
						end
						else begin
							ball_x_pos <= ball_x_pos - speed;
						end
					end
					else if (LR == 1) begin
						if (ball_x_pos + size_c >= x_pos2 && ball_y_pos >= y_pos1 && ball_y_pos <= y_pos1 + size) begin
							LR <= 0;
							// only work for size == 40
							if (ball_y_pos < x_pos1 + 5) begin
								UD <= -3;
							end
							else if (ball_y_pos >= x_pos1 + 5 && ball_y_pos < 10) begin
								UD <= -2;
							end
							else if (ball_y_pos >= x_pos1 + 10 && ball_y_pos < 18) begin
								UD <= -1;
							end
							else if (ball_y_pos >= x_pos1 + 18 && ball_y_pos < 22) begin
								UD <= 0;
							end
							else if (ball_y_pos >= x_pos1 + 22 && ball_y_pos < 30) begin
								UD <= +1;
							end
							else if (ball_y_pos >= x_pos1 + 30 && ball_y_pos < 35) begin
								UD <= +2;
							end
							else if (ball_y_pos >= x_pos1 + 35) begin
								UD <= +3;
							end
						end
						else if (ball_x_pos + size_c >= 635) begin
							speed <= 0;
							UD <= 0;
						end
						else begin
							ball_x_pos <= ball_x_pos + speed;
						end
					end
					
					if (ball_y_pos - size_c <= 5 || ball_y_pos + size_c >= 475) begin
						if (UD == -3) begin
							UD <= 3;
						end
						else if (UD == -2) begin
							UD <= 2;
						end
						else if (UD == -1) begin
							UD <= 1;
						end
						else if (UD == 1) begin
							UD < -1;
						end
						else if (UD == 2) begin
							UD <= -2;
						end
						else if (UD == 3) begin
							UD <= -3;
						end
					end
					else if (UD > 0 && ball_x_pos - size_c < x_pos1 + 15 && ball_x_pos + size_c > x_pos1 && ball_y_pos + size_c <= y_pos1) begin
						if (UD == 1) begin
							UD < -1;
						end
						else if (UD == 2) begin
							UD <= -2;
						end
						else if (UD == 3 || UD == 0) begin
							UD <= -3;
						end
						
					end
					else if (UD > 0 && ball_x_pos + size_c > x_pos2 && ball_x_pos - size_c < x_pos2 + 15 && ball_y_pos + size_c <= y_pos2) begin
						if (UD == 1) begin
							UD < -1;
						end
						else if (UD == 2) begin
							UD <= -2;
						end
						else if (UD == 3 || UD == 0) begin
							UD <= -3;
						end
					end
					else if (UD < 0 && ball_x_pos - size_c < x_pos1 + 15 && ball_x_pos + size_c > x_pos1 && ball_y_pos - size_c >= y_pos1 + size) begin
						if (UD == -3 || UD == 0) begin
							UD <= 3;
						end
						else if (UD == -2) begin
							UD <= 2;
						end
						else if (UD == -1) begin
							UD <= 1;
						end
					end
					else if (UD < 0 && ball_x_pos + size_c > x_pos2 && ball_x_pos - size_c < x_pos2 + 15 && ball_y_pos - size_c >= y_pos2 + size) begin
						if (UD == -3 || UD == 0) begin
							UD <= 3;
						end
						else if (UD == -2) begin
							UD <= 2;
						end
						else if (UD == -1) begin
							UD <= 1;
						end
					end
					else begin
						ball_y_pos <= ball_y_pos + UD;
						/*if (UD == -3) begin
							ball_y_pos <= ball_y_pos - 3;
						end
						else if (UD == -2) begin
							ball_y_pos <= ball_y_pos - 2;
						end
						else if (UD == -1) begin
							ball_y_pos <= ball_y_pos - 1;
						end
						else if (UD == 1) begin
							ball_y_pos <= ball_y_pos + 1;
						end
						else if (UD == 2) begin
							ball_y_pos <= ball_y_pos + 2;
						end
						else if (UD == 3) begin
							ball_y_pos <= ball_y_pos + 3;
						end*/
					end	
					
					v_count <= 0;
				end
			end
		end
	end
	
	////////////////////////
	//    DRAW FIGURES    //
	////////////////////////
	
	always @(posedge CLK_25) begin
		if (v_count < 480 && h_count < 640) begin
			//Draw Player 1
			if (v_count >= y_pos1 && v_count <= y_pos1 + size && h_count >= x_pos1 && h_count <= x_pos1 + 15) begin
				Red <= 4'b1111;
				Green <= 4'b0000;
				Blue <= 4'b0000;
			end
			//Draw Player 2
			else if (v_count >= y_pos2 && v_count <= y_pos2 + size && h_count >= x_pos2 && h_count <= x_pos2 + 15) begin
				Red <= 4'b0000;
				Green <= 4'b0000;
				Blue <= 4'b1111;
			end
			//Draw Ball
			else if (result == 1) begin
				Red <= 4'b0000;
				Green <= 4'b1111;
				Blue <= 4'b0000;
			end
			//Draw Borders
			else if (h_count <= 5 || h_count >= 635 || v_count <= 5 || v_count >= 475) begin
				Red <= 4'b1010;
				Green <= 4'b1010;
				Blue <= 4'b1010;
			end
			
			//Draw Floor
			else begin
				Red <= 4'b1111;
				Green <= 4'b1111;
				Blue <= 4'b1111;
			end
		end
		//Out of screen
		else begin
			Red <= 4'b0000;
			Green <= 4'b0000;
			Blue <= 4'b0000;
		end
	end
	
endmodule