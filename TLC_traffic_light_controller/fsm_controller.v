`timescale 1ns / 1ps
// Finite State Machine (FSM) for traffic light control
// - Inputs:
//    `s_a`, `s_b` : sensor requests for directions A and B
//    `clk`, `res_n`: clock and active-low reset
//    `timer_done`  : pulse indicating the timer reached the configured duration
// - Outputs (registered): `Ga`, `Ya`, `Ra` and `Gb`, `Yb`, `Rb` for traffic lights
// - `t_max` provides the timer value to set the timer module for each state

module fsm_controller(
        input s_a , s_b , clk , res_n , timer_done ,
        output reg Ga , Gb ,Ya , Yb , Ra , Rb ,
        output reg[5:0]t_max
    );
    // State encodings for the FSM (3-bit encoding)
    parameter s0 = 3'b000 , s1 = 3'b001 , s2 = 3'b010 , s3 = 3'b011, s4 =3'b100 , s5 =3'b101  ;
    reg [2:0]s_next , s_reg ;
    
    // Sequential logic: state register (updates on rising clock, asynchronous reset)
    always @(posedge clk , negedge res_n) 
        begin 
           if(res_n) s_reg <= s_next ;   // when reset is released, capture next state
           else s_reg <= s0 ;            // on reset assert, go to initial state s0
        end

    // Combinational next-state logic
    // Determines s_next based on current state and inputs (s_a, s_b, timer_done)
    always @(*)
     begin 
        s_next = s_reg ;
        case(s_reg)
         // s0: default A-green (or idle) state; wait for B request and timer
         s0 : if (~s_b) s_next = s0 ;
              else if (s_b && timer_done) s_next = s1 ;

         // s1: A-yellow / B-red short interval, advance on timer
         s1 : if (timer_done) s_next = s2 ;
              else s_next = s1 ;

         // s2: A-red / B-green, advance on timer
         s2 : if (timer_done) s_next = s3 ;
              else s_next = s2 ;

         // s3: short A-red / B-green phase; decide next state based on sensors
         s3 : if (~s_a && s_b) s_next = s4 ;
              else if (s_a || s_b) s_next = s5 ;

         // s4: extended B-green while B still requests and A not requesting
         s4 : if (!timer_done && !s_a && s_b) s_next = s4 ;
              else if (timer_done && (s_a || !s_b)) s_next = s5 ;

         // s5: B-yellow / A-red short interval, then return to s0 on timer
         s5 : if (timer_done) s_next = s0 ; 
         default : s_next = s0 ;
        endcase
     end

     // Output (Moore-style): drive lights and set timer duration based on current state
     always @(*) begin 
       // Default outputs: all lights off and zero timer
       Ga = 1'b0 ; Gb= 1'b0 ; Ya= 1'b0 ; Yb= 1'b0 ; Ra= 1'b0 ; Rb= 1'b0 ; t_max = 0; 
       case (s_reg)
        // s0: A green, B red -- long A green period
        s0 : begin {Ga , Rb} = 2'b11 ;
             t_max = 60 ;
            end

        // s1: A yellow, B red -- short yellow
        s1 : begin {Ya , Rb} = 2'b11 ;
             t_max = 5 ;
            end

        // s2: A red, B green -- long B green period
        s2 : begin {Ra , Gb} = 2'b11 ;
             t_max = 59 ;
            end

        // s3: A red, B green -- very short period (handover)
        s3 : begin {Ra , Gb} = 2'b11 ;
              t_max = 1  ;
             end

        // s4: A red, B green (extended) while B keeps requesting
        s4 : begin {Ra , Gb} = 2'b11 ;
              t_max = 10 ;
             end

        // s5: A red, B yellow -- short yellow before returning to s0
        s5 : begin {Ra , Yb} = 2'b11 ;
             t_max = 5 ;
             end
       endcase
     end
endmodule
