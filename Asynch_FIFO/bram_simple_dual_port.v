`timescale 1ns / 1ps


module bram_simple_dual_port#(parameter ADDR_WIDTH = 10 , DATA_WIDTH = 8 )(
    input wr_clk,rd_clk ,
    input wr_en ,rd_en ,
    input [ADDR_WIDTH-1:0] add_rd , add_wr ,
    input [DATA_WIDTH-1:0]data_wr,
    output reg [DATA_WIDTH-1:0]data_rd

  );

  reg [DATA_WIDTH-1:0] memory[0:2**ADDR_WIDTH-1];
  //Write logic
  always @(posedge wr_clk)
  begin
    if (wr_en)
    begin
      memory[add_wr]<= data_wr ;
    end
  end
  //Read logic
  always @(posedge rd_clk)
  begin
    if (rd_en)
    begin
      data_rd <=  memory[add_rd];
    end
  end
endmodule
