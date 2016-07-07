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

module JogoVGAv4(
		input CLOCK_50,
		input [3:0] KEY,
		input [9:0] SW,
		output [3:0] VGA_R,
		output [3:0] VGA_G,
		output [3:0] VGA_B,
		output [6:0] HEX0,
		output [6:0] HEX1,
		output [6:0] HEX2,
		output [6:0] HEX3,
		output VGA_HS,
		output VGA_VS
		);
	
	///////////////////
	//   VARIABLES   //
	///////////////////
	
	integer blink_count;
	reg blink;
	
	reg numbers_active;
	reg [6:0] N0;
	reg [6:0] N1;
	reg [6:0] N2;
	reg [6:0] N3;
	
	assign HEX0 = N0;
	assign HEX1 = N1;
	assign HEX2 = N2;
	assign HEX3 = N3;
	
	reg [9:0] x_pos1;
	reg [9:0] y_pos1;
	reg [9:0] x_pos2;
	reg [9:0] y_pos2;
	
	reg [9:0] ball_x_pos;
	reg [9:0] ball_y_pos;
	
	
	reg [9:0] size_c;
	reg [9:0] speed;
	reg [9:0] size;
	reg [2:0] score1;
	reg [2:0] score2;
	
	reg signed [2:0] UD;
	reg LR;
	
	wire result;
	wire numbers_out;
	
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
		if (blink_count == 50000000) begin
			blink <= ~blink;
			blink_count <= 0;
		end
		else begin
			blink_count <= blink_count + 1;
		end
		
		if (clock_state == 0) begin
			CLK_25 = ~CLK_25;
		end
		else begin
			clock_state = ~clock_state;
		end
	end
	
	always @(posedge CLK_25) begin
		if (SW[9] == 0 && score1 < 5 && score2 < 5) begin
			speed <= 4;
			UD <= 0;
			ball_x_pos <= 320;
			ball_y_pos <= 240;
			numbers_active <= 0;
		end
		
		if (SW[0] == 0) begin
			UD <= 0;
			LR <= 0;
			score1 <= 0;
			score2 <= 0;
			size_c <= 7;
			size <= 40;
			x_pos1 <= 40;
			y_pos1 <= 220;
			x_pos2 <= 585;
			y_pos2 <= 220;
			numbers_active <= 1;
		end

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
				if(KEY[3] == 0 && y_pos1 > 15) begin
					y_pos1 <= y_pos1 - 3;
				end
				else if(KEY[2] == 0 && y_pos1 < 465 - size) begin
					y_pos1 <= y_pos1 + 3;
				end
				
				//PLAYER 2
				if(KEY[0] == 0 && y_pos2 > 15) begin
					y_pos2 <= y_pos2 - 3;
				end
				else if(KEY[1] == 0 && y_pos2 < 465 - size) begin
					y_pos2 <= y_pos2 + 3;
				end
				
				//BALL					
				if (LR == 0) begin
					if (ball_x_pos - size_c <= x_pos1 + 15 && ball_x_pos > x_pos1 + 15 && ball_y_pos + size_c >= y_pos1 && ball_y_pos - size_c <= y_pos1 + size) begin
						LR <= 1;
						// only work for size == 40
						if (ball_x_pos < y_pos1 + 5) begin
							UD <= -3;
						end
						else if (ball_y_pos >= y_pos1 + 5 && ball_y_pos < y_pos1 + 10) begin
							UD <= -2;
						end
						else if (ball_y_pos >= y_pos1 + 10 && ball_y_pos < y_pos1 + 17) begin
							UD <= -1;
						end
						else if (ball_y_pos >= y_pos1 + 17 && ball_y_pos < y_pos1 + 23) begin
							UD <= 0;
						end
						else if (ball_y_pos >= y_pos1 + 23 && ball_y_pos < y_pos1 + 30) begin
							UD <= 1;
						end
						else if (ball_y_pos >= y_pos1 + 30 && ball_y_pos < y_pos1 + 35) begin
							UD <= 2;
						end
						else if (ball_y_pos >= y_pos1 + 35) begin
							UD <= 3;
						end
					end
					else if (speed != 0 && ball_x_pos - size_c <= 15) begin
						speed <= 0;
						UD <= 0;
						numbers_active <= 1;
						score2 <= score2 + 1;
					end
					else begin
						ball_x_pos <= ball_x_pos - speed;
					end
				end
				else if (LR == 1) begin
					if (ball_x_pos + size_c >= x_pos2 && ball_x_pos < x_pos2 && ball_y_pos + size_c >= y_pos2 && ball_y_pos - size_c <= y_pos2 + size) begin
						LR <= 0;
						// only work for size == 40
						if (ball_y_pos < y_pos2 + 5) begin
							UD <= -3;
						end
						else if (ball_y_pos >= y_pos2 + 5 && ball_y_pos < y_pos2 + 10) begin
							UD <= -2;
						end
						else if (ball_y_pos >= y_pos2 + 10 && ball_y_pos < y_pos2 + 17) begin
							UD <= -1;
						end
						else if (ball_y_pos >= y_pos2 + 17 && ball_y_pos < y_pos2 + 23) begin
							UD <= 0;
						end
						else if (ball_y_pos >= y_pos2 + 23 && ball_y_pos < y_pos2 + 30) begin
							UD <= 1;
						end
						else if (ball_y_pos >= y_pos2 + 30 && ball_y_pos < y_pos2 + 35) begin
							UD <= 2;
						end
						else if (ball_y_pos >= y_pos2 + 35) begin
							UD <= 3;
						end
					end
					else if (speed != 0 && ball_x_pos + size_c >= 625) begin
						speed <= 0;
						UD <= 0;
						numbers_active <= 1;
						score1 <= score1 + 1;
					end
					else begin
						ball_x_pos <= ball_x_pos + speed;
					end
				end
				
				if (UD < 0 && ball_y_pos - size_c <= 15) begin
					if (UD == -3) begin
						UD <= 3;
					end
					else if (UD == -2) begin
						UD <= 2;
					end
					else if (UD == -1) begin
						UD <= 1;
					end
					
				end
				else if (UD > 0 && ball_y_pos + size_c >= 465) begin
					if (UD == 1) begin
						UD <= -1;
					end
					else if (UD == 2) begin
						UD <= -2;
					end
					else if (UD == 3) begin
						UD <= -3;
					end
				end
				
				else if (UD > 0 && ball_x_pos - size_c < x_pos1 + 15 && ball_x_pos + size_c > x_pos1 && ball_y_pos + size_c >= y_pos1 && ball_y_pos < y_pos1) begin
					if (UD == 1) begin
						UD <= -1;
					end
					else if (UD == 2) begin
						UD <= -2;
					end
					else if (UD == 3 || UD == 0) begin
						UD <= -3;
					end
					
				end
				else if (UD > 0 && ball_x_pos + size_c > x_pos2 && ball_x_pos - size_c < x_pos2 + 15 && ball_y_pos + size_c >= y_pos2 && ball_y_pos < y_pos2) begin
					if (UD == 1) begin
						UD <= -1;
					end
					else if (UD == 2) begin
						UD <= -2;
					end
					else if (UD == 3 || UD == 0) begin
						UD <= -3;
					end
				end
				else if (UD < 0 && ball_x_pos - size_c < x_pos1 + 15 && ball_x_pos + size_c > x_pos1 && ball_y_pos - size_c <= y_pos1 + size && ball_y_pos > y_pos1 + size) begin
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
				else if (UD < 0 && ball_x_pos + size_c > x_pos2 && ball_x_pos - size_c < x_pos2 + 15 && ball_y_pos - size_c <= y_pos2 + size && ball_y_pos > y_pos2 + size) begin
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
					if (UD == -3) begin
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
					end
				end
				
				v_count <= 0;
			end
		end
	end
	
	////////////////////////
	//    DRAW FIGURES    //
	////////////////////////
	
	always @(posedge CLOCK_50) begin
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
			//Draw Borders
			else if (h_count <= 15 || h_count >= 625 || v_count <= 15 || v_count >= 465) begin
				Red <= 4'b1010;
				Green <= 4'b1010;
				Blue <= 4'b1010;
			end
			//Draw Numbers on screen
			//Trace for numbers
			else if (numbers_active == 1 && h_count > 290 && h_count < 350 && v_count > 235 && v_count < 245) begin
				Red <= 4'b0011;
				Green <= 4'b0011;
				Blue <= 4'b0011;
			end
			//Numbers Player 1
			else if (numbers_active == 1 && N3[0] == 0 && v_count > 175 && v_count < 180 && h_count > 150 && h_count < 250) begin
				Red <= 4'b0011;
				Green <= 4'b0011;
				Blue <= 4'b0011;
			end
			
			else if (numbers_active == 1 && N3[1] == 0 && v_count >= 180 && v_count < 240 && h_count > 245 && h_count < 250) begin
				Red <= 4'b0011;
				Green <= 4'b0011;
				Blue <= 4'b0011;
			end
			
			else if (numbers_active == 1 && N3[2] == 0 && v_count >= 240 && v_count < 300 && h_count > 245 && h_count < 250) begin
				Red <= 4'b0011;
				Green <= 4'b0011;
				Blue <= 4'b0011;
			end
			
			else if (numbers_active == 1 && N3[3] == 0 && v_count >= 295 && v_count < 300 && h_count > 150 && h_count < 250) begin
				Red <= 4'b0011;
				Green <= 4'b0011;
				Blue <= 4'b0011;
			end
			
			else if (numbers_active == 1 && N3[4] == 0 && v_count >= 240 && v_count < 300 && h_count > 150 && h_count < 155) begin
				Red <= 4'b0011;
				Green <= 4'b0011;
				Blue <= 4'b0011;
			end
			
			else if (numbers_active == 1 && N3[5] == 0 && v_count >= 180 && v_count < 240 && h_count > 150 && h_count < 155) begin
				Red <= 4'b0011;
				Green <= 4'b0011;
				Blue <= 4'b0011;
			end
			
			else if (numbers_active == 1 && N3[6] == 0 && v_count > 237 && v_count < 243 && h_count > 150 && h_count < 250) begin
				Red <= 4'b0011;
				Green <= 4'b0011;
				Blue <= 4'b0011;
			end
			
			//Numbers Player 2
			else if (numbers_active == 1 && N0[0] == 0 && v_count > 175 && v_count < 180 && h_count > 390 && h_count < 490) begin
				Red <= 4'b0011;
				Green <= 4'b0011;
				Blue <= 4'b0011;
			end
			
			else if (numbers_active == 1 && N0[1] == 0 && v_count >= 180 && v_count < 240 && h_count > 485 && h_count < 490) begin
				Red <= 4'b0011;
				Green <= 4'b0011;
				Blue <= 4'b0011;
			end
			
			else if (numbers_active == 1 && N0[2] == 0 && v_count >= 240 && v_count < 300 && h_count > 485 && h_count < 490) begin
				Red <= 4'b0011;
				Green <= 4'b0011;
				Blue <= 4'b0011;
			end
			
			else if (numbers_active == 1 && N0[3] == 0 && v_count > 295 && v_count < 300 && h_count > 390 && h_count < 490) begin
				Red <= 4'b0011;
				Green <= 4'b0011;
				Blue <= 4'b0011;
			end
			
			else if (numbers_active == 1 && N0[4] == 0 && v_count >= 240 && v_count < 300 && h_count > 390 && h_count < 395) begin
				Red <= 4'b0011;
				Green <= 4'b0011;
				Blue <= 4'b0011;
			end
			
			else if (numbers_active == 1 && N0[5] == 0 && v_count >= 180 && v_count < 240 && h_count > 390 && h_count < 395) begin
				Red <= 4'b0011;
				Green <= 4'b0011;
				Blue <= 4'b0011;
			end
			
			else if (numbers_active == 1 && N0[6] == 0 && v_count > 237 && v_count < 243 && h_count > 390 && h_count < 490) begin
				Red <= 4'b0011;
				Green <= 4'b0011;
				Blue <= 4'b0011;
			end
			
			//Draw Ball
			else if (result == 1) begin
				Red <= 4'b0000;
				Green <= 4'b1111;
				Blue <= 4'b0000;
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
		
		//7-Segments Display
		N1[0] <= 1;
		N1[1] <= 1;
		N1[2] <= 1;
		N1[3] <= 1;
		N1[4] <= 1;
		N1[5] <= 1;
		N1[6] <= 0;
		
		N2[0] <= 1;
		N2[1] <= 1;
		N2[2] <= 1;
		N2[3] <= 1;
		N2[4] <= 1;
		N2[5] <= 1;
		N2[6] <= 0;
		
		//Numbers Control
		//Player 1
		if (score1 == 0) begin
			N3[0] <= 0;
			N3[1] <= 0;
			N3[2] <= 0;
			N3[3] <= 0;
			N3[4] <= 0;
			N3[5] <= 0;
			N3[6] <= 1;
		end
		else if (score1 == 1) begin
			N3[0] <= 1;
			N3[1] <= 0;
			N3[2] <= 0;
			N3[3] <= 1;
			N3[4] <= 1;
			N3[5] <= 1;
			N3[6] <= 1;
		end
		else if (score1 == 2) begin
			N3[0] <= 0;
			N3[1] <= 0;
			N3[2] <= 1;
			N3[3] <= 0;
			N3[4] <= 0;
			N3[5] <= 1;
			N3[6] <= 0;
		end
		else if (score1 == 3) begin
			N3[0] <= 0;
			N3[1] <= 0;
			N3[2] <= 0;
			N3[3] <= 0;
			N3[4] <= 1;
			N3[5] <= 1;
			N3[6] <= 0;
		end
		else if (score1 == 4) begin
			N3[0] <= 1;
			N3[1] <= 0;
			N3[2] <= 0;
			N3[3] <= 1;
			N3[4] <= 1;
			N3[5] <= 0;
			N3[6] <= 0;
		end
		else if (blink == 1 && score1 == 5) begin
			N3[0] <= 0;
			N3[1] <= 1;
			N3[2] <= 0;
			N3[3] <= 0;
			N3[4] <= 1;
			N3[5] <= 0;
			N3[6] <= 0;
		end
		else begin
			N3[0] <= 1;
			N3[1] <= 1;
			N3[2] <= 1;
			N3[3] <= 1;
			N3[4] <= 1;
			N3[5] <= 1;
			N3[6] <= 1;
		end
		
		//Player 2
		if (score2 == 0) begin
			N0[0] <= 0;
			N0[1] <= 0;
			N0[2] <= 0;
			N0[3] <= 0;
			N0[4] <= 0;
			N0[5] <= 0;
			N0[6] <= 1;
		end
		else if (score2 == 1) begin
			N0[0] <= 1;
			N0[1] <= 0;
			N0[2] <= 0;
			N0[3] <= 1;
			N0[4] <= 1;
			N0[5] <= 1;
			N0[6] <= 1;
		end
		else if (score2 == 2) begin
			N0[0] <= 0;
			N0[1] <= 0;
			N0[2] <= 1;
			N0[3] <= 0;
			N0[4] <= 0;
			N0[5] <= 1;
			N0[6] <= 0;
		end
		else if (score2 == 3) begin
			N0[0] <= 0;
			N0[1] <= 0;
			N0[2] <= 0;
			N0[3] <= 0;
			N0[4] <= 1;
			N0[5] <= 1;
			N0[6] <= 0;
		end
		else if (score2 == 4) begin
			N0[0] <= 1;
			N0[1] <= 0;
			N0[2] <= 0;
			N0[3] <= 1;
			N0[4] <= 1;
			N0[5] <= 0;
			N0[6] <= 0;
		end
		else if (blink == 1 && score2 == 5) begin
			N0[0] <= 0;
			N0[1] <= 1;
			N0[2] <= 0;
			N0[3] <= 0;
			N0[4] <= 1;
			N0[5] <= 0;
			N0[6] <= 0;
		end
		else begin
			N0[0] <= 1;
			N0[1] <= 1;
			N0[2] <= 1;
			N0[3] <= 1;
			N0[4] <= 1;
			N0[5] <= 1;
			N0[6] <= 1;
		end
		
	end
	
endmodule
