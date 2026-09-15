`timescale 1ns/1ps
module fifo #(
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 8
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

    localparam PTR_WIDTH = $clog2(DEPTH);
    localparam COUNT_WIDTH = $clog2(DEPTH+1);

    reg [DATA_WIDTH-1:0] mem [0:DEPTH-1];
    reg [PTR_WIDTH-1:0] wr_ptr;
    reg [PTR_WIDTH-1:0] rd_ptr;
    reg [COUNT_WIDTH-1:0] count;

    wire do_write = wr_en && !full;
    wire do_read  = rd_en && !empty;

    assign full  = (count == DEPTH-1);
    assign empty = (count == 0);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr   <= '0;
            rd_ptr   <= '0;
            count    <= '0;
            data_out <= '0;
        end else begin
            if (do_write) begin
                mem[wr_ptr] <= data_in;
                if (wr_ptr == DEPTH-1)
                    wr_ptr <= '0;
                else
                    wr_ptr <= wr_ptr + 1'b1;
            end

            if (do_read) begin
                data_out <= mem[rd_ptr];
                if (rd_ptr == DEPTH-1)
                    rd_ptr <= '0;
                else
                    rd_ptr <= rd_ptr + 1'b1;
            end

            case ({do_write, do_read})
                2'b10: count <= count + 1'b1;
                2'b01: count <= count - 1'b1;
                default: count <= count;
            endcase
        end
    end
endmodule
