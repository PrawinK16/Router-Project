interface router_if(input bit clk);
  logic rstn;
  logic read_enb;
  logic pkt_valid;
  logic [7:0] din;
  logic [7:0] data_out;
  logic valid_out;
  logic error;
  logic busy;

clocking ip_drv_cb@(posedge clk);
  default input #1 output #1;
  output din;
  output pkt_valid;
  output rstn;
  input error;
  input busy;

endclocking

clocking op_drv_cb@(posedge clk);
  default input #1 output #1;
  output read_enb;
  input valid_out;
endclocking


clocking ip_mon_cb@(posedge clk);
  default input #1 output #1;
  input din;
  input pkt_valid;
  input rstn;
  input error;
  input busy;
endclocking

clocking op_mon_cb@(posedge clk);
  default input #1 output #1;
  input data_out;
  input valid_out;
  input read_enb;
  endclocking

modport IP_DRV(clocking ip_drv_cb);
modport IP_MON(clocking ip_mon_cb);
modport OP_DRV(clocking op_drv_cb);
modport OP_MON(clocking op_mon_cb);


property busy_assert;
  @(posedge clk) disable iff(!rstn)
  $rose(pkt_valid) |=> busy;
endproperty

