class router_op_drv extends uvm_driver#(op_xtn);
  `uvm_component_utils(router_op_drv)

  router_op_agt_config op_agt_cfg;
  virtual router_if vif;

function new(string name = "router_op_drv",uvm_component parent);
  super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(router_op_agt_config)::get(this,"","router_op_agt_config",op_agt_cfg))
    `uvm_fatal(get_type_name(),"didn't get op_agt_cfg in op_mon")
    
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  vif = op_agt_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever
  begin
  seq_item_port.get_next_item(req);
  //req.print();
  send_to_dut(req);
 //`uvm_info(get_type_name(),$sformatf("printing packet after driving from op_drv\n//%s",req.sprint()),UVM_LOW)
 

  seq_item_port.item_done();
  end
endtask

task send_to_dut(op_xtn xtn);
  
  while(vif.op_drv_cb.valid_out!==1)begin
  @(vif.op_drv_cb);
  end
  
  repeat(xtn.clock)
  @(vif.op_drv_cb);
  vif.op_drv_cb.read_enb <= 1;

  @(vif.op_drv_cb);

  while(vif.op_drv_cb.valid_out!==0)begin
  @(vif.op_drv_cb);
  end

  vif.op_drv_cb.read_enb <= 0;  
  @(vif.op_drv_cb);

 `uvm_info(get_type_name(),$sformatf("printing packet after driving from op_drv\n//%s",xtn.sprint()),UVM_LOW)
  
endtask

endclass
