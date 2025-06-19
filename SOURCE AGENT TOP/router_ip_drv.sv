class router_ip_drv extends uvm_driver#(ip_xtn);
  `uvm_component_utils(router_ip_drv)

  router_ip_agt_config ip_agt_cfg;
  virtual router_if vif;

function new(string name = "router_ip_drv",uvm_component parent);
  super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  if(!uvm_config_db#(router_ip_agt_config)::get(this,"","router_ip_agt_config",ip_agt_cfg))
    `uvm_fatal(get_type_name(),"didn't get ip_agt_cfg in ip_mon")
    
endfunction

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  vif = ip_agt_cfg.vif;
endfunction

task run_phase(uvm_phase phase);
  super.run_phase(phase);
  reset_dut();
  forever
  begin
  seq_item_port.get_next_item(req);
  //req.print();
  send_to_dut(req);
  seq_item_port.item_done();
  end
endtask


task reset_dut();
  @(vif.ip_drv_cb);
  vif.ip_drv_cb.rstn <= 0;
  
//  repeat(2)
  @(vif.ip_drv_cb);
  vif.ip_drv_cb.rstn <= 1;
endtask


task send_to_dut(ip_xtn xtn);
//  `uvm_info(get_type_name(),$sformatf("printing from driver before drive addr = %d\n %s", xtn.header[1:0],xtn.sprint()),UVM_LOW) 
 
 // reset_dut();
  
 while(vif.ip_drv_cb.busy!==0)begin
  
  @(vif.ip_drv_cb);
end
//`uvm_info(get_type_name(),"HIIIIIIIIIIIIIIIIIiii",UVM_LOW) 

  vif.ip_drv_cb.pkt_valid <= 1;
 
  vif.ip_drv_cb.din <= xtn.header;
  @(vif.ip_drv_cb);
  
  foreach(xtn.payload[i])begin
  while(vif.ip_drv_cb.busy!==0)begin
  @(vif.ip_drv_cb);end  
  vif.ip_drv_cb.din <= xtn.payload[i];
  @(vif.ip_drv_cb);
 end
//`uvm_info(get_type_name(),"BYEEEEEEEEEEEEEEEEEEEEEEEe",UVM_LOW) 

  while(vif.ip_drv_cb.busy!==0)begin 
  @(vif.ip_drv_cb);end
  vif.ip_drv_cb.pkt_valid <= 0;
  
  vif.ip_drv_cb.din <= xtn.parity;
 
 

  repeat(2)
   @(vif.ip_drv_cb);
  xtn.error = vif.ip_drv_cb.error;
  
   @(vif.ip_drv_cb);

  `uvm_info(get_type_name(),$sformatf("printing from driver after drive addr =%d \n %s",xtn.header[1:0], xtn.sprint()),UVM_LOW) 

endtask
endclass
