`timescale 1ns/1ps

module asynch_fifo_tb #(parameter DATA_WIDTH = 8, parameter ADDR_WIDTH = 4)();

  //_________________________________DECLATRE_LOCAL_WIRES_&_REGISTERS______________________________

  //______________INPUTS_____________
  reg wr_clk , rd_clk ;
  reg wr_en , rd_en ;
  reg wr_rst_n , rd_rst_n ;
  reg [DATA_WIDTH-1:0] wr_data ;

  //______________OUTPUTS____________
  wire full , empty ;
  wire [DATA_WIDTH-1:0] rd_data ;


  //_____________________________________INSTANTIATE_THE_DUT_______________________________________

  asynch_fifo #(
                .ADDR_WIDTH(ADDR_WIDTH),
                .DATA_WIDTH(DATA_WIDTH)
              ) DUT (
                .wr_clk(wr_clk) , .wr_en(wr_en) , .wr_rst_n(wr_rst_n) ,
                .rd_clk(rd_clk) , .rd_en(rd_en) , .rd_rst_n(rd_rst_n) ,
                .wr_data(wr_data) ,
                .rd_data(rd_data) ,
                .full(full) ,
                .empty(empty)
              );

  //___________________________________STOP_WATCH_FOR_SIMULATION___________________________________

  initial
  begin
    #1500 ;
    $finish ;
  end

  //__________________________________GENERATE_STIMULI_CONDITIONS__________________________________

  initial
  begin
    wr_clk = 0;
    forever
      #5 wr_clk = ~wr_clk;
  end

  initial
  begin
    rd_clk = 0;
    forever
      #12 rd_clk = ~rd_clk;
  end

  initial
  begin
    wr_en = 0;
    rd_en = 0;
    wr_rst_n = 0;
    rd_rst_n = 0;
    wr_data = 0;

    #30;
    wr_rst_n = 1;
    rd_rst_n = 1;

    #40;

    repeat(16)
    begin
      @(negedge wr_clk);
      wr_en = 1;
      wr_data = $random;
    end
    @(negedge wr_clk);
    wr_en = 0;

    #100;

    repeat(16)
    begin
      @(negedge rd_clk);
      rd_en = 1;
    end
    @(negedge rd_clk);
    rd_en = 0;

    #100;

    fork
      begin
        repeat(10)
        begin
          @(negedge wr_clk);
          wr_en = 1;
          wr_data = $random;
        end
        @(negedge wr_clk);
        wr_en = 0;
      end
      begin
        #25;
        repeat(10)
        begin
          @(negedge rd_clk);
          rd_en = 1;
        end
        @(negedge rd_clk);
        rd_en = 0;
      end
    join
  end

  //____________________________________DISPLAY_OUTPUT_RESPONSE____________________________________

endmodule
