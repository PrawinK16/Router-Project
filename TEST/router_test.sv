class router_test extends uvm_test;
	`uvm_component_utils(router_test)
  router_env router_envh;
  router_env_config router_env_cfg;
  router_ip_agt_config ip_agt_cfg[];
  router_op_agt_config op_agt_cfg[];
  router_vbase_seq v_seqs;
  bit has_ip_agent =1;
  bit has_op_agent = 1;
  int no_of_ip_agents = 1;
  int no_of_op_agents = 3;
  bit has_virtual_sequencer=1;
  
function new(string name = "router_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void config_router();
  //`uvm_info(get_type_name(),"In test",UVM_LOW)
  if(has_ip_agent)begin
    ip_agt_cfg = new[no_of_ip_agents];
    foreach(ip_agt_cfg[i])begin
    ip_agt_cfg[i] = router_ip_agt_config::type_id::create($sformatf("ip_agt_cfg[%0d]",i));
    if(!uvm_config_db#(virtual router_if)::get(this,"",$sformatf("ip_if%0d",i),ip_agt_cfg[i].vif))
      `uvm_fatal(get_type_name(),"didn't get() in test ip vif")
    ip_agt_cfg[i].is_active=UVM_ACTIVE;
    router_env_cfg.ip_agt_cfg[i]=ip_agt_cfg[i];
    end
  end

  if(has_op_agent)begin
    op_agt_cfg = new[no_of_op_agents];
    foreach(op_agt_cfg[i])begin
    op_agt_cfg[i] = router_op_agt_config::type_id::create($sformatf("op_agt_cfg[%0d]",i));
    if(!uvm_config_db#(virtual router_if)::get(this,"",$sformatf("op_if%0d",i),op_agt_cfg[i].vif))
      `uvm_fatal(get_type_name(),"didn't get() in test op vif")
    op_agt_cfg[i].is_active=UVM_ACTIVE;
    router_env_cfg.op_agt_cfg[i]=op_agt_cfg[i];    
    end
  end
  router_env_cfg.no_of_ip_agents = no_of_ip_agents;
  router_env_cfg.no_of_op_agents = no_of_op_agents;
  router_env_cfg.has_ip_agent = has_ip_agent;
  router_env_cfg.has_op_agent = has_op_agent;
  router_env_cfg.has_virtual_sequencer = has_virtual_sequencer;

endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  router_envh = router_env::type_id::create("router_envh",this);

  router_env_cfg = router_env_config::type_id::create("router_env_cfg");
  if(has_ip_agent)
  router_env_cfg.ip_agt_cfg = new[no_of_ip_agents];

  if(has_op_agent)
  router_env_cfg.op_agt_cfg = new[no_of_op_agents];

  config_router();
  uvm_config_db#(router_env_config)::set(this,"*","router_env_config",router_env_cfg);
		$display("======================env_config======================================",router_env_cfg);
endfunction

endclass




class small_packet_test extends router_test;
  `uvm_component_utils(small_packet_test)
  small_packet_vseq spkt_vseqh;
  
 // small_ipacket s_ipkth;
  //small_opacket s_opkth;
 // bit[1:0] addr;
function new(string name = "small_packet_test",uvm_component parent);
	super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
 
endfunction

task run_phase(uvm_phase phase);
  super.run_phase(phase);
router_env_cfg.addr =0;

 // s_ipkth = small_ipacket::type_id::create("s_ipkth");
  spkt_vseqh = small_packet_vseq::type_id::create("spkt_vseqh");
//
   // uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);
  phase.raise_objection(this);
//fork
  spkt_vseqh.start(router_envh.v_seqrh);
 // s_opkth.start(router_envh.v_seqrh);
//join
  #100;
  phase.drop_objection(this);

  
endtask
endclass




class medium_packet_test extends router_test;
  `uvm_component_utils(medium_packet_test)
  //medium_ipacket m_ipkth;
medium_packet_vseq mpkt_vseqh;
function new(string name = "medium_packet_test",uvm_component parent);
  super.new(name,parent);
endfunction

task run_phase(uvm_phase phase);
  super.run_phase(phase);
  mpkt_vseqh = medium_packet_vseq::type_id::create("mpkt_vseqh");
  router_env_cfg.addr=1;

 // uvm_config_db#(bit[1:0])::set(this,"*","addr",addr);
  phase.raise_objection(this);
  mpkt_vseqh.start(router_envh.v_seqrh);
#100;

  phase.drop_objection(this);
endtask
endclass



class big_packet_test extends router_test;
  `uvm_component_utils(big_packet_test)
  big_packet_vseq bpkt_vseqh;
 // bit[1:0]addr;

function new(string name = "big_packet_test",uvm_component parent);
  super.new(name,parent);
endfunction

task run_phase(uvm_phase phase);
  super.run_phase(phase);
  bpkt_vseqh = big_packet_vseq::type_id::create("bpkt_vseqh");
  router_env_cfg.addr=2;

  //uvm_config_db#(bit[1:0])::set(this,"*","addr",addr);
  phase.raise_objection(this);
  bpkt_vseqh.start(router_envh.v_seqrh);
  #100;

  phase.drop_objection(this);
endtask
endclass

class gbu_packet_test extends router_test;
  `uvm_component_utils(gbu_packet_test)
  gbu_packet_vseq gbupkt_vseqh;
  
  //bit[1:0]addr;
function new(string name = "gbu_packet_test",uvm_component parent);
  super.new(name,parent);
endfunction

task run_phase(uvm_phase phase);
  super.run_phase(phase);
  fork
  begin
  gbupkt_vseqh = gbu_packet_vseq::type_id::create("gbupkt_vseqh");
  router_env_cfg.addr=$random%3;

  //uvm_config_db#(bit[1:0])::set(this,"*","addr",addr);
  phase.raise_objection(this);
  gbupkt_vseqh.start(router_envh.v_seqrh);

  #100;
  phase.drop_objection(this);
  end

    join
endtask
endclass
