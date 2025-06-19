class router_ip_mon extends uvm_monitor;
  `uvm_component_utils(router_ip_mon)
  router_ip_agt_config ip_agt_cfg;
  virtual router_if vif;
  uvm_analysis_port #(ip_xtn) monitor_port;

function new(string name = "router_ip_mon",uvm_component parent);
  super.new(name,parent);
  monitor_port = new("monitor_port", this);

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
  forever
  begin
    collect_data();
  end
endtask

task collect_data();
  ip_xtn data_sent;
  
  data_sent = ip_xtn::type_id::create("data_sent");

  @(vif.ip_mon_cb);
while(vif.ip_mon_cb.pkt_valid !== 1)begin
  @(vif.ip_mon_cb); end
  
while(vif.ip_mon_cb.busy !== 0)begin
  @(vif.ip_mon_cb); end

  //@(vif.ip_mon_cb);

  data_sent.header = vif.ip_mon_cb.din;
  @(vif.ip_mon_cb);

   data_sent.payload = new[data_sent.header[7:2]];
  
  //`uvm_info(get_type_name(),$sformatf("printing from driver before drive\n %s", data_sent.sprint()),UVM_LOW) 
  

     foreach(data_sent.payload[i])begin
     while(vif.ip_mon_cb.busy !== 0)
  @(vif.ip_mon_cb); 

  while(vif.ip_mon_cb.pkt_valid !==1)begin
  @(vif.ip_mon_cb); end


    data_sent.payload[i] = vif.ip_mon_cb.din;
    @(vif.ip_mon_cb);
    
  end

 // @(vif.ip_mon_cb);
while(vif.ip_mon_cb.pkt_valid !==0)begin
  @(vif.ip_mon_cb); end
  

  while(vif.ip_mon_cb.busy !==0)begin
  @(vif.ip_mon_cb);
    end
data_sent.parity = vif.ip_mon_cb.din;

  @(vif.ip_mon_cb);
  
  @(vif.ip_mon_cb);

  data_sent.error = vif.ip_mon_cb.error;

  monitor_port.write(data_sent);

  `uvm_info(get_type_name(),$sformatf("printing from monitor after sample addr = %d\n %s",data_sent.header[1:0], data_sent.sprint()),UVM_LOW) 

    
  
    
endtask
endclass
