class router_op_agent extends uvm_agent;
 `uvm_component_utils(router_op_agent)
  router_op_drv op_drvh;
  router_op_sequencer op_seqrh;
  router_op_mon op_monh;
  router_op_agt_config op_agt_cfg;
  
function new (string name = "router_op_agent",uvm_component parent);
 super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
 op_monh = router_op_mon::type_id::create("op_monh",this); 

  if(!uvm_config_db#(router_op_agt_config)::get(this,"","router_op_agt_config",op_agt_cfg))
    `uvm_fatal(get_type_name(),"didn't get op_agt_config in agt")

  if(op_agt_cfg.is_active)begin  

  op_drvh = router_op_drv ::type_id::create("op_drvh",this);
  op_seqrh = router_op_sequencer ::type_id::create("op_seqrh",this);
  end
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  op_drvh.seq_item_port.connect(op_seqrh.seq_item_export);
endfunction

endclass
