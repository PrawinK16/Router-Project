class router_op_agt_config extends uvm_object;
  `uvm_object_utils(router_op_agt_config)
  
  virtual router_if vif;
  uvm_active_passive_enum is_active = UVM_ACTIVE;

function new(string name = "router_op_agt_config");
  super.new(name);
endfunction

endclass
