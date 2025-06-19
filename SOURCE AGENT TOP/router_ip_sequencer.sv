class router_ip_sequencer extends uvm_sequencer#(ip_xtn);
  `uvm_component_utils(router_ip_sequencer)
function new(string name = "router_ip_sequencer",uvm_component parent);
  super.new(name,parent);
endfunction

endclass
