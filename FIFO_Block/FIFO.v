`timescale 1ns / 1ps

module fifo(input clk, rst, soft_rst, we, re,lfd_state,
            input [8:0] data_in,
            output full, empty,
            output reg [8:0] data_out
            );

reg [4:0] wr_pt;
reg lfd_state_s;
reg [4:0] rd_pt;
reg [6:0] fifo_counter;

// memory allocation for ram
reg [8:0] mem[15:0];
integer i;

// full and empty block
assign full = (wr_pt[4] !== rd_pt[4]) && (wr_pt[3:0] == rd_pt[3:0]) ? 1'b1 : 1'b0;
assign empty = (wr_pt == rd_pt) ? 1'b1 : 1'b0;

// pointer block
always @(posedge clk)
begin
    if (!rst) 
    begin
        rd_pt <= 5'd0;
        wr_pt <= 5'd0;
    end
    else if (soft_rst)  
    begin
        rd_pt <= 5'd0;
        wr_pt <= 5'd0;
    end
    else
    begin
       //read
        if (re && !empty)
            rd_pt <= rd_pt + 1'b1;

        // Write 
        if (we && !full)
            wr_pt <= wr_pt + 1'b1;
    end
end

// delayed logic for lfd_state 
always @(posedge clk)
begin
    if (!rst)
        lfd_state_s <= 0;
    else
        lfd_state_s<= lfd_state; 
end

// write block
always @(posedge clk)
begin
    if (!rst)
        for (i = 0; i < 16; i = i + 1) 
            mem[i] <= 9'd0;
    else if (soft_rst)
        for (i = 0; i < 16; i = i + 1)  
            mem[i] <= 9'd0;
    else if (we && !full)
        mem[wr_pt[3:0]] <= {lfd_state, data_in};  
end

// read block
always @(posedge clk)
begin
    if (!rst)
        data_out <= 9'd0;
    else if (soft_rst)
        data_out <= 9'd0;
    else if (re && !empty)
        data_out <= mem[rd_pt[3:0]];  
end

// fifo counter block
always @(posedge clk)
begin
    if (!rst)
        fifo_counter <= 7'd0;
    else if (soft_rst)
        fifo_counter <= 7'd0;
    else if (re && !empty)
    begin
        if (mem[rd_pt[3:0]][8] == 1)  // Header byte detection
            fifo_counter <= mem[rd_pt[3:0]][7:2] + 1'b1;
        else if (fifo_counter != 0)
            fifo_counter <= fifo_counter - 1'b1;
    end
end

endmodule
