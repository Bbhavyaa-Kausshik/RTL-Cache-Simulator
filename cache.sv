module cache #(
    parameter ADDRESS_WIDTH = 16,
    parameter CACHE_SIZE    = 4096,
    parameter BLOCK_SIZE    = 16
)(
    input  logic                     clk,
    input  logic                     rst,
    input  logic [ADDRESS_WIDTH-1:0] address,

    output logic hit,
    output logic miss
);

    // ------------------------------------------------------------
    // Cache Parameters
    // ------------------------------------------------------------

    localparam CACHE_LINES = CACHE_SIZE / BLOCK_SIZE;
    localparam OFFSET_BITS = $clog2(BLOCK_SIZE);
    localparam INDEX_BITS  = $clog2(CACHE_LINES);
    localparam TAG_BITS    = ADDRESS_WIDTH - INDEX_BITS - OFFSET_BITS;

    // ------------------------------------------------------------
    // Cache Storage
    // ------------------------------------------------------------

    logic valid [0:CACHE_LINES-1];
    logic [TAG_BITS-1:0] tag_array [0:CACHE_LINES-1];

    // ------------------------------------------------------------
    // Address Fields
    // ------------------------------------------------------------

    logic [TAG_BITS-1:0] tag;
    logic [INDEX_BITS-1:0] index;
    logic [OFFSET_BITS-1:0] offset;

    integer i;

    // ------------------------------------------------------------
    // Address Decoder
    // ------------------------------------------------------------

    assign offset = address[OFFSET_BITS-1:0];

    assign index =
        address[OFFSET_BITS + INDEX_BITS - 1 : OFFSET_BITS];

    assign tag =
        address[ADDRESS_WIDTH-1 : OFFSET_BITS + INDEX_BITS];

    // ------------------------------------------------------------
    // Cache Operation
    // ------------------------------------------------------------

    always_ff @(posedge clk or posedge rst)
    begin

        // Reset cache

        if (rst)
        begin
            hit  <= 0;
            miss <= 0;

            for(i=0; i<CACHE_LINES; i=i+1)
            begin
                valid[i] <= 0;
                tag_array[i] <= 0;
            end
        end

        else
        begin

            // Check for hit

            if(valid[index] && (tag_array[index] == tag))
            begin
                hit  <= 1;
                miss <= 0;
            end

            else
            begin

                hit  <= 0;
                miss <= 1;

                // Update cache

                valid[index] <= 1;
                tag_array[index] <= tag;

            end

        end

    end

endmodule