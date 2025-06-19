class router_ip_agt_top extends uvm_env;
  `uvm_component_utils(router_ip_agt_top)
  router_ip_agent rip_agth[];
  router_env_config router_env_cfg;

function new(string name = "router_ip_agt_top",uvm_component parent);
  super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",router_env_cfg))
    `uvm_fatal(get_type_name(),"didn' get env config in env")

  if(router_env_cfg.has_ip_agent)begin
   rip_agth= new[router_env_cfg.no_of_ip_agents];
  foreach(rip_agth[i])begin
  uvm_config_db#(router_ip_agt_config)::set(this,$sformatf("rip_agth[%0d]*",i),"router_ip_agt_config",router_env_cfg.ip_agt_cfg[i]);
  rip_agth[i] = router_ip_agent::type_id::create($sformatf("rip_agth[%0d]",i),this);
  end
end
endfunction

      
function void start_of_simulation_phase(uvm_phase phase);
  super.start_of_simulation_phase(phase);
  uvm_top.print_topology();
endfunction
endclass
