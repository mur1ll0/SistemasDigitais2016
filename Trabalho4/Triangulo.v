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

module Triangulo(
    input CLOCK_50,
    input [10:0] p1x,
    input [10:0] p1y,
    input [10:0] p2x,
    input [10:0] p2y,
    input [10:0] p3x,
    input [10:0] p3y,
    input [10:0] Px,
    input [10:0] Py,
    output saida);


//wire saida;
wire s1, s2, s3, t1;


reg result;

reg tipoOperacao;

calc S1(p1x, p1y, p2x, p2y, p3x, p3y, t1);
calc S2(p1x, p1y, p2x, p2y, Px, Py, s1);
calc S3(p2x, p2y, p3x, p3y, Px, Py, s2);
calc S4(p3x, p3y, p1x, p1y, Px, Py, s3);

assign saida = result;


always @(posedge CLOCK_50) begin
	if (t1 == 0 && s1 == 0 && s2 == 0 && s3 == 0) begin
            result <= 1;
        end
        else if (t1 == 1 && s1 == 1 && s2 == 1 && s3 == 1) begin
            result <= 1;
        end
        else begin
            result <= 0;
        end
end

endmodule
