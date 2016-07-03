module arbiter(
    input CLOCK_50,
    input  [17:0] w_addr,
    input  [15:0] w_data,
    input  [17:0] r_addr,
    output [15:0] r_data,

    output [17:0] addr,
    inout [15:0] data,
    output we,
    output oe,
    output ub,
    output lb,
    output ce 
);

reg state = 0;
assign we = state;
assign oe = 0;
assign ub = 0;
assign lb = 0;
assign ce = 0;
assign r_data = reg_r_data;

reg [15:0] reg_r_data;

reg [17:0] reg_addr;
reg [15:0] reg_dq;

assign addr = reg_addr;

assign data = reg_dq;


always @(posedge CLOCK_50) 
begin

    case (state)
        0: begin
            reg_addr <= r_addr;
            reg_dq <= 16'hzzzz;
            state <= 1;
        end
        1: begin
            reg_r_data <= data;
            reg_addr <= w_addr;
            reg_dq <= w_data;
            state <= 0;
        end
    endcase
end

endmodule


module calc(
    input [9:0] p1x,
    input [9:0] p1y,
    input [9:0] p2x,
    input [9:0] p2y,
    input [9:0] p3x,
    input [9:0] p3y,
    output result
);

//result = (((p1.x - p3.x)*(p2.y - p3.y)) - ((p2.x - p3.x)*(p1.y - p3.y)));

wire signed [11:0] s1;
wire signed [11:0] s2;
wire signed [11:0] s3;
wire signed [11:0] s4;
wire signed [23:0] m1;
wire signed [23:0] m2;

assign s1 = p1x - p3x;
assign s2 = p2y - p3y;
assign s3 = p2x - p3x;
assign s4 = p1y - p3y;
assign m1 = s1 * s2;
assign m2 = s3 * s4;
assign result = m1 > m2;

endmodule


module Trabalho8_320_240(
			input CLOCK_50,
			input [3:0] KEY,
			input [9:0] SW,
			output [3:0] VGA_R,
			output [3:0] VGA_G,
			output [3:0] VGA_B,
			output VGA_HS,
			output VGA_VS,
			output [7:0] LEDG,
			output [9:0] LEDR,
			output [17:0] SRAM_ADDR,
			inout [15:0] SRAM_DQ,
			output SRAM_WE_N,
			output SRAM_OE_N,
			output SRAM_UB_N,
			output SRAM_LB_N,
			output SRAM_CE_N
			);

/////////////////////////////////////
//Pontos Triangulo
reg [9:0] Px;
reg [9:0] Py;
reg [9:0] p1x_1;
reg [9:0] p1y_1;
reg [9:0] p2x_1;
reg [9:0] p2y_1;
reg [9:0] p3x_1;
reg [9:0] p3y_1;

reg [9:0] p1x_2;
reg [9:0] p1y_2;
reg [9:0] p2x_2;
reg [9:0] p2y_2;
reg [9:0] p3x_2;
reg [9:0] p3y_2;

reg [9:0] p1x_3;
reg [9:0] p1y_3;
reg [9:0] p2x_3;
reg [9:0] p2y_3;
reg [9:0] p3x_3;
reg [9:0] p3y_3;

reg [9:0] p1x_4;
reg [9:0] p1y_4;
reg [9:0] p2x_4;
reg [9:0] p2y_4;
reg [9:0] p3x_4;
reg [9:0] p3y_4;

reg [9:0] p1x_5;
reg [9:0] p1y_5;
reg [9:0] p2x_5;
reg [9:0] p2y_5;
reg [9:0] p3x_5;
reg [9:0] p3y_5;

wire t1_1, s1_1, s2_1, s3_1;
wire t1_2, s1_2, s2_2, s3_2;
wire t1_3, s1_3, s2_3, s3_3;
wire t1_4, s1_4, s2_4, s3_4;
wire t1_5, s1_5, s2_5, s3_5;

/////////////////////////////////////

//PROGRAMACAO MEMORIA SRAM
reg [17:0] Waddr;
reg [17:0] Raddr;

wire [15:0] Rdata;
wire [15:0] Wdata;

reg [3:0] WRed;
reg [3:0] WGreen;
reg [3:0] WBlue;

reg [3:0] RRed;
reg [3:0] RGreen;
reg [3:0] RBlue;

assign Wdata [3:0] = WRed;
assign Wdata [7:4] = WGreen;
assign Wdata [11:8] = WBlue;

arbiter A(CLOCK_50, Waddr, Wdata, Raddr, Rdata, SRAM_ADDR, SRAM_DQ, SRAM_WE_N, SRAM_OE_N, SRAM_UB_N, SRAM_LB_N, SRAM_CE_N);

reg control;

//LEDS
assign LEDR[3:0] = SRAM_DQ[11:8];
assign LEDG[7:0] = SRAM_DQ[7:0];
assign LEDR[9] = control;
/////////////////////////////////////////////////////////////////////

//PROGRAMAÇÂO VGA

assign VGA_R = (h_count < 320 && v_count < 240) ? RRed : 4'b0000;
assign VGA_G = (h_count < 320 && v_count < 240) ? RGreen : 4'b0000;
assign VGA_B = (h_count < 320 && v_count < 240) ? RBlue : 4'b0000;

integer h_count, v_count;

reg CLK_25;
reg clock_state;

assign VGA_HS = (h_count >= 340 && h_count <= 436) ? 0:1;
assign VGA_VS = (v_count >= 254 && v_count <= 255) ? 0:1;

//Clock da VGA 25MHz
always @(posedge CLOCK_50) begin
	if (clock_state == 0) begin
		CLK_25 = ~CLK_25;
	end
	else begin
		clock_state = ~clock_state;
	end
end

always @(posedge CLK_25) begin
	if (h_count < 479) begin
		h_count <= h_count + 1;
	end
	else begin
		h_count <= 0;
		if (v_count < 284) begin
			v_count <= v_count + 1;
		end
		else begin
			v_count <= 0;
		end
	end
end
//////////////////////////////////////////////////////////////

calc S1_1(p1x_1, p1y_1, p2x_1, p2y_1, p3x_1, p3y_1, t1_1);
calc S2_1(p1x_1, p1y_1, p2x_1, p2y_1, Px, Py, s1_1);
calc S3_1(p2x_1, p2y_1, p3x_1, p3y_1, Px, Py, s2_1);
calc S4_1(p3x_1, p3y_1, p1x_1, p1y_1, Px, Py, s3_1);

calc S1_2(p1x_2, p1y_2, p2x_2, p2y_2, p3x_2, p3y_2, t1_2);
calc S2_2(p1x_2, p1y_2, p2x_2, p2y_2, Px, Py, s1_2);
calc S3_2(p2x_2, p2y_2, p3x_2, p3y_2, Px, Py, s2_2);
calc S4_2(p3x_2, p3y_2, p1x_2, p1y_2, Px, Py, s3_2);

calc S1_3(p1x_3, p1y_3, p2x_3, p2y_3, p3x_3, p3y_3, t1_3);
calc S2_3(p1x_3, p1y_3, p2x_3, p2y_3, Px, Py, s1_3);
calc S3_3(p2x_3, p2y_3, p3x_3, p3y_3, Px, Py, s2_3);
calc S4_3(p3x_3, p3y_3, p1x_3, p1y_3, Px, Py, s3_3);

calc S1_4(p1x_4, p1y_4, p2x_4, p2y_4, p3x_4, p3y_4, t1_4);
calc S2_4(p1x_4, p1y_4, p2x_4, p2y_4, Px, Py, s1_4);
calc S3_4(p2x_4, p2y_4, p3x_4, p3y_4, Px, Py, s2_4);
calc S4_4(p3x_4, p3y_4, p1x_4, p1y_4, Px, Py, s3_4);

calc S1_5(p1x_5, p1y_5, p2x_5, p2y_5, p3x_5, p3y_5, t1_5);
calc S2_5(p1x_5, p1y_5, p2x_5, p2y_5, Px, Py, s1_5);
calc S3_5(p2x_5, p2y_5, p3x_5, p3y_5, Px, Py, s2_5);
calc S4_5(p3x_5, p3y_5, p1x_5, p1y_5, Px, Py, s3_5);

/////////////////////////////////////////////////
//Clock Circuito
always @(posedge CLOCK_50) begin
	Px <= h_count;
	Py <= v_count;
	
	p1x_1 <= 41;
	p1y_1 <= 52;
	p2x_1 <= 85;
	p2y_1 <= 161;
	p3x_1 <= 160;
	p3y_1 <= 34;
	
	p1x_2 <= 40;
	p1y_2 <= 235;
	p2x_2 <= 40;
	p2y_2 <= 176;
	p3x_2 <= 121;
	p3y_2 <= 176;
	
	p1x_3 <= 150;
	p1y_3 <= 229;
	p2x_3 <= 240;
	p2y_3 <= 229;
	p3x_3 <= 194;
	p3y_3 <= 172;
	
	p1x_4 <= 145;
	p1y_4 <= 129;
	p2x_4 <= 206;
	p2y_4 <= 144;
	p3x_4 <= 182;
	p3y_4 <= 83;
	
	p1x_5 <= 306;
	p1y_5 <= 113;
	p2x_5 <= 246;
	p2y_5 <= 120;
	p3x_5 <= 221;
	p3y_5 <= 38;
	
	if (v_count == 0) begin
		Raddr <= 0;
		Waddr <= 0;
	end
	
	if (SW[9] == 1) begin
		control <= 1;
	end
	else begin
		control <= 0;
	end
	
	if (h_count < 320 && v_count < 240) begin
		if (control == 1 && Waddr < 76799 && SRAM_WE_N == 0) begin
			Waddr <= Waddr + 1;
			if ((t1_1 == s1_1) && (s1_1 == s2_1) && (s2_1 == s3_1)) begin
				if (SW[0] == 1) begin
					WRed <= 4'b1111;
					WGreen <= 4'b0000;
					WBlue <= 4'b0000;
				end
				else begin
					WRed <= 4'b1111;
					WGreen <= 4'b1111;
					WBlue <= 4'b1111;
				end
			end
			else if ((t1_2 == s1_2) && (s1_2 == s2_2) && (s2_2 == s3_2)) begin
				if (SW[1] == 1) begin
					WRed <= 4'b0000;
					WGreen <= 4'b1111;
					WBlue <= 4'b0000;
				end
				else begin
					WRed <= 4'b1111;
					WGreen <= 4'b1111;
					WBlue <= 4'b1111;
				end
			end
			else if ((t1_3 == s1_3) && (s1_3 == s2_3) && (s2_3 == s3_3)) begin
				if (SW[2] == 1) begin
					WRed <= 4'b0000;
					WGreen <= 4'b0000;
					WBlue <= 4'b1111;
				end
				else begin
					WRed <= 4'b1111;
					WGreen <= 4'b1111;
					WBlue <= 4'b1111;
				end
			end
			else if ((t1_4 == s1_4) && (s1_4 == s2_4) && (s2_4 == s3_4)) begin
				if (SW[3] == 1) begin
					WRed <= 4'b1111;
					WGreen <= 4'b0000;
					WBlue <= 4'b1111;
				end
				else begin
					WRed <= 4'b1111;
					WGreen <= 4'b1111;
					WBlue <= 4'b1111;
				end
			end
			else if ((t1_5 == s1_5) && (s1_5 == s2_5) && (s2_5 == s3_5)) begin
				if (SW[4] == 1) begin
					WRed <= 4'b1111;
					WGreen <= 4'b1111;
					WBlue <= 4'b0000;
				end
				else begin
					WRed <= 4'b1111;
					WGreen <= 4'b1111;
					WBlue <= 4'b1111;
				end
			end
			else begin
				WRed <= 4'b1111;
				WGreen <= 4'b1111;
				WBlue <= 4'b1111;
			end
		end
		
		else if (SRAM_WE_N == 1)begin
			if (Raddr < 76799) begin
				Raddr <= Raddr + 1;
				RRed <= Rdata [3:0];
				RGreen <= Rdata [7:4];
				RBlue <= Rdata [11:8];
			end
			else begin
				RRed <= 4'b1000;
				RGreen <= 4'b1000;
				RBlue <= 4'b1000;
			end
		end
		
	end
end

endmodule
