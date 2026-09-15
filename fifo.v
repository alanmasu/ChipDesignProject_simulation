`timescale 1ns/1ps

module fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH      = 8
) (
    input  wire                  clk,
    input  wire                  rst_n,

    input  wire                  wr_en,
    input  wire                  rd_en,
    input  wire [DATA_WIDTH-1:0] data_in,

    output reg  [DATA_WIDTH-1:0] data_out,
    output wire                  full,
    output wire                  empty
);

    // ------------------------------------------------------------
    // Internal parameters
    // ------------------------------------------------------------

    localparam PTR_WIDTH   = $clog2(DEPTH);
    localparam COUNT_WIDTH = $clog2(DEPTH + 1);

    // ------------------------------------------------------------
    // FIFO storage and state
    // ------------------------------------------------------------

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];

    reg [PTR_WIDTH-1:0]   wr_ptr;
    reg [PTR_WIDTH-1:0]   rd_ptr;
    reg [COUNT_WIDTH-1:0] count;

    // ------------------------------------------------------------
    // Accepted operations
    //
    // A write is accepted only when the FIFO is not full.
    // A read is accepted only when the FIFO is not empty.
    // ------------------------------------------------------------

    wire do_write;
    wire do_read;

    assign do_write = wr_en && !full;
    assign do_read  = rd_en && !empty;

    // ------------------------------------------------------------
    // Status flags
    // ------------------------------------------------------------

    assign full  = (count == DEPTH);
    assign empty = (count == 0);

    // ------------------------------------------------------------
    // Sequential logic
    // ------------------------------------------------------------

    always @(posedge clk or negedge rst_n) begin

        if (!rst_n) begin

            wr_ptr   <= {PTR_WIDTH{1'b0}};
            rd_ptr   <= {PTR_WIDTH{1'b0}};
            count    <= {COUNT_WIDTH{1'b0}};
            data_out <= {DATA_WIDTH{1'b0}};

        end
        else begin

            // ----------------------------------------------------
            // Write operation
            // ----------------------------------------------------

            if (do_write) begin

                mem[wr_ptr] <= data_in;

                // Circular write pointer
                if (wr_ptr == DEPTH-1)
                    wr_ptr <= {PTR_WIDTH{1'b0}};
                else
                    wr_ptr <= wr_ptr + 1'b1;

            end

            // ----------------------------------------------------
            // Read operation
            // ----------------------------------------------------

            if (do_read) begin

                data_out <= mem[rd_ptr];

                // Circular read pointer
                if (rd_ptr == DEPTH-1)
                    rd_ptr <= {PTR_WIDTH{1'b0}};
                else
                    rd_ptr <= rd_ptr + 1'b1;

            end

            // ----------------------------------------------------
            // FIFO occupancy
            //
            // Write only       -> count + 1
            // Read only        -> count - 1
            // Read and write   -> unchanged
            // Neither          -> unchanged
            // ----------------------------------------------------

            case ({do_write, do_read})

                2'b10: count <= count + 1'b1;

                2'b01: count <= count - 1'b1;

                2'b11: count <= count;

                2'b00: count <= count;

            endcase

        end

    end

endmodule