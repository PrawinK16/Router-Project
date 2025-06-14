module router_reg(input clock,resetn,pkt_valid,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,[7:0]data_in,output reg parity_done,reg low_pkt_valid,reg err,reg[7:0]dout);

  reg [7:0]header,fifo_full_state,internal_parity,packet_parity;

  always@(posedge clock)begin
    if(!resetn)begin
      header<=8'b0;
    end
    else if(detect_add && pkt_valid && data_in[1:0]!=3)
      header<=data_in;
    else
      header<=header;
  end

  always@(posedge clock)begin
    if(!resetn)
      fifo_full_state<=8'b0;
    else if(ld_state && fifo_full)
      fifo_full_state<=data_in;
    else
      fifo_full_state<=fifo_full_state;
  end

  always@(posedge clock)begin
    if(!resetn)
      internal_parity<=8'b0;
    else if(detect_add)
      internal_parity<=8'b0;
    else if(lfd_state)
      internal_parity<=internal_parity^header;
    else if(pkt_valid && ld_state && !full_state)   
      internal_parity<=internal_parity^data_in;
    else      internal_parity<=internal_parity;
  end

  always@(posedge clock)begin
    if(!resetn)      packet_parity<=8'b0;
    else if(detect_add)      packet_parity<=8'b0;
    else if(ld_state && !pkt_valid)      packet_parity<=data_in;
    else      packet_parity<=packet_parity;
  end
  always@(posedge clock)begin
    if(!resetn)      parity_done<=1'b0;
    else if(detect_add)      parity_done<=1'b0;
    else if(ld_state && !fifo_full && !pkt_valid)      parity_done<=1'b1;
    else if(laf_state && low_pkt_valid &&!parity_done)      parity_done<=1'b1;
    else      parity_done<=1'b0;
  end

  always@(posedge clock)begin    if(!resetn)
      low_pkt_valid<=1'b0;    else if(rst_int_reg)
      low_pkt_valid<=1'b0;    else if(ld_state && !pkt_valid)
      low_pkt_valid<=1'b1;    else
      low_pkt_valid<=1'b0;  end

  always@(posedge clock)begin    if(!resetn)
      dout<=8'b0;    else if(detect_add && pkt_valid && data_in[1:0]!=2'b11)
      dout<=dout;    else if(lfd_state)
      dout<=header;    else if(ld_state && !fifo_full)
      dout<=data_in;    else if(ld_state && fifo_full)
      dout<=dout;    else if(laf_state)
      dout<=fifo_full_state;    else
      dout<=dout;  end
  always@(posedge clock)begin
    if(!resetn)
      err<=1'b0;
    else if(parity_done && (internal_parity!=packet_parity))      err<=1'b1;
    else      err<=err;
  end
endmodule
