package router_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	`include "ip_xtn.sv"
	`include "op_xtn.sv"
	
	`include "router_ip_agt_config.sv"
	`include "router_op_agt_config.sv"
	`include "router_env_config.sv"
	`include "router_ip_sequencer.sv"
	`include "router_op_sequencer.sv"
	`include "router_ip_seqs.sv"
	`include "router_op_seqs.sv"

	`include "router_ip_drv.sv"

  `include "router_op_drv.sv"
	`include "router_ip_mon.sv"
	`include "router_op_mon.sv"
	`include "router_agent.sv"
	`include "router_op_agent.sv"

	`include "virtual_sequencer.sv"

	`include "virtual_seqs.sv"

	`include "router_ip_agt_top.sv"
	`include "router_op_agt_top.sv"
        `include "router_scoreboard.sv"
	`include "router_env.sv"
	`include "router_test.sv"
	
endpackage
