class router_op_sequencer extends uvm_sequencer#(op_xtn);
  `uvm_component_utils(router_op_sequencer)
function new(string name = "router_op_sequencer",uvm_component parent);
  super.new(name,parent);
endfunction

endclass
