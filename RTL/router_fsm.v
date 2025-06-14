
module router_fsm(input clock,resetn,pkt_valid,parity_done,soft_reset_0,soft_reset_1,soft_reset_2,fifo_full,low_pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,input [1:0]data_in,output detect_add,busy,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state);
  parameter decode_address = 3'b000;
  parameter wait_till_empty = 3'b001;
  parameter load_first_data = 3'b010;
  parameter load_data = 3'b011;
  parameter load_parity = 3'b100;
  parameter fifo_full_state = 3'b101;
  parameter load_after_full = 3'b110;
  parameter check_parity_error = 3'b111;

  reg [2:0]ps,ns;
  reg [1:0]addr;

  always@(posedge clock)begin
    if(!resetn)
      addr<=2'b0;
    else if(detect_add)
      addr<=data_in;
  end

  always@(posedge clock)begin
    if(!resetn)
      ps<=decode_address;
    else if(((soft_reset_0)&&(data_in==2'b00))||((soft_reset_1)&&(data_in==2'b01))||((soft_reset_2)&&(data_in==2'b10)))
      ps<=decode_address;
    else
      ps<=ns;
  end

always@(*)begin    case(ps)
      decode_address:        begin
          if((pkt_valid && (data_in==2'b00) && fifo_empty_0)||(pkt_valid && (data_in==2'b01) && fifo_empty_1)||(pkt_valid && (data_in==2'b10) && fifo_empty_2))            ns=load_first_data;
          else if((pkt_valid && (data_in==2'b00) && !fifo_empty_0)||(pkt_valid && (data_in==2'b01) && !fifo_empty_1)||(pkt_valid && (data_in==2'b10) && !fifo_empty_2))
            ns=wait_till_empty;     
          else
            ns=decode_address;   
      end
       load_first_data:         begin
           ns=load_data;         end
       wait_till_empty:       begin 
         if((fifo_empty_0 && (addr==2'b00))||(fifo_empty_1 && (addr==2'b01))||(fifo_empty_2 && (addr==2'b10)))
             ns=load_first_data;           else
             ns=wait_till_empty;         end
       load_data:
         begin           if(fifo_full==1'b1)
             ns=fifo_full_state;                                                                                                  
else if(!fifo_full && !pkt_valid)             ns=load_parity;
           else             ns=load_data;
         end
        fifo_full_state:          begin
            if(fifo_full==1'b0)              ns=load_after_full;
            else              ns=fifo_full_state;
          end
         load_after_full:
           begin             if(!parity_done && low_pkt_valid)
               ns=load_parity;             else if(!parity_done && !low_pkt_valid)
               ns=load_data;             else if(parity_done==1'b1)
               ns=decode_address;             else
               ns=load_after_full;           end
         load_parity:
           begin             ns=check_parity_error;
           end
check_parity_error:            begin
              if(!fifo_full)                ns=decode_address;
              else                ns=fifo_full_state;
            end
          default:            ns=decode_address;
      endcase
    end
  assign busy=((ps==load_first_data)||(ps==load_parity)||(ps==fifo_full_state)||(ps==load_after_full)||(ps==wait_till_empty)||(ps==check_parity_error))?1'b1:1'b0;
  assign detect_add=(ps==decode_address)? 1'b1:1'b0;
  assign lfd_state=(ps==load_first_data)? 1'b1:1'b0;  assign ld_state=(ps==load_data)?  1'b1:1'b0;
  assign write_enb_reg=((ps==load_data)||(ps==load_after_full)||(ps==load_parity))? 1'b1:1'b0; 
  assign full_state=(ps==fifo_full_state)? 1'b1:1'b0;
  assign laf_state=(ps==load_after_full)? 1'b1:1'b0;  assign rst_int_reg=(ps==check_parity_error)? 1'b1:1'b0;
endmodule
