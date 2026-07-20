`timescale 1ns / 1ps

module wr_ptr_full #(parameter ADDR_WIDTH = 4)(
    input wr_clk ,
    input wr_en ,
    input wr_rst_n ,
    input [ADDR_WIDTH:0]rd_q2_wr_ptr,
    output [ADDR_WIDTH-1:0]wr_addr_bin ,
    output reg [ADDR_WIDTH:0]wr_addr_gray ,
    output reg wr_full
  );
  reg [ADDR_WIDTH:0] q_wr_addr_bin ;
  reg [ADDR_WIDTH:0] q_wr_addr_bin_next , q_wr_addr_gray_next ;
  wire counter_en ;

  //////////////////////////////////////////////////////////////////////////////
  //////////////////////////////// COUNTER /////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////
  // COUNTER_COMBINATIONAL_LOGIC //
  assign counter_en = wr_en && !wr_full ;
  assign  wr_addr_bin = q_wr_addr_bin[ADDR_WIDTH-1:0];
  always @(*)
  begin
    
      q_wr_addr_bin_next = q_wr_addr_bin + counter_en ;
    
  end

  //COUNTER_SEQUITIAL_LOGIC
  always @(posedge wr_clk or negedge wr_rst_n)
  begin
    if(!wr_rst_n)
    begin
      q_wr_addr_bin <= 0 ;
    end
    else
    begin
      q_wr_addr_bin <= q_wr_addr_bin_next ;
    end
  end

  /////////////////////////////////////////////////////////////////////////////////
  ///////////////////////// BINARYTOGRAY //////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////

  // SEQUINTAIL _
  always @(posedge wr_clk or negedge wr_rst_n)
  begin
    if(!wr_rst_n)
    begin
      wr_addr_gray <= 0 ;
    end
    else
    begin
      wr_addr_gray <= q_wr_addr_gray_next ;
    end
  end
  // COMBINATIONAL _
  always @(*)
  begin
    q_wr_addr_gray_next = q_wr_addr_bin_next ^ (q_wr_addr_bin_next>>1);
  end


  /////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////// FULL ////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////

  always @(posedge wr_clk or negedge wr_rst_n)
  begin
    if(!wr_rst_n)
    begin
      wr_full <= 0 ;
    end
    else
    begin
      wr_full <= (q_wr_addr_gray_next == {~rd_q2_wr_ptr[ADDR_WIDTH:ADDR_WIDTH-1],rd_q2_wr_ptr[ADDR_WIDTH-2:0]});
    end
  end
endmodule
