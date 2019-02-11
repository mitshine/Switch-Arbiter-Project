module arbiter(core_clock, core_rst,
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
  
  //reg preamble;
  reg sourceAddr;
  reg destAddr;
  reg [7:0] clkFreq;
  reg [10:0] data;
  reg dataSize;
  reg [15:0] crc;
  
  reg [7:0] clk_cnt;
  reg enable;
  always @(posedge core_clock)
  if (core_rst) begin
    clk_cnt <= 8'b0 ;
  end else if (enable) begin
    clk_cnt <= clk_cnt + 1;
  end
  
  reg [6:0] current_state, next_state;
  reg check;
  wire [8:0] transmit_buffer_1p;
  //integer my_int;
  //txVar = 
  //parameter SIZE_TX = 56 + txVar;
  
  /*
  always_comb
    begin
      if(clk_cnt == 8'b1)
        current_state <= next_state;
      else if(clk_cnt == 8'b10)
        begin
          transmit_buffer[0] = din1p;
          
        end
    end
    */
    
  reg [7:0] tmp_preamble; 
 
  /*
  always@(posedge core_clock) 
    begin 
      tmp_preamble = tmp_preamble << 1; 
      tmp_preamble[0] = din1p; 
    end 
  assign transmit_buffer_1p  = tmp_preamble[7];
  */
  
  always@(posedge core_clock or core_rst)
    begin
      if(core_rst)
        begin
          current_state <= preamble;
          next_state <= preamble;
        end
      else
        current_state <= next_state;
    end

  always_comb
    begin
      case(current_state)
        preamble:
          begin
            tmp_preamble[0] = din1p;
            tmp_preamble = tmp_preamble << 1;
            if(flag)
              next_state <= source_addr;
          end
        source_addr:
          begin
            tmp_src_addr[0] = din1p;
            tmp_src_addr = tmp_src_addr << 1;
            if(flag)
              next_state <= destination_addr;
          end
        destination_addr:
          begin
            tmp_dest_addr[0] = din1p;
            tmp_dest_addr = tmp_dest_addr << 1;
            if(flag)
              next_state <= clock_frequency;
          end
        clock_frequency:
          begin
            tmp_clock_freq[0] = din1p;
            tmp_clock_freq = tmp_clock_freq << 1;
            if(flag)
              next_state <= data_length;
          end
        data_length:
          begin
            tmp_data_length[0] = din1p;
            tmp_data_length = tmp_data_length << 1;
            if(flag)
              next_state <= data_size;
          end
        data_size:
          begin
            tmp_data_size[0] = din1p;
            tmp_data_size = tmp_data_size << 1;
            if(flag)
              next_state <= data_crc;
          end
        data_crc:
          begin
            tmp_data_crc[0] = din1p;
            tmp_data_crc = tmp_data_crc << 1;
            if(flag)
              next_state <= preamble;
          end
    end
  
  assign transmit_buffer_1p  = tmp_preamble[7];
      
  assign preamble = 8'b11111110; // 0xFE;
  // assign sourceAddr = 0x0_P;
  // assign destAddr = 0x0_N;
  
  parameter SIZE = 7;
  parameter IDLE  = 7'b000; //GNT1 = 3'b010,GNT2 = 3'b100 ;
  reg   [SIZE-1:0]          state        ;
  wire  [SIZE-1:0]          next_state   ;
  assign next_state = fsm_function(state, req1p, req2p, req3p, req4p, req5p);
  
  //----------Function for Combo Logic-----------------
  function [SIZE-1:0] fsm_function;
    input [SIZE-1:0] state;	
    input req1p;
    input req2p;
    input req3p;
    input req4p;
    input req5p;
    case(state)
    IDLE:
      if (req1p == 1'b1) begin
        fsm_function = gnt1p;
      end 
      else if (req2p == 1'b1) begin
        fsm_function = gnt2p;
      end
      else if (req3p == 1'b1) begin
        fsm_function = gnt3p;
      end
      else if (req4p == 1'b1) begin
        fsm_function = gnt4p;
      end
      else if (req5p == 1'b1) begin
        fsm_function = gnt5p;
      end
      else begin
        fsm_function = IDLE;
      end
    gnt1p: 
      if (req1p == 1'b1) begin
        fsm_function = gnt1p;
      end 
      else begin
        fsm_function = IDLE;
      end
    gnt2p: 
      if (req2p == 1'b1) begin
        fsm_function = gnt2p;
      end 
      else begin
        fsm_function = IDLE;
      end
    gnt3p: 
      if (req3p == 1'b1) begin
        fsm_function = gnt3p;
      end 
      else begin
        fsm_function = IDLE;
      end
    gnt4p: 
      if (req4p == 1'b1) begin
        fsm_function = gnt4p;
      end 
      else begin
        fsm_function = IDLE;
      end
    gnt5p: 
      if (req5p == 1'b1) begin
        fsm_function = gnt5p;
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
        state <= #1 IDLE;
      end 
      else begin
        state <= #1 next_state;
      end
    end

//----------Output Logic-----------------------------
  always @ (posedge core_clock)
    begin : OUTPUT_LOGIC
      if (core_rst == 1'b1) begin
        gnt1p <= #1 1'b0;
        gnt2p <= #1 1'b0;
        gnt3p <= #1 1'b0;
        gnt4p <= #1 1'b0;
        gnt5p <= #1 1'b0;
      end
      else begin
        case(state)
          IDLE: begin
            gnt1p <= #1 1'b0;
            gnt2p <= #1 1'b0;
            gnt3p <= #1 1'b0;
            gnt4p <= #1 1'b0;
            gnt5p <= #1 1'b0;
          end
          gnt1p: begin
            gnt1p <= #1 1'b1;
            gnt2p <= #1 1'b0;
            gnt3p <= #1 1'b0;
            gnt4p <= #1 1'b0;
            gnt5p <= #1 1'b0;
          end
          gnt2p: begin
            gnt1p <= #1 1'b0;
            gnt2p <= #1 1'b1;
            gnt3p <= #1 1'b0;
            gnt4p <= #1 1'b0;
            gnt5p <= #1 1'b0;
          end
          gnt3p: begin
            gnt1p <= #1 1'b0;
            gnt2p <= #1 1'b0;
            gnt3p <= #1 1'b1;
            gnt4p <= #1 1'b0;
            gnt5p <= #1 1'b0;
          end
          gnt4p: begin
            gnt1p <= #1 1'b0;
            gnt2p <= #1 1'b0;
            gnt3p <= #1 1'b0;
            gnt4p <= #1 1'b1;
            gnt5p <= #1 1'b0;
          end
          gnt5p: begin
            gnt1p <= #1 1'b0;
            gnt2p <= #1 1'b0;
            gnt3p <= #1 1'b0;
            gnt4p <= #1 1'b0;
            gnt5p <= #1 1'b1;
          end
          default: begin
            gnt1p <= #1 1'b0;
            gnt2p <= #1 1'b0;
            gnt3p <= #1 1'b0;
            gnt4p <= #1 1'b0;
            gnt5p <= #1 1'b0;
          end
        endcase
      end
    end // End Of Block OUTPUT_LOGIC
  
endmodule
