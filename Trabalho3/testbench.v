module test;

integer triangleList;
integer points;
integer scan_triangles;
integer scan_points;

reg clk = 0;

reg [10:0] p1x;
reg [10:0] p1y;
reg [10:0] p2x;
reg [10:0] p2y;
reg [10:0] p3x;
reg [10:0] p3y;
reg [10:0] Px;
reg [10:0] Py;

wire saida;
wire s1, s2, s3, t1;

reg result;

reg tipoOperacao;

assign saida = result;

calc S1(p1x, p1y, p2x, p2y, p3x, p3y, t1);
calc S2(p1x, p1y, p2x, p2y, Px, Py, s1);
calc S3(p2x, p2y, p3x, p3y, Px, Py, s2);
calc S4(p3x, p3y, p1x, p1y, Px, Py, s3);

initial begin
    triangleList = $fopen("TriangleList.txt", "r");
    points = $fopen("Points.txt", "r");

    if (triangleList == 0 || points == 0) begin
        $display("Falha ao abrir arquivo");
        $finish;
    end
end

always #2 clk = ~clk;

always #2 begin
    if ((!$feof(triangleList)) && (!$feof(points))) begin
        scan_triangles = $fscanf(triangleList, "%d %d %d %d %d %d", p1x, p1y, p2x, p2y, p3x, p3y);
        scan_points = $fscanf(points, "%d %d", Px, Py);


        if (t1 == 0 && s1 == 0 && s2 == 0 && s3 == 0) begin
            result <= 1;
        end
        else if (t1 == 1 && s1 == 1 && s2 == 1 && s3 == 1) begin
            result <= 1;
        end
        else begin
            result <= 0;
        end


        $display("%d\n", saida);
    end
    else begin
        $finish;
    end
end

endmodule
