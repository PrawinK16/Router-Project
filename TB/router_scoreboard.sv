class router_scoreboard extends uvm_scoreboard;
  `uvm_component_utils(router_scoreboard)
        uvm_tlm_analysis_fifo #(ip_xtn) fifo_iph[];
        uvm_tlm_analysis_fifo #(op_xtn) fifo_oph[];
  router_env_config router_env_cfg;
 
  ip_xtn ixtn;
  op_xtn oxtn;

covergroup cg1;
option.per_instance=1;

HEADER : coverpoint ixtn.header[1:0]{
					bins h1={2'b00};
					bins h2={2'b01};
					bins h3={2'b10};
					}
PAYLOAD : coverpoint ixtn.header[7:2]{
					bins p1={[1:14]};
					bins p2={[15:30]};
					bins p3={[31:63]};
					}
endgroup

covergroup cg2;
option.per_instance=1;
HEADER1 : coverpoint oxtn.header[1:0]{
					bins ho1={2'b00};
					bins ho2={2'b01};
					bins ho3={2'b10};
					}
PAYLOAD1 : coverpoint oxtn.header[7:2]{
					bins po1={[1:14]};
					bins po2={[15:30]};
					bins po3={[31:63]};
					}

endgroup

function new(string name = "router_scoreboard", uvm_component parent);
  super.new(name,parent);
  	cg1=new();
	cg2 = new();
endfunction

function void build_phase(uvm_phase phase);
   if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",router_env_cfg))
    `uvm_fatal(get_type_name(),"didn' get env config in env")
  
  ixtn = ip_xtn::type_id::create("ixtn",this);
  oxtn = op_xtn::type_id::create("oxtn",this);

  fifo_iph = new[router_env_cfg.no_of_ip_agents];
  fifo_oph = new[router_env_cfg.no_of_op_agents];
  
 foreach(fifo_iph[i])
  fifo_iph[i] = new($sformatf("fifo_iph[%0d]",i), this);


  foreach(fifo_oph[i])
  fifo_oph[i] = new($sformatf("fifo_oph[%0d]",i), this);

endfunction

task run_phase(uvm_phase phase);
  super.run_phase(phase);
  forever
  begin
  fork
    begin
     fifo_iph[0].get(ixtn);
     `uvm_info(get_type_name(),"successfully got in fifoiph",UVM_LOW)
     cg1.sample();
    end
    begin
      fork
	begin
	   fifo_oph[0].get(oxtn);
           `uvm_info(get_type_name(),"successfully got in fifooph0",UVM_LOW)
	   cg2.sample();
	end
	begin
	   fifo_oph[1].get(oxtn);
           `uvm_info(get_type_name(),"successfully got in fifooph1",UVM_LOW)
	   cg2.sample();

	end
	begin
	   fifo_oph[2].get(oxtn);
           `uvm_info(get_type_name(),"successfully got in fifooph2",UVM_LOW)
	   cg2.sample();

	end

      join_any
      disable fork;
    end
  join
  
  compare(ixtn,oxtn);
end
endtask


task compare(ip_xtn ixtn, op_xtn oxtn);
if(oxtn.header == ixtn.header)
  `uvm_info(get_type_name(),"successfull",UVM_LOW)
else
  `uvm_error(get_type_name(),"Failed")

if(oxtn.payload == ixtn.payload)
  `uvm_info(get_type_name(),"successfull",UVM_LOW)
else
  `uvm_error(get_type_name(),"Failed")



if(oxtn.parity == ixtn.parity)
  `uvm_info(get_type_name(),"successfull",UVM_LOW)
else
  `uvm_error(get_type_name(),"Failed")


endtask
endclass
