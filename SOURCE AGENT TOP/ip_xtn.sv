class ip_xtn extends uvm_sequence_item;
  `uvm_object_utils(ip_xtn)
  
  rand bit [7:0]header;
  rand bit [7:0] payload[];
  bit error;
  bit[7:0] parity;
  bit busy;
  
 /* `uvm_object_utils_begin(ip_xtn)
    `uvm_field_int(header,UVM_ALL_ON)
    `uvm_field_array_int(payload,UVM_ALL_ON)
    `uvm_field_int(parity,UVM_ALL_ON)
    `uvm_field_int(error,UVM_ALL_ON)
  `uvm_object_utils_end
*/
virtual function void do_print(uvm_printer printer);
  printer.print_field("Header",header,8,UVM_DEC);
  foreach(payload[i])begin
  printer.print_field($sformatf("Payload[%0d]",i),payload[i],8,UVM_DEC);
  end
  printer.print_field("Parity",parity,8,UVM_DEC);
  printer.print_field("Error",error,1,UVM_DEC);
  printer.print_field("Busy",busy,1,UVM_DEC);
  
endfunction

constraint header_vld{header[1:0] != 2'b11;}
constraint payload_value{header[7:2] != 0;}
constraint payload_length{payload.size == header[7:2];}


function new(string name = "ip_xtn");
  super.new(name);
endfunction

function void post_randomize();
  parity = parity ^ header;
  foreach(payload[i])begin
    parity = parity ^ payload[i];
  end  
endfunction
endclass 

class ip1_xtn extends ip_xtn;
  `uvm_object_utils(ip1_xtn)
function new (string name = "ip1_xtn");
  super.new(name);
endfunction

/*function void post_randomize();
  parity =header;
  foreach(payload[i])begin
    parity = parity+100;
  end
endfunction*/
endclass
