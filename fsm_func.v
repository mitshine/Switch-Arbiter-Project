module fsm_func(core_clock, core_rst,
din1p, req1p, clk1p, dout1p, gnt1p,
din2p, req2p, clk2p, dout2p, gnt2p,
din3p, req3p, clk3p, dout3p, gnt3p,
din4p, req4p, clk4p, dout4p, gnt4p,
din5p, req5p, clk5p, dout5p, gnt5p,
din1n, req1n, clk1n, dout1n, gnt1n,
din2n, req2n, clk2n, dout2n, gnt2n,
din3n, req3n, clk3n, dout3n, gnt3n,
din4n, req4n, clk4n, dout4n, gnt4n);
  
//  enum {0x1 = 3, 0x2 = 4, 0x3 = 5, 0x4 = 6, 0x5 = 7, 0x6 = 8, 0x7 = 9, 0x8 = 10, 0x9 = 11, 0xA = 12, 0xB = 13, 0xC = 14, 0xD = 15, 0xE = 16, 0xF = 17} states;
  
  input core_clock, core_rst;
  
  input din1p, req1p, clk1p;
  output reg dout1p, gnt1p;
  
  input din2p, req2p, clk2p;
  output reg dout2p, gnt2p;
  
  input din3p, req3p, clk3p;
  output reg dout3p, gnt3p;
  
  input din4p, req4p, clk4p;
  output reg dout4p, gnt4p;
  
  input din5p, req5p, clk5p;
  output reg dout5p, gnt5p;
  
  input din1n, req1n, clk1n;
  output reg dout1n, gnt1n;
  
  input din2n, req2n, clk2n;
  output reg dout2n, gnt2n;
  
  input din3n, req3n, clk3n;
  output reg dout3n, gnt3n;
  
  input din4n, req4n, clk4n;
  output reg dout4n, gnt4n;
    
  // assign preamble = 8'b11111110; // 0xFE;
  // assign sourceAddr = 0x0_P;
  // assign destAddr = 0x0_N;
  
  parameter SIZE = 4;
  parameter IDLE  = 4'b0000; //GNT1 = 3'b010,GNT2 = 3'b100 ;
  parameter gnt1p1 = 4'b0001;
  parameter gnt2p2 = 4'b0010;
  parameter gnt3p3 = 4'b0011;
  parameter gnt4p4 = 4'b0100;
  parameter gnt5p5 = 4'b0101;
  parameter gnt1n1 = 4'b0110;
  parameter gnt2n2 = 4'b0111;
  parameter gnt3n3 = 4'b1000;
  parameter gnt4n4 = 4'b1001;
  reg   [SIZE-1:0]          state        ;
  wire  [SIZE-1:0]          next_state   ;
  assign next_state = fsm_function(state, req1p, req2p, req3p, req4p, req5p, req1n, req2n, req3n, req4n);
  
  //----------Function for Combo Logic-----------------
  function [SIZE-1:0] fsm_function;
    input [SIZE-1:0] state;	
    input req1p;
    input req2p;
    input req3p;
    input req4p;
    input req5p;
    input req1n;
    input req2n;
    input req3n;
    input req4n;
    case(state)
    IDLE:
      if (req1p == 1'b1) begin
        fsm_function = gnt1p1;
      end 
      else if (req2p == 1'b1) begin
        fsm_function = gnt2p2;
      end
      else if (req3p == 1'b1) begin
        fsm_function = gnt3p3;
      end
      else if (req4p == 1'b1) begin
        fsm_function = gnt4p4;
      end
      else if (req5p == 1'b1) begin
        fsm_function = gnt5p5;
      end
      else if (req1n == 1'b1) begin
        fsm_function = gnt1n1;
      end
      else if (req2n == 1'b1) begin
        fsm_function = gnt2n2;
      end
      else if (req3n == 1'b1) begin
        fsm_function = gnt3n3;
      end
      else if (req4n == 1'b1) begin
        fsm_function = gnt4n4;
      end
      else begin
        fsm_function = IDLE;
      end
    gnt1p1: 
      if (req1p == 1'b1) begin
        fsm_function = gnt1p1;
      end 
      else begin
        fsm_function = IDLE;
      end
    gnt2p2: 
      if (req2p == 1'b1) begin
        fsm_function = gnt2p2;
      end 
      else begin
        fsm_function = IDLE;
      end
    gnt3p3: 
      if (req3p == 1'b1) begin
        fsm_function = gnt3p3;
      end 
      else begin
        fsm_function = IDLE;
      end
    gnt4p4: 
      if (req4p == 1'b1) begin
        fsm_function = gnt4p4;
      end 
      else begin
        fsm_function = IDLE;
      end
    gnt5p5: 
      if (req5p == 1'b1) begin
        fsm_function = gnt5p5;
      end 
      else begin
        fsm_function = IDLE;
      end
    gnt1n1: 
      if (req1n == 1'b1) begin
        fsm_function = gnt1n1;
      end 
      else begin
        fsm_function = IDLE;
      end
    gnt2n2: 
      if (req2n == 1'b1) begin
        fsm_function = gnt2n2;
      end 
      else begin
        fsm_function = IDLE;
      end
    gnt3n3: 
      if (req3n == 1'b1) begin
        fsm_function = gnt3n3;
      end 
      else begin
        fsm_function = IDLE;
      end
    gnt4n4: 
      if (req4n == 1'b1) begin
        fsm_function = gnt4n4;
      end 
      else begin
        fsm_function = IDLE;
      end
    default : 
      fsm_function = IDLE;
    endcase
  endfunction
  
//----------Seq Logic-----------------------------
  always @ (posedge core_clock)
    begin : FSM_SEQ
      if (core_rst == 1'b1) begin
        state <= IDLE;
      end 
      else begin
        state <= next_state;
      end
    end

//----------Output Logic-----------------------------
  always @ (posedge core_clock or posedge clk1p or posedge clk2p or posedge clk3p or posedge clk4p or posedge clk5p or posedge clk1n or posedge clk2n or posedge clk3n or posedge clk4n)
    begin : OUTPUT_LOGIC
        case(state)
          IDLE: begin
            gnt1p <= 1'b0;
            gnt2p <= 1'b0;
            gnt3p <= 1'b0;
            gnt4p <= 1'b0;
            gnt5p <= 1'b0;
            gnt1n <= 1'b0;
            gnt2n <= 1'b0;
            gnt3n <= 1'b0;
            gnt4n <= 1'b0;
          end
          gnt1p1: begin
                gnt1p <= 1'b1;
                gnt2p <= 1'b0;
                gnt3p <= 1'b0;
                gnt4p <= 1'b0;
                gnt5p <= 1'b0;
                gnt1n <= 1'b0;
                gnt2n <= 1'b0;
                gnt3n <= 1'b0;
                gnt4n <= 1'b0;
                // start_fsm(din1p, clk1p);
          end
          gnt2p2: begin
            gnt1p <= 1'b0;
            gnt2p <= 1'b1;
            gnt3p <= 1'b0;
            gnt4p <= 1'b0;
            gnt5p <= 1'b0;
            gnt1n <= 1'b0;
            gnt2n <= 1'b0;
            gnt3n <= 1'b0;
            gnt4n <= 1'b0;
            // start_fsm(din2p, clk2p);
          end
          gnt3p3: begin
            gnt1p <= 1'b0;
            gnt2p <= 1'b0;
            gnt3p <= 1'b1;
            gnt4p <= 1'b0;
            gnt5p <= 1'b0;
            gnt1n <= 1'b0;
            gnt2n <= 1'b0;
            gnt3n <= 1'b0;
            gnt4n <= 1'b0;
            // start_fsm(din3p, clk3p);
          end
          gnt4p4: begin
            gnt1p <= 1'b0;
            gnt2p <= 1'b0;
            gnt3p <= 1'b0;
            gnt4p <= 1'b1;
            gnt5p <= 1'b0;
            gnt1n <= 1'b0;
            gnt2n <= 1'b0;
            gnt3n <= 1'b0;
            gnt4n <= 1'b0;
            // start_fsm(din4p, clk4p);
          end
          gnt5p5: begin
            gnt1p <= 1'b0;
            gnt2p <= 1'b0;
            gnt3p <= 1'b0;
            gnt4p <= 1'b0;
            gnt5p <= 1'b1;
            gnt1n <= 1'b0;
            gnt2n <= 1'b0;
            gnt3n <= 1'b0;
            gnt4n <= 1'b0;
            // start_fsm(din5p, clk5p);
          end
          gnt1n1: begin
            gnt1p <= 1'b0;
            gnt2p <= 1'b0;
            gnt3p <= 1'b0;
            gnt4p <= 1'b0;
            gnt5p <= 1'b0;
            gnt1n <= 1'b1;
            gnt2n <= 1'b0;
            gnt3n <= 1'b0;
            gnt4n <= 1'b0;
            // start_fsm(din1n, clk1n);
          end
          gnt2n2: begin
            gnt1p <= 1'b0;
            gnt2p <= 1'b0;
            gnt3p <= 1'b0;
            gnt4p <= 1'b0;
            gnt5p <= 1'b0;
            gnt1n <= 1'b0;
            gnt2n <= 1'b1;
            gnt3n <= 1'b0;
            gnt4n <= 1'b0;
            // start_fsm(din2n, clk2n);
          end
          gnt3n3: begin
            gnt1p <= 1'b0;
            gnt2p <= 1'b0;
            gnt3p <= 1'b0;
            gnt4p <= 1'b0;
            gnt5p <= 1'b0;
            gnt1n <= 1'b0;
            gnt2n <= 1'b0;
            gnt3n <= 1'b1;
            gnt4n <= 1'b0;
            // start_fsm(din3n, clk3n);
          end
          gnt4n4: begin
            gnt1p <= 1'b0;
            gnt2p <= 1'b0;
            gnt3p <= 1'b0;
            gnt4p <= 1'b0;
            gnt5p <= 1'b0;
            gnt1n <= 1'b0;
            gnt2n <= 1'b0;
            gnt3n <= 1'b0;
            gnt4n <= 1'b1;
            // start_fsm(din4n, clk4n);
          end
          default: begin
            gnt1p <= 1'b0;
            gnt2p <= 1'b0;
            gnt3p <= 1'b0;
            gnt4p <= 1'b0;
            gnt5p <= 1'b0;
            gnt1n <= 1'b0;
            gnt2n <= 1'b0;
            gnt3n <= 1'b0;
            gnt4n <= 1'b0;
          end
        endcase
    end // End Of Block OUTPUT_LOGIC
  
endmodule
