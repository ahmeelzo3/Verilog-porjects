module asynch_fifo #(parameter ADDR_WIDTH = 4 , DATA_WIDTH = 8 )(
    input wr_clk , rd_clk ,
    input wr_en , rd_en ,
    input wr_rst_n , rd_rst_n ,
    input [DATA_WIDTH-1:0]wr_data ,
    output full , empty ,
    output[DATA_WIDTH-1:0] rd_data
  );
  //________________________________________________________________________________________________
  //___________________________________MODULES_INSTANTIATION________________________________________
  //================================================================================================
  //_____[ 1 ]_____________________WRITE_POINTER_AND_FULL_LOGIC_BLOCK_______________________________

  wire [ADDR_WIDTH:0] rd_q2_wr_ptr ;
  wire [ADDR_WIDTH:0] wr_addr_gray ;
  wire [ADDR_WIDTH-1:0] wr_addr_bin;

  wr_ptr_full #(.ADDR_WIDTH(ADDR_WIDTH)) WRITE_BLOCK (
                .wr_clk(wr_clk),
                .wr_rst_n(wr_rst_n),
                .wr_en(wr_en),
                .rd_q2_wr_ptr(rd_q2_wr_ptr),
                .wr_addr_bin(wr_addr_bin),
                .wr_addr_gray(wr_addr_gray),
                .wr_full(full)
              );


  //_____[ 2 ]______________________READ_POINTER_AND_EMPTY_LOGIC_BLOCK______________________________

  wire [ADDR_WIDTH  :0] wr_q2_rd_ptr_gray ;
  wire [ADDR_WIDTH  :0]       rd_ptr_gray ;
  wire [ADDR_WIDTH-1:0]        rd_ptr_bin ;

  rd_ptr_empty  #(.ADDR_WIDTH(ADDR_WIDTH)) READ_BLOCK (
                  .rd_clk(rd_clk),
                  .rd_en(rd_en) ,
                  .rd_rst_n(rd_rst_n),
                  .wr_q2_rd_ptr_gray(wr_q2_rd_ptr_gray),
                  .rd_ptr_gray(rd_ptr_gray),
                  .rd_ptr_bin(rd_ptr_bin),
                  .empty(empty)
                );

  //_____[ 3 ]______________________________FIFO_MEMORY_BLOCK_______________________________________

  bram_simple_dual_port #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) FIFO_MEMORY_BLOCK (
                          .rd_clk(rd_clk),
                          .rd_en(rd_en && !empty),
                          .wr_clk(wr_clk),
                          .wr_en(wr_en && !full),
                          .add_rd(rd_ptr_bin),
                          .add_wr(wr_addr_bin),
                          .data_wr(wr_data),
                          .data_rd(rd_data)
                        );

  //_____[ 4 ]__________________________WRITE_SYNCHRONISER_BLOCK____________________________________

  synchronizer  #(.WIDTH(ADDR_WIDTH)) WRITE_SYNCHRONISER_BLOCK (
                  .clk(rd_clk),
                  .reset_n(rd_rst_n),
                  .data_in(wr_addr_gray),
                  .data_out(wr_q2_rd_ptr_gray)
                );

  //_____[ 5 ]___________________________READ_SYNCHRONISER_BLOCK____________________________________

  synchronizer  #(.WIDTH(ADDR_WIDTH)) READ_SYNCHRONISER_BLOCK (
                  .clk(wr_clk),
                  .reset_n(wr_rst_n),
                  .data_in(rd_ptr_gray),
                  .data_out(rd_q2_wr_ptr)
                );


endmodule
