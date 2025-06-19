class op_xtn extends uvm_sequence_item;
  `uvm_object_utils(op_xtn)
  bit [7:0] header;
  bit [7:0] payload[];
  bit [7:0] parity;
 // bit read_enb;
 
  rand bit [5:0]clock;
virtual function void do_print(uvm_printer printer);
  printer.print_field("Header",header,8,UVM_DEC);
  foreach(payload[i])
  printer.print_field($sformatf("Payload[%0d]",i),payload[i],8,UVM_DEC);

  printer.print_field("Parity",parity,8,UVM_DEC);
  //printer.print_field("valid_out",valid_out,1,UVM_DEC);

  printer.print_field("clock",clock,6,UVM_DEC);
  
endfunction
   

  /*`uvm_object_utils_begin(op_xtn)
    //`uvm_field_int(data_out,UVM_ALL_ON)
    `uvm_field_int(read_enb,UVM_ALL_ON)
    //`uvm_field_int(valid_out,UVM_ALL_ON)
  `uvm_object_utils_end*/

//constraint data_out_vld(data_out inside {[10:200]};)
//constraint read_enb_vld{read_enb dist{1:=20,0:=30};}

function new(string name = "op_xtn");
  super.new(name);
endfunction
endclass  
