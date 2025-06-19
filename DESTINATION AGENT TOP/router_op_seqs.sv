class router_obase_seq extends uvm_sequence#(op_xtn);
  `uvm_object_utils(router_obase_seq)
function new(string name = "router_obase_seq");
  super.new(name); 
endfunction

endclass

class small_opacket extends router_obase_seq;
  `uvm_object_utils(small_opacket)
 // bit[1:0] addr;
function new(string name = "small_opacket");
  super.new(name); 
endfunction

task body();
  req = op_xtn::type_id::create("req");
  start_item(req);
  assert(req.randomize() with {clock inside {[1:29]};});
//  req.header[1:0] = addr;
  finish_item(req);
endtask

endclass
  
