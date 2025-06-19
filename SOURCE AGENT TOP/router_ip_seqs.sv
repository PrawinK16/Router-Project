class router_ibase_seq extends uvm_sequence#(ip_xtn);
  `uvm_object_utils(router_ibase_seq)
router_env_config router_env_cfg;
function new(string name = "router_ibase_seq");
  super.new(name); 
endfunction

task body();
  if(!uvm_config_db#(router_env_config)::get(null,get_full_name(),"router_env_config",router_env_cfg))
      `uvm_fatal(get_type_name(),"didn't get env_cfg in vbase_seqs")

endtask

endclass

class small_ipacket extends router_ibase_seq;
  `uvm_object_utils(small_ipacket)
  //bit [1:0] addr;
function new(string name = "small_ipacket");
  super.new(name); 
endfunction

task body();
begin
  super.body();
  req = ip_xtn::type_id::create("req");
    //repeat(5)
  //$display("=====================ip_seq=============================================",router_env_cfg);

//begin
  start_item(req);
  assert(req.randomize() with {header[7:2] inside {[1:14]};});
  req.header[1:0] = router_env_cfg.addr;
  finish_item(req);
//end
end

endtask

endclass

class medium_ipacket extends router_ibase_seq;
  `uvm_object_utils(medium_ipacket)
  //bit[1:0]addr;
function new(string name = "medium_ipacket");
  super.new(name); 
endfunction

task body();
begin
  req= ip_xtn::type_id::create("req");
  super.body();

    start_item(req);
  assert(req.randomize() with {header[7:2] inside {[15:30]};});
  req.header[1:0] =router_env_cfg.addr;
  finish_item(req);
end
endtask

endclass

class big_ipacket extends router_ibase_seq;
  `uvm_object_utils(big_ipacket)
  bit[1:0] addr;
function new(string name = "big_ipacket");
  super.new(name);
endfunction

task body();
  req = ip_xtn::type_id::create("req");
  super.body();

    start_item(req);
  assert(req.randomize() with {header[7:2] inside {[31:63]};});
  req.header[1:0] =router_env_cfg.addr;

  finish_item(req);

endtask
endclass

class gbu_ipacket extends router_ibase_seq;
  `uvm_object_utils(gbu_ipacket)
  bit[1:0]addr;
  ip1_xtn req1;
function new(string name ="gbu_ipacket");
  super.new(name);
endfunction

task body();
  req1 = ip1_xtn::type_id::create("req1");
  super.body();
   start_item(req1);
  assert(req1.randomize() with {header[1:0] == router_env_cfg.addr;header[7:2] inside {[1:63]};});
   finish_item(req1);
endtask
endclass
