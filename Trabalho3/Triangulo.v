module calc(
    input [10:0] p1x,
    input [10:0] p1y,
    input [10:0] p2x,
    input [10:0] p2y,
    input [10:0] p3x,
    input [10:0] p3y,
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

module main(
    input CLOCK_50,
    input [10:0] ax,
    input [10:0] ay,
    input [10:0] bx,
    input [10:0] by,
    input [10:0] cx,
    input [10:0] cy,
    input [10:0] Px,
    input [10:0] Py,
    output saida);


reg [10:0] p1x;
reg [10:0] p1y;
reg [10:0] p2x;
reg [10:0] p2y;
reg [10:0] p3x;
reg [10:0] p3y;

reg ponto1;
reg ponto2;
reg ponto3;

wire saida;
wire s1, s2, s3, t1;


reg result;

reg tipoOperacao;

calc S1(p1x, p1y, p2x, p2y, p3x, p3y, t1);
calc S2(p1x, p1y, p2x, p2y, Px, Py, s1);
calc S3(p1x, p1y, p2x, p2y, Px, Py, s2);
calc S4(p1x, p1y, p2x, p2y, Px, Py, s3);

assign saida = result;


always @(posedge CLOCK_50) begin
	//DEFINIR P1 E P3

        if (ax <= bx && ax <= cx) begin
            p1x <= ax;
            p1y <= ay;
            ponto1 <= 1;
        end
        else if (bx <= ax && bx <= cx) begin
            p1x <= bx;
            p1y <= by;
            ponto1 <= 2;

        end
        else if (cx <= ax && cx <= bx) begin
            p1x <= cx;
            p1y <= cy;
            ponto1 <= 3;
        end

        if (ax >= bx && ax >= cx) begin
            p3x <= ax;
            p3y <= ay;
            ponto3 <= 1;
        end
        else if (bx >= ax && bx >= cx) begin
            p3x <= bx;
            p3y <= by;
            ponto3 <= 2;
        end
        else if (cx >= ax && cx >= bx) begin
            p3x <= cx;
            p3y <= cy;
            ponto3 <= 3;
        end



        //DEFINIR P2
        if (ponto1 == 1 && ponto3 == 2 || ponto1 == 2 && ponto3 == 1) begin
            p2x <= cx;
            p2y <= cy;
        end
        else if (ponto1 == 2 && ponto3 == 3 || ponto1 == 3 && ponto3 == 2) begin
            p2x <= ax;
            p2y <= ay;
        end
        else if (ponto1 == 1 && ponto3 == 3 || ponto1 == 3 && ponto3 == 1) begin
            p2x <= bx;
            p2y <= by;
        end


	//calc S1(p1x, p1y, p2x, p2y, p3x, p3y, t1);
	if (t1 <= 0) begin
		tipoOperacao <= 0;
	end else begin
		tipoOperacao <= 1;
	end


    if (tipoOperacao == 0) begin
        if (s1 > 0 || s2 > 0 || s3 > 0) begin
            result <= 1;
        end else begin
            result <= 0;
        end
    end else begin
        if (s1 < 0 || s2 < 0 || s3 < 0) begin
            result <= 1;
        end else begin
            result <= 0;
        end
    end


end

endmodule
