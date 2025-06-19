module top;
	import router_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"
	bit clk;
	always #6 clk=~clk;
	router_if ip_if1(clk);
	router_if op_if1(clk);
	router_if op_if2(clk);
	router_if op_if3(clk);
		
	router_top DUV(.clock(clk),
			.resetn(ip_if1.rstn),
			.read_enb_1(op_if0.read_enb),
			.read_enb_2(op_if1.read_enb),
			.read_enb_3(op_if2.read_enb),
			.pkt_valid(ip_if1.pkt_valid),
			.data_in(ip_if1.din),
			.data_out_1(op_if0.data_out),
			.data_out_2(op_if1.data_out),
			.data_out_3(op_if2.data_out),
			.valid_out_1(op_if0.valid_out),
			.valid_out_2(op_if1.valid_out),
			.valid_out_3(op_if2.valid_out),
			.error(ip_if1.error),
			.busy(ip_if1.busy)
			);

initial
begin
  uvm_config_db#(virtual router_if)::set(null,"*","ip_if0",ip_if0);
  uvm_config_db#(virtual router_if)::set(null,"*","op_if0",op_if0);
  uvm_config_db#(virtual router_if)::set(null,"*","op_if1",op_if1);
  uvm_config_db#(virtual router_if)::set(null,"*","op_if2",op_if2);
      
  `uvm_info("TOP","TOP BLOCK",UVM_LOW)
	run_test();
end
	endmodule
