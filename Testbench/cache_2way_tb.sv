`timescale 1ns/1ps

module cache_2way_tb;

    // Inputs
    logic clk;
    logic rst;
    logic [15:0] address;

    // Outputs
    logic hit;
    logic miss;

    // Instantiate DUT
    cache_2way uut (
        .clk(clk),
        .rst(rst),
        .address(address),
        .hit(hit),
        .miss(miss)
    );

    //--------------------------------------------------
    // Clock Generation
    //--------------------------------------------------

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //--------------------------------------------------
    // Test Sequence
    //--------------------------------------------------

    initial begin

        // Generate waveform
        $dumpfile("cache_2way.vcd");
        $dumpvars(0, cache_2way_tb);

        // Reset
        rst = 1;
        address = 16'h0000;

        #10;
        rst = 0;

        //--------------------------------------------------
        // Test 1
        // 1234 -> MISS
        //--------------------------------------------------

        address = 16'h1234;
        #10;
        $display("Addr=%h Hit=%b Miss=%b",address,hit,miss);

        //--------------------------------------------------
        // Test 2
        // 1234 -> HIT
        //--------------------------------------------------

        address = 16'h1234;
        #10;
        $display("Addr=%h Hit=%b Miss=%b",address,hit,miss);

        //--------------------------------------------------
        // Test 3
        // Same Set, Different Tag
        // 2234 -> MISS
        //--------------------------------------------------

        address = 16'h2234;
        #10;
        $display("Addr=%h Hit=%b Miss=%b",address,hit,miss);

        //--------------------------------------------------
        // Test 4
        // 2234 -> HIT
        //--------------------------------------------------

        address = 16'h2234;
        #10;
        $display("Addr=%h Hit=%b Miss=%b",address,hit,miss);

        //--------------------------------------------------
        // Test 5
        // 1234 should STILL HIT
        //--------------------------------------------------

        address = 16'h1234;
        #10;
        $display("Addr=%h Hit=%b Miss=%b",address,hit,miss);

        //--------------------------------------------------
        // Test 6
        // Third conflicting block
        // Forces FIFO replacement
        //--------------------------------------------------

        address = 16'h3234;
        #10;
        $display("Addr=%h Hit=%b Miss=%b",address,hit,miss);

        //--------------------------------------------------
        // Test 7
        // Check which block was replaced
        //--------------------------------------------------

        address = 16'h1234;
        #10;
        $display("Addr=%h Hit=%b Miss=%b",address,hit,miss);

        //--------------------------------------------------
        // Test 8
        //--------------------------------------------------

        address = 16'h2234;
        #10;
        $display("Addr=%h Hit=%b Miss=%b",address,hit,miss);

        //--------------------------------------------------
        // Test 9
        //--------------------------------------------------

        address = 16'h3234;
        #10;
        $display("Addr=%h Hit=%b Miss=%b",address,hit,miss);

        $finish;

    end

endmodule