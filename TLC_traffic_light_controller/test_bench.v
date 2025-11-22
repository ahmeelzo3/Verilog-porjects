`timescale 1ns / 1ps
// Testbench for the traffic light controller
// - Generates clock and reset
// - Drives sensor inputs `s_a` and `s_b`
// - Instantiates DUT `trafic_light_controller` and applies a simple stimulus

`timescale 1ns / 1ps

module tb_tlc;

    // Clock and active-low reset
    reg clk;
    reg res_n;
    // Sensor inputs for two directions (A and B)
    reg s_a, s_b;

    // Timer value from DUT (6-bit) and traffic-light outputs
    wire [5:0] t;
    wire Ga, Ra, Ya, Gb, Yb, Rb;

    // Device under test (DUT) -- top-level traffic light controller
    trafic_light_controller uut (
        .clk(clk), 
        .res_n(res_n), 
        .s_a(s_a), 
        .s_b(s_b), 
        .t(t), 
        .Ga(Ga), .Ra(Ra), .Ya(Ya), 
        .Gb(Gb), .Yb(Yb), .Rb(Rb)
    );

    // Clock generation: 1 ns period (0.5 ns half-period)
    initial begin
        clk = 0;
        forever #0.5 clk = ~clk;
    end
    
    // Stimulus sequence
    initial begin
        // Apply reset (active-low) briefly, then release
        res_n = 1'b0;
        #1 res_n = 1'b1;

        // Start with no sensor requests
        s_a = 1'b0; 
        s_b = 1'b0;

        // Wait some time, then assert sensor B to request service
        #50;
        s_b = 1'b1;
        #10; // allow FSM to progress toward s1

        #5;  // small delay (example timing toward s2)
        #60; // wait for subsequent state transitions
        #5;
        // Clear sensor B request
        s_b = 1'b0;
        #5;  // additional transitions (s3 -> s5, etc.)
        #50;

        // End simulation
        $stop;
    end
endmodule




