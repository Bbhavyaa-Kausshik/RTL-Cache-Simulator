module cache_2way #(
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

    // --------------------------------------------------
    // Parameters
    // --------------------------------------------------

    localparam CACHE_LINES = CACHE_SIZE / BLOCK_SIZE;
    localparam NUM_WAYS    = 2;
    localparam NUM_SETS    = CACHE_LINES / NUM_WAYS;

    localparam OFFSET_BITS = $clog2(BLOCK_SIZE);
    localparam INDEX_BITS  = $clog2(NUM_SETS);
    localparam TAG_BITS    = ADDRESS_WIDTH - INDEX_BITS - OFFSET_BITS;

    // --------------------------------------------------
    // Cache Storage
    // --------------------------------------------------

    logic valid [0:NUM_SETS-1][0:1];
    logic [TAG_BITS-1:0] tag_array [0:NUM_SETS-1][0:1];

    // FIFO replacement bit
    logic replace_way [0:NUM_SETS-1];

    // --------------------------------------------------
    // Address fields
    // --------------------------------------------------

    logic [TAG_BITS-1:0] tag;
    logic [INDEX_BITS-1:0] index;
    logic [OFFSET_BITS-1:0] offset;

    integer i;

    assign offset = address[OFFSET_BITS-1:0];

    assign index =
        address[OFFSET_BITS + INDEX_BITS -1 : OFFSET_BITS];

    assign tag =
        address[ADDRESS_WIDTH-1 : OFFSET_BITS + INDEX_BITS];

    // --------------------------------------------------
    // Cache Logic
    // --------------------------------------------------

    always_ff @(posedge clk or posedge rst)
    begin

        if(rst)
        begin

            hit  <= 0;
            miss <= 0;

            for(i=0;i<NUM_SETS;i=i+1)
            begin
                valid[i][0] <= 0;
                valid[i][1] <= 0;

                tag_array[i][0] <= 0;
                tag_array[i][1] <= 0;

                replace_way[i] <= 0;
            end

        end

        else
        begin

            // ----------------------------
            // Check Way 0
            // ----------------------------

            if(valid[index][0] &&
               tag_array[index][0] == tag)
            begin

                hit  <= 1;
                miss <= 0;

            end

            // ----------------------------
            // Check Way 1
            // ----------------------------

            else if(valid[index][1] &&
                    tag_array[index][1] == tag)
            begin

                hit  <= 1;
                miss <= 0;

            end

            // ----------------------------
            // Cache Miss
            // ----------------------------

            else
            begin

                hit  <= 0;
                miss <= 1;

                // Empty Way 0

                if(!valid[index][0])
                begin

                    valid[index][0] <= 1;
                    tag_array[index][0] <= tag;

                end

                // Empty Way 1

                else if(!valid[index][1])
                begin

                    valid[index][1] <= 1;
                    tag_array[index][1] <= tag;

                end

                // Both Full -> FIFO

                else
                begin

                    if(replace_way[index] == 0)
                    begin
                        tag_array[index][0] <= tag;
                        replace_way[index] <= 1;
                    end

                    else
                    begin
                        tag_array[index][1] <= tag;
                        replace_way[index] <= 0;
                    end

                end

            end

        end

    end

endmodule