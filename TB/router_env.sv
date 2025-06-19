class router_env extends uvm_env;
  `uvm_component_utils(router_env)
  router_op_agt_top rop_agt_toph;
  router_ip_agt_top rip_agt_toph;
  router_env_config router_env_cfg;
  router_virtual_sequencer v_seqrh;

  router_scoreboard sb;
function new(string name = "router_env",uvm_component parent);
  super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  v_seqrh = router_virtual_sequencer::type_id::create("v_seqrh",this);
  if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",router_env_cfg))
    `uvm_fatal(get_type_name(),"didn' get env config in env")

  if(router_env_cfg.has_ip_agent)
  rip_agt_toph = router_ip_agt_top::type_id::create("rip_agt_toph",this);
  

  if(router_env_cfg.has_op_agent)
  rop_agt_toph = router_op_agt_top::type_id::create("rop_agt_toph",this);
  

  sb = router_scoreboard::type_id::create("sb",this);

  //`uvm_info(get_type_name(),"In env",UVM_LOW)
endfunction

function void connect_phase(uvm_phase phase);
                      if(router_env_cfg.has_virtual_sequencer) begin
			if(router_env_cfg.has_ip_agent)
			foreach(rip_agt_toph.rip_agth[i])
				v_seqrh.ip_seqrh[i]=rip_agt_toph.rip_agth[i].ip_seqrh;
				
			
                        if(router_env_cfg.has_op_agent)
                        foreach(rop_agt_toph.rop_agth[i])
				v_seqrh.op_seqrh[i]=rop_agt_toph.rop_agth[i].op_seqrh;
                      end
	
  rip_agt_toph.rip_agth[0].ip_monh.monitor_port.connect(sb.fifo_iph[0].analysis_export);
  foreach(rop_agt_toph.rop_agth[i])
    rop_agt_toph.rop_agth[i].op_monh.monitor_port.connect(sb.fifo_oph[i].analysis_export);
    
endfunction
endclass
