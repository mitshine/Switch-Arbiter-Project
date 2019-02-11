module arbiter_tb;
  
  reg core_clock;
  reg core_rst;
  reg din1p, req1p, clk1p;
  reg din2p, req2p, clk2p;
  reg din3p, req3p, clk3p;
  reg din4p, req4p, clk4p;
  reg din5p, req5p, clk5p;
  reg din1n, req1n, clk1n;
  reg din2n, req2n, clk2n;
  reg din3n, req3n, clk3n;
  reg din4n, req4n, clk4n;
  wire [7:0] tmp_preamble;
  wire [7:0] tmp_src_addr;
  wire [7:0] tmp_dest_addr;
  wire [7:0] tmp_clock_freq;
  wire [15:0] tmp_data_length;
  wire [15:0] tmp_data_size;
  wire [15:0] tmp_data_crc;
  wire gnt1p, dout1p;
  wire gnt2p, dout2p;
  wire gnt3p, dout3p;
  wire gnt4p, dout4p;
  wire gnt5p, dout5p;
  wire gnt1n, dout1n;
  wire gnt2n, dout2n;
  wire gnt3n, dout3n;
  wire gnt4n, dout4n;
  integer i;
  reg [7:0] tmp_preamble1;
  reg [7:0] tmp_src_addr1;
  reg [7:0] tmp_dest_addr1;
  reg [7:0] tmp_clock_freq1;
  reg [15:0] tmp_data_length1;
  reg [15:0] tmp_data_size1;
  reg [15:0] tmp_data_crc1;
  
  initial
    begin
      core_clock = 0;
      core_rst = 1;
      din1p = 0;
      req1p = 0;
      clk1p = 0;
      din2p = 0;
      req2p = 0;
      clk2p = 0;
      din3p = 0;
      req3p = 0;
      clk3p = 0;
      din4p = 0;
      req4p = 0;
      clk4p = 0;
      din5p = 0;
      req5p = 0;
      clk5p = 0;
      din1n = 0;
      req1n = 0;
      clk1n = 0;
      din2n = 0;
      req2n = 0;
      clk2n = 0;
      din3n = 0;
      req3n = 0;
      clk3n = 0;
      din4n = 0;
      req4n = 0;
      clk4n = 0;
      #32;
      // req1p = 1;
      core_rst = 0;
      // din1p = 1;
      #64;
      core_rst = 1;
      // din1p = 1;
      #64;
      core_rst = 0;
      // din1p = 1;
      #72;
      req1p = 1;
      #16;
      // din1p = 0;
      for(i = 0; i < 80; i = i + 1)
        begin
          if(i <= 3)
            begin
              din1p = 1;
              tmp_preamble1[0] = din1p;
              tmp_preamble1 = tmp_preamble1 << 1;
            end
          else if(i > 3 && i <= 6)
            begin
              din1p = 1;
              tmp_preamble1[0] = din1p;
              tmp_preamble1 = tmp_preamble1 << 1;
            end
          else if(i == 7)
            begin
              din1p = 0;
              tmp_preamble1[0] = din1p;
              tmp_preamble1 = tmp_preamble1 << 1;
            end
          else if(i > 7 && i <= 15)
            begin
              din1p = 0;
              tmp_src_addr1[0] = din1p;
              tmp_src_addr1 = tmp_src_addr1 << 1;
            end
          else if(i > 15 && i <= 20)
            begin
              din1p = 1;
              tmp_dest_addr1[0] = din1p;
              tmp_dest_addr1 = tmp_dest_addr1 << 1;
            end
          else if(i > 20 && i <= 21)
            begin
              din1p = 0;
              tmp_dest_addr1[0] = din1p;
              tmp_dest_addr1 = tmp_dest_addr1 << 1;
            end
          else if(i > 21 && i <= 23)
            begin
              din1p = 0;
              tmp_dest_addr1[0] = din1p;
              tmp_dest_addr1 = tmp_dest_addr1 << 1;
            end
          else if(i == 24)
            begin
              din1p = 0;
              tmp_clock_freq1[0] = din1p;
              tmp_clock_freq1 = tmp_clock_freq1 << 1;
            end
          else if(i > 24 && i <= 30)
            begin
              din1p = 0;
              tmp_clock_freq1[0] = din1p;
              tmp_clock_freq1 = tmp_clock_freq1 << 1;
            end
          else if(i == 31)
            begin
              din1p = 1;
              tmp_clock_freq1[0] = din1p;
              tmp_clock_freq1 = tmp_clock_freq1 << 1;
            end
          else if(i > 31 && i <= 45)
            begin
              din1p = 0;
              tmp_data_length1[0] = din1p;
              tmp_data_length1 = tmp_data_length1 << 1;
            end
          else if(i > 45 && i <= 47)
            begin
              din1p = 1;
              tmp_data_length1[0] = din1p;
              tmp_data_length1 = tmp_data_length1 << 1;
            end
          else if(i > 47 && i <= 63)
            begin
              din1p = 0;
              tmp_data_size1[0] = din1p;
              tmp_data_size1 = tmp_data_size1 << 1;
            end
          else if(i > 63 && i <= 79)
            begin
              din1p = 1;
              tmp_data_crc1[0] = din1p;
              tmp_data_crc1 = tmp_data_crc1 << 1;
            end
          else
            begin
              din1p = 0;   // $random();
            end
            #16;
        end
        #1600;
        req1p <= 0;
        #200;
        $finish;
      /*
      #72;
      req1p = 1;
      // preamble starts... 8'hF0
      din1p = 1;
      #16;
      din1p = 1;
      #16;
      din1p = 1;
      #16;
      din1p = 1;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      // source address starts... 8'h00
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      // destination address starts... 8'hF3
      #16;
      din1p = 1;
      #16;
      din1p = 1;
      #16;
      din1p = 1;
      #16;
      din1p = 1;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 1;
      #16;
      din1p = 1;
      // clock frequency... 8'h0A
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 1;
      #16;
      din1p = 0;
      #16;
      din1p = 1;
      #16;
      din1p = 0;
      // length of data... 16'h0007
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 1;
      #16;
      din1p = 1;
      #16;
      din1p = 1;
      // data size...16'h000F
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 1;
      #16;
      din1p = 1;
      #16;
      din1p = 1;
      #16;
      din1p = 1;
      // crc... 16'h1021
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 1;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 1;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 0;
      #16;
      din1p = 1;
      #16;
      din1p = 0;
      #16000;
      req1p = 0;
      */
      #20000;
      $finish;
    end
 
  always
    begin
      #5 core_clock = !core_clock;
    end
  always
    begin
      #8 clk1p = !clk1p;
    end
  always
    begin
      #12 clk2p = !clk2p;
    end
  always
    begin
      #16 clk3p = !clk3p;
    end
  always
    begin
      #19 clk4p = !clk4p;
    end
  always
    begin
      #22 clk5p = !clk5p;
    end
  always
    begin
      #26 clk1n = !clk1n;
    end
  always
    begin
      #29 clk2n = !clk2n;
    end
  always
    begin
      #32 clk3n = !clk3n;
    end
  always
    begin
      #35 clk4n = !clk4n;
    end
    
    preamble arbiter_instance(.core_clock(core_clock), .core_rst(core_rst),
.din1p(din1p), .req1p(req1p), .clk1p(clk1p), .dout1p(dout1p), .gnt1p(gnt1p),
.din2p(din2p), .req2p(req2p), .clk2p(clk2p), .dout2p(dout2p), .gnt2p(gnt2p),
.din3p(din3p), .req3p(req3p), .clk3p(clk3p), .dout3p(dout3p), .gnt3p(gnt3p),
.din4p(din4p), .req4p(req4p), .clk4p(clk4p), .dout4p(dout4p), .gnt4p(gnt4p),
.din5p(din5p), .req5p(req5p), .clk5p(clk5p), .dout5p(dout5p), .gnt5p(gnt5p),
.din1n(din1n), .req1n(req1n), .clk1n(clk1n), .dout1n(dout1n), .gnt1n(gnt1n),
.din2n(din2n), .req2n(req2n), .clk2n(clk2n), .dout2n(dout2n), .gnt2n(gnt2n),
.din3n(din3n), .req3n(req3n), .clk3n(clk3n), .dout3n(dout3n), .gnt3n(gnt3n),
.din4n(din4n), .req4n(req4n), .clk4n(clk4n), .dout4n(dout4n), .gnt4n(gnt4n), 
.tmp_preamble(tmp_preamble), .tmp_src_addr(tmp_src_addr), .tmp_dest_addr(tmp_dest_addr), 
.tmp_clock_freq(tmp_clock_freq), . tmp_data_length(tmp_data_length), .tmp_data_size(tmp_data_size), 
.tmp_data_crc(tmp_data_crc));
  
endmodule
