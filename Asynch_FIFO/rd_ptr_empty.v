`timescale 1ns/1ps

module rd_ptr_empty #(parameter ADDR_WIDTH = 4)(
    input rd_clk ,
    input rd_en , rd_rst_n,
    input [ADDR_WIDTH:0] wr_q2_rd_ptr_gray ,
    output [ADDR_WIDTH-1:0] rd_ptr_bin ,
    output  [ADDR_WIDTH:0] rd_ptr_gray ,
    output reg empty
  );
  //______________________________________________________________________________________________
  //_________________________________________COUNTER______________________________________________

  reg [ADDR_WIDTH:0] q_rd_ptr_bin , q_rd_ptr_bin_next ;
  reg [ADDR_WIDTH : 0 ] q_rd_ptr_gray , q_rd_ptr_gray_next ;

  // SEQUINTIAL_LOGIC //
  always @(posedge rd_clk or negedge rd_rst_n)
  begin
    if(!rd_rst_n)
    begin
      q_rd_ptr_bin <= 0 ;
    end
    else
    begin
      q_rd_ptr_bin <= q_rd_ptr_bin_next ;
    end
  end
  // COMBINAITONAL_LOGIC //

  assign  rd_ptr_bin = q_rd_ptr_bin[ADDR_WIDTH-1:0] ;

  always @(*)
  begin
    if (rd_en&& !empty)
    begin
      q_rd_ptr_bin_next = q_rd_ptr_bin + 1 ;

    end
    else
    begin
      q_rd_ptr_bin_next = q_rd_ptr_bin ;
    end
  end
  //______________________________________________________________________________________________
  //_______________________________________EMPTY_LOGIC____________________________________________

  always @(posedge rd_clk or negedge rd_rst_n)
  begin
    if (!rd_rst_n)
    begin
      empty <= 1 ;
    end
    else
    begin
      empty <= (q_rd_ptr_gray_next == wr_q2_rd_ptr_gray);
    end
  end

  //______________________________________________________________________________________________
  //_______________________________BINARY TO GRAY CONVERTER_______________________________________


  //SEQUINTIAL_LOGIC//
  always @(posedge rd_clk or negedge rd_rst_n)
  begin
    if (!rd_rst_n)
    begin
      q_rd_ptr_gray <= 0 ;
    end
    else
    begin
      q_rd_ptr_gray <= q_rd_ptr_gray_next ;
    end
  end

  //COMBINATIONAL_LOGIC//
  assign  rd_ptr_gray = q_rd_ptr_gray ;
  always @(*)
  begin
    q_rd_ptr_gray_next = (q_rd_ptr_bin_next>>1)^q_rd_ptr_bin_next ;
  end
endmodule
