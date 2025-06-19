class router_env_config extends uvm_object;
  `uvm_object_utils(router_env_config)
  int no_of_ip_agents;
  int no_of_op_agents;
  bit has_scoreboard;
  bit has_ip_agent;
  bit has_op_agent;
  bit[1:0] addr;
  bit has_virtual_sequencer;
  router_ip_agt_config ip_agt_cfg[];
  router_op_agt_config op_agt_cfg[];
function new(string name="router_env_config");
  super.new(name);
endfunction
endclass
