module arbiter(
    input CLOCK_50,
    input  [17:0] w_addr,
    input  [15:0] w_data,
    input  [17:0] r_addr,
    output [15:0] r_data,

    output [17:0] SRAM_ADDR,
    inout [15:0] SRAM_DQ,
    output SRAM_WE_N,
    output SRAM_OE_N,
    output SRAM_UB_N,
    output SRAM_LB_N,
    output SRAM_CE_N 

);

reg state = 0;
assign SRAM_WE_N = state;
assign SRAM_OE_N = 0;
assign SRAM_UB_N = 0;
assign SRAM_LB_N = 0;
assign SRAM_CE_N = 0;
assign r_data = reg_r_data;/////////////////////////////////////////////

reg [15:0] reg_r_data;

reg [17:0] reg_addr;
reg [15:0] reg_dq;

assign SRAM_ADDR = reg_addr;

assign SRAM_DQ = reg_dq;


always @(posedge CLOCK_50) 
begin

    case (state)
        0: begin
            reg_addr <= r_addr;
            reg_dq <= 16'hzzzz;
            state <= 1;
        end
        1: begin
            reg_r_data <= SRAM_DQ;
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


module Trabalho8(
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

reg [4:0] state = 2;

/////////////////////////
//Pontos Triangulo
reg [10:0] Px;
reg [10:0] Py;
reg [9:0] p1x;
reg [9:0] p1y;
reg [9:0] p2x;
reg [9:0] p2y;
reg [9:0] p3x;
reg [9:0] p3y;
wire t1, s1, s2, s3;

/////////////////////////

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

assign SRAM_ADDR = (we == 1)? Raddr:Waddr;

wire [17:0] addr;
//assign addr = SRAM_ADDR;

wire [15:0] data;
assign data = SRAM_DQ;

//Write Enable Negative / Output Enable Negative
wire lb, ub, ce, we, oe;
assign SRAM_WE_N = we;
assign SRAM_OE_N = oe;
assign SRAM_CE_N = ce;
assign SRAM_UB_N = ub;
assign SRAM_LB_N = lb;

//Data
//assign Rdata [3:0] = RRed;
//assign Rdata [7:4] = RGreen;
//assign Rdata [11:8] = RBlue;

assign Wdata [3:0] = WRed;
assign Wdata [7:4] = WGreen;
assign Wdata [11:8] = WBlue;

//Entrada de dados de 6 bits, RGB
assign SRAM_DQ[1:0] = WRed;
assign SRAM_DQ[3:2] = WGreen;
assign SRAM_DQ[5:4] = WBlue;

assign SRAM_DQ[9:8] = RRed;
assign SRAM_DQ[11:10] = RGreen;
assign SRAM_DQ[13:12] = RBlue;

//LEDS
assign LEDR[3:0] = SRAM_DQ[11:8];
assign LEDG[7:0] = SRAM_DQ[7:0];
//////////////////////////////////////////

//PROGRAMAÇÂO VGA
assign VGA_R = (we == 1) ? RRed:4'b0000;
assign VGA_G = (we == 1) ? RGreen:4'b0000;
assign VGA_B = (we == 1) ? RBlue:4'b0000;

integer h_count, v_count;

reg CLK_25;
reg clock_state;

assign VGA_HS = (h_count >= 660 && h_count <= 756) ? 0:1;
assign VGA_VS = (v_count >= 494 && v_count <= 495) ? 0:1;
//////////////////////////////////////////

calc S1(p1x, p1y, p2x, p2y, p3x, p3y, t1);
calc S2(p1x, p1y, p2x, p2y, Px, Py, s1);
calc S3(p2x, p2y, p3x, p3y, Px, Py, s2);
calc S4(p3x, p3y, p1x, p1y, Px, Py, s3);

arbiter A(Waddr, Wdata, Raddr, Rdata, addr, data, we, oe, ub, lb, ce);


//////////////////////////////////////////
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
	if (h_count < 799) begin
		h_count <= h_count + 1;
	end
	else begin
		h_count <= 0;
		if (v_count < 524) begin
			v_count <= v_count + 1;
		end
		else begin
			v_count <= 0;
		end
	end
end

/////////////////////////////////////////////////
//Clock Circuito
always @(posedge CLOCK_50) begin
	Px <= h_count;
	Py <= v_count;
	p1x <= 80;
	p1y <= 470;
	p2x <= 80;
	p2y <= 352;
	p3x <= 242;
	p3y <= 352;
	
	case(state)
	0: begin
		Waddr <= Waddr + 1;
		if (h_count < 640 && v_count < 480) begin
			if ((t1 == s1) && (s1 == s2) && (s2 == s3)) begin
				WRed <= 2'b11;
				WGreen <= 2'b00;
				WBlue <= 2'b00;
			end
			else begin
				WRed <= 2'b11;
				WGreen <= 2'b11;
				WBlue <= 2'b11;
			end
		end
		else begin
			WRed <= 2'b00;
			WGreen <= 2'b00;
			WBlue <= 2'b00;
		end
		state <= 1;
	end
	1: begin
		Raddr <= Raddr + 1;
		state <= 0;
	end
	endcase
	
end

endmodule
