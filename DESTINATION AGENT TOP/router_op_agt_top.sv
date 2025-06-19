class router_op_agt_top extends uvm_env;
  `uvm_component_utils(router_op_agt_top)
  router_op_agent rop_agth[];
  router_env_config router_env_cfg;
 // router_virtual_sequencer v_seqrh;

function new(string name = "router_ip_agt_top",uvm_component parent);
  super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",router_env_cfg))
    `uvm_fatal(get_type_name(),"didn' get env config in env")
  if(router_env_cfg.has_op_agent)begin
    rop_agth= new[router_env_cfg.no_of_op_agents];
  foreach(rop_agth[i])begin
  uvm_config_db#(router_op_agt_config)::set(this,$sformatf("rop_agth[%0d]*",i),"router_op_agt_config",router_env_cfg.op_agt_cfg[i]);

  rop_agth[i] = router_op_agent::type_id::create($sformatf("rop_agth[%0d]",i),this);
  end
end
endfunction

/*function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  if(router_env_cfg.has_virtual_sequencer)begin    
    rop_agth= new[router_env_cfg.no_of_op_agents];
  
   if(router_env_cfg.has_op_agent)begin
    foreach(rop_agth[i])begin
      v_seqrh.op_seqrh=  rop_agth[i].op_seqrh;
    end
end
   
end
endfunction
*/
function void start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
  uvm_top.print_topology();
endfunction
endclass
