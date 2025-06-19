class router_virtual_sequencer extends uvm_sequencer#(uvm_sequence_item);
  `uvm_component_utils(router_virtual_sequencer)
  router_ip_sequencer ip_seqrh[];
  router_op_sequencer op_seqrh[];
  router_env_config router_env_cfg;

function new(string name = "router_virtual_sequencer",uvm_component parent);
  super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db #(router_env_config)::get(this,"","router_env_config",router_env_cfg))
    `uvm_fatal(get_type_name(),"didn't get env_config in vseqr")
  ip_seqrh = new[router_env_cfg.no_of_ip_agents];
  op_seqrh = new[router_env_cfg.no_of_op_agents];

endfunction
endclass
