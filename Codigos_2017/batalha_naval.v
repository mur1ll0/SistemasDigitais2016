/*NAO É NECESSARIO ESSES MODULOS DE JOGADAS DO JOGADOR 1 E 2, POIS AS JOGADAS SÃO FEITAS COM O SWITCH DA FPGA
  module priplayer (
  input clk,
  output [2:0]ply1);

  reg [2:0]jogada;
  reg [2:0]j1 = 0 ;	///Adicionei [2:0], pois j1 sera um contador de 0 até 6

  assign ply1[2:0] = jogada[2:0];	//Modifiquei essa linha, não sei se funciona, nao lembro direito

  always @ (posedge clk ) begin
    j1 <= j1 + 1;
	///Se nao funcionar, descomentar as linhas abaixo e apagar as linhas "jogada[3:0]<=...".
    if(j1==1)begin
        //jogada[0] = 0;
        //jogada[1] = 0;
        //jogada[2] = 1;
		jogada[3:0] <= 3'b100;
    end else if(j1==2)begin
        //jogada[0] = 0;
        //jogada[1] = 1;
        //jogada[2] = 0;
		jogada[3:0] <= 3'b010;
    end else if(j1==3)begin
        //jogada[0] = 0;
        //jogada[1] = 1;
        //jogada[2] = 1;
		jogada[3:0] <= 3'b011;
    end else if(j1==4)begin
        //jogada[0] = 1;
        //jogada[1] = 0;
        //jogada[2] = 0;
		jogada[3:0] <= 3'b100;
    end else if(j1==5)begin
        //jogada[0] = 1;
        //jogada[1] = 0;
        //jogada[2] = 1;
		jogada[3:0] <= 3'b101;
    end else if(j1==6)begin
        //jogada[0] = 1;
        //jogada[1] = 1;
        //jogada[2] = 0;
		jogada[3:0] <= 3'b110;
        j1<=0;
    end
  end

endmodule

module segplayer (
    input clk,
    output [2:0]ply2);

    reg [2:0]jogada;
	reg [2:0]j2 = 0 ;	///Adicionei [2:0], pois j2 sera um contador de 0 até 6

    assign ply2[2:0] = jogada[2:0];	//Modifiquei essa linha, não sei se funciona, nao lembro direito

    always @ ( clk ) begin
      j2 <= j2 + 1;
	  ///Se nao funcionar, descomentar as linhas abaixo e apagar as linhas "jogada[3:0]<=...".
      if(j2==3) begin
          //jogada[0] = 0;
          //jogada[1] = 0;
          //jogada[2] = 1;
		  jogada[3:0] <= 3'b001;
      end else if(j2==2) begin
          //jogada[0] = 0;
          //jogada[1] = 1;
          //jogada[2] = 0;
		  jogada[3:0] <= 3'b010;
      end else if(j2==1) begin
          //jogada[0] = 0;
          //jogada[1] = 1;
          //jogada[2] = 1;
		  jogada[3:0] <= 3'b011;
      end else if(j2==4) begin
          //jogada[0] = 1;
          //jogada[1] = 0;
          //jogada[2] = 0;
		  jogada[3:0] <= 3'b100;
      end else if(j2==6) begin
          //jogada[0] = 1;
          //jogada[1] = 0;
          //jogada[2] = 1;
		  jogada[3:0] <= 3'b101;
      end else if(j2==5) begin
          //jogada[0] = 1;
          //jogada[1] = 1;
          //jogada[2] = 0;
		  jogada[3:0] <= 3'b110;
          j2<=0;
      end
    end

endmodule
*/

module batalha (
  input CLOCK_50,
  input [9:0] SW,
  output [7:0]LEDG);
  
  //##########################
  //#        CONTROLES       #
  //##########################
  //SW[0,1,2] - Jogador 1
  //SW[7,8,9] - Jogador 2
  
  reg win = 0;

  assign LEDG[0] = win;	//Led 0 acende se jogador acertar
  
  /*NAO E MAIS NECESSARIO
  wire [2:0]pl1;	//Fio deve ser [2:0]
  wire [2:0]pl2;	//Fio deve ser [2:0]
  
  priplayer jog1(CLOCK_50, ply1);
  segplayer jog2(CLOCK_50, ply2);

  assign pl1[2:0] <= ply1[2:0];	//Assign deve usar "=" e nao "<=", linha modificada
  assign pl2[2:0] <= ply2[2:0];	//Assign deve usar "=" e nao "<=", linha modificada
  */
  

  //Logica
  always @(posedge CLOCK_50) begin
	if(ply1==ply2) begin
		win <= 1;
	end
	else begin
		win <= 0;
	end
  end
  
  //OU A LOGICA PODERIA SER BEM MAIS SIMPLES:
	//assign LEDG[0] = (SW[2:0] == SW[9:7]) ? 1:0;   //Nao lembro se os leds são negados, se for é só inverter "1:0" pra "0:1"
  
  
  /* COLOQUE A LOGICA DENTRO DE ALWAYS SEMPRE, ESSA PARTE DO SEU CODIGO NUNCA IRIA FUNCIONAR (AFINAL NAO EXISTE UM GATILHO "@"):
  if(pl1 == pl2) begin
    ww = 1;
  end else begin
    ww = 0;
  end
  */

endmodule

/*MODULO PARA TESTAR NO GTKWAVE (SOMENTE ESSA PARTE DO CODIGO, SEM A DE CIMA, QUE É O MODULO DA FPGA)
module test;
    reg clk;
    reg [2:0]jog1;
    reg [2:0]jog2;
    wire saida;

    always #2 begin
        clk <= ~clk;
    end

    assign saida = (jog1==jog2)? 1:0;

    initial begin
      $dumpvars(0, clk, jog1, jog2, saida);
      #2;
      clk <= 0;
      #2;
	  jog1 <= 4;
	  jog2 <= 0;
	  #10;
	  jog2 <= 1;
	  #10;
	  jog2 <= 4;
	  #10;
	  jog2 <= 5;
      #10;
      $finish;
    end

endmodule
*/
