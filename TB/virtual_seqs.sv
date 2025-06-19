class router_vbase_seq extends uvm_sequence #(uvm_sequence_item);
  `uvm_object_utils(router_vbase_seq)
  router_virtual_sequencer v_seqrh;
  router_ip_sequencer ip_seqrh[];
  router_op_sequencer op_seqrh[];
  small_ipacket  ip_spkt_seqsh;
  small_opacket  op_spkt_seqsh;

  medium_ipacket  ip_mpkt_seqsh;
  big_ipacket  ip_bpkt_seqsh;
  gbu_ipacket  ip_gbupkt_seqsh;
  router_env_config router_env_cfg;
  
function new(string name = "router_vbase_seq");
  super.new(name);
endfunction 

task body();
  if(!uvm_config_db#(router_env_config)::get(null,get_full_name(),"router_env_config",router_env_cfg))
    `uvm_fatal(get_type_name(),"didn't get env_cfg in vbase_seqs")
   //$display("================v_seq  ===================================",router_env_cfg);
  ip_seqrh = new[router_env_cfg.no_of_ip_agents];
  op_seqrh = new[router_env_cfg.no_of_op_agents];
  
  assert($cast(v_seqrh,m_sequencer))
      `uvm_info(get_type_name()," in $cast of body opf vbase_seqs",UVM_LOW)
	
  else
    begin
      `uvm_error(get_type_name(),"error in $cast of body opf vbase_seqs")
    end

  foreach(ip_seqrh[i])
    ip_seqrh[i] = v_seqrh.ip_seqrh[i];

  foreach(op_seqrh[i])
    op_seqrh[i] = v_seqrh.op_seqrh[i];

endtask


endclass  

class small_packet_vseq extends router_vbase_seq;
  `uvm_object_utils(small_packet_vseq)
function new(string name = "small_packet_vseq");
  super.new(name);
endfunction 
task body();
 super.body();
  ip_spkt_seqsh = small_ipacket::type_id::create("ip_spkt_seqsh");
  op_spkt_seqsh = small_opacket::type_id::create("op_spkt_seqsh");
//  for(int i=0;i<router_env_cfg.no_of_ip_agents;i++)begin
  fork
    ip_spkt_seqsh.start(ip_seqrh[0]);
//  end

    op_spkt_seqsh.start(op_seqrh[router_env_cfg.addr]);
  join
endtask
endclass

class medium_packet_vseq extends router_vbase_seq;
  `uvm_object_utils(medium_packet_vseq)
function new(string name = "medium_packet_vseq");
  super.new(name);
endfunction 
task body();
 super.body();

  ip_mpkt_seqsh = medium_ipacket::type_id::create("ip_mpkt_seqsh");
  op_spkt_seqsh = small_opacket::type_id::create("op_spkt_seqsh");
fork
  //op_mpkt_seqsh = medium_opacket::type_id::create("op_mpkt_seqsh");
      ip_mpkt_seqsh.start(ip_seqrh[0]);
op_spkt_seqsh.start(op_seqrh[router_env_cfg.addr]);
  join

  

  /*for(int i=0;i<router_env_cfg.no_of_op_agents;i++)begin
    op_mpkt_seqsh.start(op_seqrh[i]);
  end*/
endtask
endclass

class big_packet_vseq extends router_vbase_seq;
  `uvm_object_utils(big_packet_vseq)
function new(string name = "big_packet_vseq");
  super.new(name);
endfunction 
task body();
 super.body();

  ip_bpkt_seqsh = big_ipacket::type_id::create("ip_bpkt_seqsh");
  op_spkt_seqsh = small_opacket::type_id::create("op_spkt_seqsh");
fork
  //for(int i=0;i<router_env_cfg.no_of_ip_agents;i++)begin
    ip_bpkt_seqsh.start(ip_seqrh[0]);
op_spkt_seqsh.start(op_seqrh[router_env_cfg.addr]);
  join

  //end

  endtask
endclass

class gbu_packet_vseq extends router_vbase_seq;
  `uvm_object_utils(gbu_packet_vseq)
function new(string name = "gbu_packet_vseq");
  super.new(name);
endfunction 
task body();
 super.body();

  ip_gbupkt_seqsh = gbu_ipacket::type_id::create("ip_gbupkt_seqsh");
  op_spkt_seqsh = small_opacket::type_id::create("op_spkt_seqsh");
fork
 // for(int i=0;i<router_env_cfg.no_of_ip_agents;i++)begin
    ip_gbupkt_seqsh.start(ip_seqrh[0]);
op_spkt_seqsh.start(op_seqrh[router_env_cfg.addr]);
  join

 // end

  endtask

endclass
