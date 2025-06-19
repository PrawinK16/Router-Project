class router_op_mon extends uvm_monitor;
  `uvm_component_utils(router_op_mon)
  router_op_agt_config op_agt_cfg;
  virtual router_if vif;
  uvm_analysis_port #(op_xtn) monitor_port;

function new(string name = "router_op_mon",uvm_component parent);
  super.new(name,parent);
  monitor_port = new("monitor_port", this);

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
      collect_data();
    end
endtask

task collect_data();
  op_xtn data_rcvd;
  data_rcvd = op_xtn::type_id::create("data_rcvd");

while(vif.op_mon_cb.valid_out!==1)
  @(vif.op_mon_cb);
  while(vif.op_mon_cb.read_enb!==1)
  @(vif.op_mon_cb);

  @(vif.op_mon_cb);
  data_rcvd.header = vif.op_mon_cb.data_out;

  @(vif.op_mon_cb);
  data_rcvd.payload = new[data_rcvd.header[7:2]];  
  
  foreach(data_rcvd.payload[i])begin
  while(vif.op_mon_cb.valid_out!==1)
  @(vif.op_mon_cb);

    while(vif.op_mon_cb.read_enb!==1)
    @(vif.op_mon_cb);
   
  data_rcvd.payload[i] = vif.op_mon_cb.data_out;
   @(vif.op_mon_cb);
  end
  

  while(vif.op_mon_cb.read_enb!==1)
    @(vif.op_mon_cb);
  
  data_rcvd.parity = vif.op_mon_cb.data_out;
    @(vif.op_mon_cb);
    @(vif.op_mon_cb);
  monitor_port.write(data_rcvd);
 `uvm_info(get_type_name(),$sformatf("printing packet after monitor from op_mon \n//%s",data_rcvd.sprint()),UVM_LOW)
  
  
endtask
endclass
