*/
A entrada é um arquivo contendo as coordenadas dos pontos de teste.
Contém 5 triangulos salvos na memório ROM.
Para cada ponto de teste, todos os triângulos são testados.
A saída é gravada em um arquivo mostrando 1 se o ponto testado esta dentro do triângulo e 0 se não estiver.
*/

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


module memory(
        input [2:0] address,
        input read,
		output [10:0] p1x,
        output [10:0] p1y,
		output [10:0] p2x,
        output [10:0] p2y,
		output [10:0] p3x,
        output [10:0] p3y
        );

reg [10:0] mem [5:0];

assign p1x = mem[0];
assign p1y = mem[1];
assign p2x = mem[2];
assign p2y = mem[3];
assign p3x = mem[4];
assign p3y = mem[5];

always @(read) begin
	if(read == 1)begin
		case(address)
		0: begin
            mem[0] <= 82;
            mem[1] <= 104;
            mem[2] <= 171;
            mem[3] <= 322;
            mem[4] <= 321;
            mem[5] <= 69;
		end
		1: begin
            mem[0] <= 80;
            mem[1] <= 470;
            mem[2] <= 80;
            mem[3] <= 352;
            mem[4] <= 242;
            mem[5] <= 352;
		end
		2: begin
            mem[0] <= 301;
            mem[1] <= 458;
            mem[2] <= 480;
            mem[3] <= 458;
            mem[4] <= 389;
            mem[5] <= 344;
		end
		3: begin
            mem[0] <= 290;
            mem[1] <= 259;
            mem[2] <= 413;
            mem[3] <= 289;
            mem[4] <= 364;
            mem[5] <= 166;
		end
		4: begin
            mem[0] <= 612;
            mem[1] <= 227;
            mem[2] <= 493;
            mem[3] <= 241;
            mem[4] <= 442;
            mem[5] <= 76;
		end
        endcase
	end
end

endmodule


module trabalho6;

integer points;
integer out;
integer scan_points;

reg clk = 0;
reg endPoints = 0;
reg read = 0;
reg readP = 0;
reg [2:0] count = 0;
reg [2:0] address = 0;

reg [10:0] p1x;
reg [10:0] p1y;
reg [10:0] p2x;
reg [10:0] p2y;
reg [10:0] p3x;
reg [10:0] p3y;
reg [10:0] Px;
reg [10:0] Py;

wire [10:0] Wp1x;
wire [10:0] Wp1y;
wire [10:0] Wp2x;
wire [10:0] Wp2y;
wire [10:0] Wp3x;
wire [10:0] Wp3y;


memory ROM(address, read, Wp1x, Wp1y, Wp2x, Wp2y, Wp3x, Wp3y);

wire s1, s2, s3, t1, result;

calc S1(p1x, p1y, p2x, p2y, p3x, p3y, t1);
calc S2(p1x, p1y, p2x, p2y, Px, Py, s1);
calc S3(p2x, p2y, p3x, p3y, Px, Py, s2);
calc S4(p3x, p3y, p1x, p1y, Px, Py, s3);

assign result = (t1 == s1 && s1 == s2 && s2 == s3);

initial begin
    points = $fopen("TestPoints.txt", "r");
	out = $fopen("VerilogOut.txt", "w");

    if (points == 0 || out == 0) begin
        $display("Falha ao abrir arquivo");
        $finish;
    end
end


always #1 clk = ~clk;


always @(posedge clk) begin

	if (endPoints == 1) begin
		$finish;
	end
	else count <= count + 1;

	case(count)
		1: begin
			readP <= 1;
		end
		2: begin
			readP <= 0;
			read <= 1;
		end
		3: begin
			read <= 0;
			p1x <= Wp1x;
			p1y <= Wp1y;
			p2x <= Wp2x;
			p2y <= Wp2y;
			p3x <= Wp3x;
			p3y <= Wp3y;
		end
		4: begin
			$display("Resultado = %d\n", result);
			$fwrite(out, "%d\n", result);
			address <= address + 1;
		end
		5: begin
			if(address == 5) begin
				address <= 0;
				count <= 1;
			end
			else count <= 2;
		end
	endcase
end


always @(posedge readP) begin
	if(readP == 1)begin
		if (!$feof(points)) scan_points = $fscanf(points, "%d %d\n", Px, Py);
		else begin
			endPoints <= 1;
		end
	end
end

endmodule
