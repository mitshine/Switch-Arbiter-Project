module switch_arbiter_new(core_clock, core_rst,
din1p, req1p, clk1p, dout1p, gnt1p,
din2p, req2p, clk2p, dout2p, gnt2p,
din3p, req3p, clk3p, dout3p, gnt3p,
din4p, req4p, clk4p, dout4p, gnt4p,
din5p, req5p, clk5p, dout5p, gnt5p,
din1n, req1n, clk1n, dout1n, gnt1n,
din2n, req2n, clk2n, dout2n, gnt2n,
din3n, req3n, clk3n, dout3n, gnt3n,
din4n, req4n, clk4n, dout4n, gnt4n);
  
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
  
  integer x_tmp = 0;
  
  reg [79:0] receive_buffer;
  reg [79:0] received_buffer;
  reg [7:0] tmp_preamble;
  reg [7:0] tmp_src_addr;
  reg [7:0] tmp_dest_addr;
  reg [7:0] tmp_clock_freq;
  reg [15:0] tmp_data_length;
  reg [15:0] tmp_data_size;
  reg [15:0] tmp_data_crc;
  
  reg [159:0] cnt;
  reg [7:0] cnt1;
  
  task start_fsm;
    input din;
    begin
              cnt <= cnt + 1;
              if(cnt < 7)
                begin
                  tmp_preamble[0] = din;
                  tmp_preamble = tmp_preamble << 1;
                end
              else if(cnt == 7)
                begin
                  tmp_preamble[0] = din;
                end
              else if(cnt > 7 && cnt < 15)
                begin
                  tmp_src_addr[0] = din;
                  tmp_src_addr = tmp_src_addr << 1;
                end
              else if(cnt == 15)
                begin
                  tmp_src_addr[0] = din;
                end
              else if(cnt > 15 && cnt < 23)
                begin
                  tmp_dest_addr[0] = din;
                  tmp_dest_addr = tmp_dest_addr << 1;
                end
              else if(cnt == 23)
                begin
                  tmp_dest_addr[0] = din;
                end
              else if(cnt > 23 && cnt < 31)
                begin
                  tmp_clock_freq[0] = din;
                  tmp_clock_freq = tmp_clock_freq << 1;
                end
              else if(cnt == 31)
                begin
                  tmp_clock_freq[0] = din;
                end
              else if(cnt > 31 && cnt < 47)
                begin
                  tmp_data_length[0] = din;
                  tmp_data_length = tmp_data_length << 1;
                  x_tmp = tmp_data_length;
                end
              else if(cnt == 47)
                begin
                  tmp_data_length[0] = din;
                end
              else if(cnt > 47 && cnt < 63)
                begin
                  tmp_data_size[0] = din;
                  tmp_data_size = tmp_data_size << 1;
                end
              else if(cnt == 63)
                begin
                  tmp_data_size[0] = din;
                end
              else if(cnt > 63 && cnt < 79)
                begin
                  tmp_data_crc[0] = din;
                  tmp_data_crc = tmp_data_crc << 1;
                end
              else if(cnt == 79)
                begin
                  tmp_data_crc[0] = din;
                end
                receive_buffer = {tmp_preamble, tmp_src_addr, tmp_dest_addr, tmp_clock_freq, tmp_data_length, tmp_data_size, tmp_data_crc};
                received_buffer <= receive_buffer;
              if(cnt > 79 && cnt <= 159)
              begin
                if(tmp_dest_addr == 8'h00)
                  begin
                        dout1n <= received_buffer[79];
                        received_buffer <= received_buffer << 1;
                  end
                if(tmp_dest_addr == 8'h01)
                  begin
                        dout2n <= received_buffer[79];
                        received_buffer <= received_buffer << 1;
                  end
                if(tmp_dest_addr == 8'h02)
                  begin
                        dout3n <= received_buffer[79];
                        received_buffer <= received_buffer << 1;
                  end
                if(tmp_dest_addr == 8'h03)
                  begin
                        dout4n <= received_buffer[79];
                        received_buffer <= received_buffer << 1;
                  end
                if(tmp_dest_addr == 8'hF0)
                  begin
                        dout1p <= received_buffer[79];
                        received_buffer <= received_buffer << 1;
                  end
                if(tmp_dest_addr == 8'hF1)
                  begin
                        dout2p <= received_buffer[79];
                        received_buffer <= received_buffer << 1;
                  end
                if(tmp_dest_addr == 8'hF2)
                  begin
                        dout3p <= received_buffer[79];
                        received_buffer <= received_buffer << 1;
                  end
                if(tmp_dest_addr == 8'hF3)
                  begin
                        dout4p <= received_buffer[79];
                        received_buffer <= received_buffer << 1;
                  end
                if(tmp_dest_addr == 8'hF4)
                  begin
						            dout5p <= received_buffer[79];
                        received_buffer <= received_buffer << 1;
                  end
                end
              end
  endtask
  
  parameter SIZE = 4;
  parameter IDLE  = 4'b0000;
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
      if (core_rst) begin
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
            if(core_rst)
              begin
                cnt1 <= 0;
              end
            gnt1p <= 1'b0;
            gnt2p <= 1'b0;
            gnt3p <= 1'b0;
            gnt4p <= 1'b0;
            gnt5p <= 1'b0;
            gnt1n <= 1'b0;
            gnt2n <= 1'b0;
            gnt3n <= 1'b0;
            gnt4n <= 1'b0;
            dout1p <= 1'b0;
            dout2p <= 1'b0;
            dout3p <= 1'b0;
            dout4p <= 1'b0;
            dout5p <= 1'b0;
            dout1n <= 1'b0;
            dout2n <= 1'b0;
            dout3n <= 1'b0;
            dout4n <= 1'b0;
            tmp_preamble <= 0;
            tmp_src_addr <= 0;
            tmp_dest_addr <= 0;
            tmp_clock_freq <= 0;
            tmp_data_length <= 0;
            tmp_data_size <= 0;
            tmp_data_crc <= 0;
            cnt <= 0;
          end
          gnt1p1: begin
            if(cnt1 > 160'b10100000)
              begin
                gnt1p <= 1'b1;
                gnt2p <= 1'b0;
                gnt3p <= 1'b0;
                gnt4p <= 1'b0;
                gnt5p <= 1'b0;
                gnt1n <= 1'b0;
                gnt2n <= 1'b0;
                gnt3n <= 1'b0;
                gnt4n <= 1'b0;
                @(posedge clk1p)
                  start_fsm(din1p);
              end
            else
              begin
                    cnt1 <= cnt1 + 160'b1;
                    gnt1p <= 1'b1;
                    gnt2p <= 1'b0;
                    gnt3p <= 1'b0;
                    gnt4p <= 1'b0;
                    gnt5p <= 1'b0;
                    gnt1n <= 1'b0;
                    gnt2n <= 1'b0;
                    gnt3n <= 1'b0;
                    gnt4n <= 1'b0;
                    @(posedge core_clock)
                      start_fsm(din1p);
              end
          end
          gnt2p2: begin
            if(cnt1 > 160'b10100000)
              begin
                gnt1p <= 1'b0;
                gnt2p <= 1'b1;
                gnt3p <= 1'b0;
                gnt4p <= 1'b0;
                gnt5p <= 1'b0;
                gnt1n <= 1'b0;
                gnt2n <= 1'b0;
                gnt3n <= 1'b0;
                gnt4n <= 1'b0;
                @(posedge clk2p)
                  start_fsm(din2p);
              end
            else
              begin
                    cnt1 <= cnt1 + 160'b1;
                    gnt1p <= 1'b0;
                    gnt2p <= 1'b1;
                    gnt3p <= 1'b0;
                    gnt4p <= 1'b0;
                    gnt5p <= 1'b0;
                    gnt1n <= 1'b0;
                    gnt2n <= 1'b0;
                    gnt3n <= 1'b0;
                    gnt4n <= 1'b0;
                    @(posedge core_clock)
                      start_fsm(din2p);
              end
          end
          gnt3p3: begin
            if(cnt1 > 160'b10100000)
              begin
                gnt1p <= 1'b0;
                gnt2p <= 1'b0;
                gnt3p <= 1'b1;
                gnt4p <= 1'b0;
                gnt5p <= 1'b0;
                gnt1n <= 1'b0;
                gnt2n <= 1'b0;
                gnt3n <= 1'b0;
                gnt4n <= 1'b0;
                @(posedge clk3p)
                  start_fsm(din3p);
              end
            else
              begin
                    cnt1 <= cnt1 + 160'b1;
                    gnt1p <= 1'b0;
                    gnt2p <= 1'b0;
                    gnt3p <= 1'b1;
                    gnt4p <= 1'b0;
                    gnt5p <= 1'b0;
                    gnt1n <= 1'b0;
                    gnt2n <= 1'b0;
                    gnt3n <= 1'b0;
                    gnt4n <= 1'b0;
                    @(posedge core_clock)
                      start_fsm(din3p);
              end
          end
          gnt4p4: begin
            if(cnt1 > 160'b10100000)
              begin
                gnt1p <= 1'b0;
                gnt2p <= 1'b0;
                gnt3p <= 1'b0;
                gnt4p <= 1'b1;
                gnt5p <= 1'b0;
                gnt1n <= 1'b0;
                gnt2n <= 1'b0;
                gnt3n <= 1'b0;
                gnt4n <= 1'b0;
                @(posedge clk4p)
                  start_fsm(din4p);
              end
            else
              begin
                    cnt1 <= cnt1 + 160'b1;
                    gnt1p <= 1'b0;
                    gnt2p <= 1'b0;
                    gnt3p <= 1'b0;
                    gnt4p <= 1'b1;
                    gnt5p <= 1'b0;
                    gnt1n <= 1'b0;
                    gnt2n <= 1'b0;
                    gnt3n <= 1'b0;
                    gnt4n <= 1'b0;
                    @(posedge core_clock)
                      start_fsm(din4p);
              end
          end
          gnt5p5: begin
            if(cnt1 > 160'b10100000)
              begin
                gnt1p <= 1'b0;
                gnt2p <= 1'b0;
                gnt3p <= 1'b0;
                gnt4p <= 1'b0;
                gnt5p <= 1'b1;
                gnt1n <= 1'b0;
                gnt2n <= 1'b0;
                gnt3n <= 1'b0;
                gnt4n <= 1'b0;
                @(posedge clk5p)
                  start_fsm(din5p);
              end
            else
              begin
                    cnt1 <= cnt1 + 160'b1;
                    gnt1p <= 1'b0;
                    gnt2p <= 1'b0;
                    gnt3p <= 1'b0;
                    gnt4p <= 1'b0;
                    gnt5p <= 1'b1;
                    gnt1n <= 1'b0;
                    gnt2n <= 1'b0;
                    gnt3n <= 1'b0;
                    gnt4n <= 1'b0;
                    @(posedge core_clock)
                      start_fsm(din5p);
              end
          end
          gnt1n1: begin
            if(cnt1 > 160'b10100000)
              begin
                gnt1p <= 1'b0;
                gnt2p <= 1'b0;
                gnt3p <= 1'b0;
                gnt4p <= 1'b0;
                gnt5p <= 1'b0;
                gnt1n <= 1'b1;
                gnt2n <= 1'b0;
                gnt3n <= 1'b0;
                gnt4n <= 1'b0;
                @(posedge clk1n)
                  start_fsm(din1n);
              end
            else
              begin
                    cnt1 <= cnt1 + 160'b1;
                    gnt1p <= 1'b0;
                    gnt2p <= 1'b0;
                    gnt3p <= 1'b0;
                    gnt4p <= 1'b0;
                    gnt5p <= 1'b0;
                    gnt1n <= 1'b1;
                    gnt2n <= 1'b0;
                    gnt3n <= 1'b0;
                    gnt4n <= 1'b0;
                    @(posedge core_clock)
                      start_fsm(din1n);
              end
          end
          gnt2n2: begin
            if(cnt1 > 160'b10100000)
              begin
                gnt1p <= 1'b0;
                gnt2p <= 1'b0;
                gnt3p <= 1'b0;
                gnt4p <= 1'b0;
                gnt5p <= 1'b0;
                gnt1n <= 1'b0;
                gnt2n <= 1'b1;
                gnt3n <= 1'b0;
                gnt4n <= 1'b0;
                @(posedge clk2n)
                  start_fsm(din2n);
              end
            else
              begin
                    cnt1 <= cnt1 + 160'b1;
                    gnt1p <= 1'b0;
                    gnt2p <= 1'b0;
                    gnt3p <= 1'b0;
                    gnt4p <= 1'b0;
                    gnt5p <= 1'b0;
                    gnt1n <= 1'b0;
                    gnt2n <= 1'b1;
                    gnt3n <= 1'b0;
                    gnt4n <= 1'b0;
                    @(posedge core_clock)
                      start_fsm(din2n);
              end
          end
          gnt3n3: begin
            if(cnt1 > 160'b10100000)
              begin
                gnt1p <= 1'b0;
                gnt2p <= 1'b0;
                gnt3p <= 1'b0;
                gnt4p <= 1'b0;
                gnt5p <= 1'b0;
                gnt1n <= 1'b0;
                gnt2n <= 1'b0;
                gnt3n <= 1'b1;
                gnt4n <= 1'b0;
                @(posedge clk3n)
                  start_fsm(din3n);
              end
            else
              begin
                    cnt1 <= cnt1 + 160'b1;
                    gnt1p <= 1'b0;
                    gnt2p <= 1'b0;
                    gnt3p <= 1'b0;
                    gnt4p <= 1'b0;
                    gnt5p <= 1'b0;
                    gnt1n <= 1'b0;
                    gnt2n <= 1'b0;
                    gnt3n <= 1'b1;
                    gnt4n <= 1'b0;
                    @(posedge core_clock)
                      start_fsm(din3n);
              end
          end
          gnt4n4: begin
            if(cnt1 > 160'b10100000)
              begin
                gnt1p <= 1'b0;
                gnt2p <= 1'b0;
                gnt3p <= 1'b0;
                gnt4p <= 1'b0;
                gnt5p <= 1'b0;
                gnt1n <= 1'b0;
                gnt2n <= 1'b0;
                gnt3n <= 1'b0;
                gnt4n <= 1'b1;
                @(posedge clk4n)
                  start_fsm(din4n);
              end
            else
              begin
                    cnt1 <= cnt1 + 160'b1;
                    gnt1p <= 1'b0;
                    gnt2p <= 1'b0;
                    gnt3p <= 1'b0;
                    gnt4p <= 1'b0;
                    gnt5p <= 1'b0;
                    gnt1n <= 1'b0;
                    gnt2n <= 1'b0;
                    gnt3n <= 1'b0;
                    gnt4n <= 1'b1;
                    @(posedge core_clock)
                      start_fsm(din4n);
              end
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
