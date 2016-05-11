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
        input [11:0] address,
        input write,
        input data_in,
		output data_out
        );

reg mem [11:0];

assign data_out = write ? 1'bz : mem[address];

always @(write) begin
	if(write == 1)begin
		$display("Address[%d] = %d\n", address, data_in);
		mem[address] <= data_in;
	end
end

endmodule


module trabalho6;

integer triangleList;
integer points;
integer out;
integer scan_triangles;
integer scan_points;

reg [10:0] p1x;
reg [10:0] p1y;
reg [10:0] p2x;
reg [10:0] p2y;
reg [10:0] p3x;
reg [10:0] p3y;
reg [10:0] Px;
reg [10:0] Py;

reg clk = 0;
reg endPoints = 0;
reg wr = 0;
reg readT = 0;
reg readP = 0;
reg rewind = 0;
reg [2:0] count = 0;
reg [11:0] address = 0;
reg [11:0] last;

wire data_in, data_out;

wire s1, s2, s3, t1;

memory M(address, wr, data_in, data_out);

calc S1(p1x, p1y, p2x, p2y, p3x, p3y, t1);
calc S2(p1x, p1y, p2x, p2y, Px, Py, s1);
calc S3(p2x, p2y, p3x, p3y, Px, Py, s2);
calc S4(p3x, p3y, p1x, p1y, Px, Py, s3);

assign data_in = (t1 == s1 && s1 == s2 && s2 == s3);

initial begin
    triangleList = $fopen("TrianglePoints.txt", "r");
    points = $fopen("TestPoints.txt", "r");
	out = $fopen("VerilogOut.txt", "w");

    if (triangleList == 0 || points == 0 || out == 0) begin
        $display("Falha ao abrir arquivo");
        $finish;
    end
end


always #1 clk = ~clk;

always @(posedge clk) begin
	
	if (endPoints == 1) begin
		address <= 0;
		count <= 6;
	end
	else count <= count + 1;

	case(count)
		1: begin
			readP <= 1;
			rewind <= 0;
		end
		2: begin
			readP <= 0;
			readT <= 1;
		end
		3: begin
			readT <= 0;
			if (rewind == 1) begin
				scan_triangles = $rewind(triangleList);
				count <= 1;
			end
			else begin
				wr <= 1;
			end
		end
		4: begin
			wr <= 0;
			
		end
		5: begin
			address <= address + 1;
			count <= 2;
		end
		6: begin
			if(address != last) begin
				$fwrite(out, "%d\n", data_out);
				$display("READ Address[%d] = %d\n", address, data_out);
				address <= address + 1;
			end
			else if(address == last) $finish;
		end
	endcase
end


always @(posedge readP) begin
	if(readP == 1)begin
		if (!$feof(points)) scan_points = $fscanf(points, "%d %d\n", Px, Py);
		else begin
			endPoints <= 1;
			last <= address;
		end
	end
end

always @(posedge readT) begin
	if(readT == 1)begin
		if (!$feof(triangleList)) scan_triangles = $fscanf(triangleList, "%d %d %d %d %d %d\n", p1x, p1y, p2x, p2y, p3x, p3y);
		else rewind <= 1;
	end
end

endmodule
