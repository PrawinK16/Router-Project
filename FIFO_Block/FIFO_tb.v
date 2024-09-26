module fifo_tb();

    reg clk, rst, soft_rst, lfd_state, we, re;
    reg [8:0] data_in;
    wire [8:0] data_out;
    wire empty, full;

    // Instantiate the FIFO DUT
    fifo DUT (
        .clk(clk),
        .rst(rst),
        .re(re),
        .we(we),
        .soft_rst(soft_rst),
        .lfd_state(lfd_state),
        .data_in(data_in),
        .data_out(data_out),
        .empty(empty),
        .full(full)
    );
    
    // Generate clock
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk; // Clock period is 10 units
    end

    // Task to initialize signals
    task initialise;
    begin
        rst = 1'b1;
        soft_rst = 1'b0;
        we = 1'b0;
        re = 1'b0;
        lfd_state = 1'b0;
        data_in = 9'd0;
    end
    endtask

    // Task to reset the FIFO
    task reset;
    begin
        @(negedge clk) rst = 1'b0; // Assert reset active low
        @(negedge clk) rst = 1'b1; // Deassert reset
    end
    endtask

    // Task to perform soft reset
    task soft_reset;
    begin
        @(negedge clk) soft_rst = 1'b1; // Assert soft reset
        @(negedge clk) soft_rst = 1'b0; // Deassert soft reset
    end
    endtask

    // Task to write data into the FIFO
    task write;
        integer k;
        reg [7:0] payload_data, parity, header;
        reg [5:0] payload_len;
        reg [1:0] addr;
    begin
        @(negedge clk);
        payload_len = 6'd14;
        addr = 2'b01;
        header = {payload_len, addr};
        data_in = header;
        lfd_state = 1'b1;
        
        we = 1'b1;
        #100;
        for (k = 0; k <=payload_len; k = k + 1) begin
            @(negedge clk);
            lfd_state = 0;
            payload_data = {$random} % 256;
            data_in = payload_data;
        end
        
        @(negedge clk);
        parity = {$random} % 256;
        data_in = parity;
        we = 1'b0; // Stop writing after data is written
    end
    endtask
    
    
    
    task read_fifo;
begin
    while (!empty) begin
        @(negedge clk);  // Wait for a clock edge
        re = 1'b1;       // Assert read enable
             // Deassert read enable
        $display("Read data: %d", data_out);  // Print the read data
    end
end
endtask

    
    
    
   
   // Initial block for the simulation
    initial begin
        initialise;
        reset();
        soft_reset();
        
        // Write data into FIFO
        write;
        #100;
        
        repeat(8)begin
        read_fifo;
        
        end
        
        end
    // Monitor to print values of data_in and data_out
    initial begin
        $monitor("d_in = %d | d_out = %d", data_in, data_out);
    end

endmodule