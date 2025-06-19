class router_ip_agent extends uvm_agent;
 `uvm_component_utils(router_ip_agent)
  router_ip_drv ip_drvh;
  router_ip_sequencer ip_seqrh;
  router_ip_mon ip_monh;
  router_ip_agt_config ip_agt_cfg;

function new (string name = "router_ip_agent",uvm_component parent);
 super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  ip_monh = router_ip_mon::type_id::create("ip_monh",this); 
  if(!uvm_config_db#(router_ip_agt_config)::get(this,"","router_ip_agt_config",ip_agt_cfg))
    `uvm_fatal(get_type_name(),"didn't get ip_agt_config in agt")

  if(ip_agt_cfg.is_active)begin  
  ip_drvh = router_ip_drv ::type_id::create("ip_drvh",this);
  ip_seqrh = router_ip_sequencer ::type_id::create("ip_seqrh",this);
  end
   
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  ip_drvh.seq_item_port.connect(ip_seqrh.seq_item_export);
endfunction
endclass
