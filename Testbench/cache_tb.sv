`timescale 1ns/1ps

module cache_tb;

    // Inputs to the cache
    logic clk;
    logic rst;
    logic [15:0] address;

    // Outputs from the cache
    logic hit;
    logic miss;

    // Instantiate the cache
    cache uut (
        .clk(clk),
        .rst(rst),
        .address(address),
        .hit(hit),
        .miss(miss)
    );

    // Clock generation (10 ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Test sequence
    initial begin

        // Generate waveform file
        $dumpfile("cache.vcd");
        $dumpvars(0, cache_tb);

        // Initialize
        rst = 1;
        address = 16'h0000;

        // Hold reset for one clock cycle
        #10;
        rst = 0;

        // -------------------------------
        // Test 1 : First access
        // Expected : MISS
        // -------------------------------
        address = 16'h1234;
        #10;
        $display("Address = %h | Hit = %b | Miss = %b", address, hit, miss);

        // -------------------------------
        // Test 2 : Same address
        // Expected : HIT
        // -------------------------------
        address = 16'h1234;
        #10;
        $display("Address = %h | Hit = %b | Miss = %b", address, hit, miss);

        // -------------------------------
        // Test 3 : Different address
        // Expected : MISS
        // -------------------------------
        address = 16'h5678;
        #10;
        $display("Address = %h | Hit = %b | Miss = %b", address, hit, miss);

        // -------------------------------
        // Test 4 : Same address again
        // Expected : HIT
        // -------------------------------
        address = 16'h5678;
        #10;
        $display("Address = %h | Hit = %b | Miss = %b", address, hit, miss);

        // -------------------------------
        // Test 5 : Original address
        // May be HIT or MISS depending on
        // whether it maps to same cache line
        // -------------------------------
        address = 16'h1234;
        #10;
        $display("Address = %h | Hit = %b | Miss = %b", address, hit, miss);

        $finish;

    end

endmodule