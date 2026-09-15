`timescale 1ns/1ps
module fifo_tb;
    localparam DW=8, DEPTH=8;
    logic clk=0, rst_n=0, wr_en=0, rd_en=0;
    logic [DW-1:0] data_in=0;
    wire [DW-1:0] data_out;
    wire full, empty;

    fifo #(.DATA_WIDTH(DW), .DEPTH(DEPTH)) dut (
        .clk(clk), .rst_n(rst_n), .wr_en(wr_en), .rd_en(rd_en),
        .data_in(data_in), .data_out(data_out), .full(full), .empty(empty)
    );

    always #5 clk = ~clk;

    task automatic write_fifo(input logic [DW-1:0] d);
        @(negedge clk);
        if (full) $fatal(1,"TB tried to write while full");
        data_in=d; wr_en=1; rd_en=0;
        @(negedge clk);
        wr_en=0;
        $display("[%0t] WRITE %02h", $time, d);
    endtask

    task automatic read_fifo(input logic [DW-1:0] exp);
        @(negedge clk);
        if (empty) $fatal(1,"TB tried to read while empty");
        rd_en=1; wr_en=0;
        @(posedge clk); #1;
        if (data_out !== exp)
            $error("[%0t] READ FAIL: expected %02h got %02h", $time, exp, data_out);
        else
            $display("[%0t] READ PASS: %02h", $time, data_out);
        @(negedge clk); rd_en=0;
    endtask

    initial begin
        $dumpfile("fifo.vcd"); $dumpvars(0,fifo_tb);
        repeat(2) @(posedge clk);
        rst_n=1;

        // Basic FIFO ordering
        write_fifo(8'h11);
        write_fifo(8'h22);
        write_fifo(8'h33);
        read_fifo(8'h11);
        read_fifo(8'h22);
        read_fifo(8'h33);

        // Fill to full
        for (int i=0;i<DEPTH;i++) write_fifo(8'hA0+i);
        if (!full) $error("FULL flag did not assert");
        @(negedge clk);
        wr_en=1; data_in=8'hFF;
        @(negedge clk); wr_en=0;
        if (!full) $error("FULL flag unexpectedly deasserted");

        // Empty again
        for (int i=0;i<DEPTH;i++) read_fifo(8'hA0+i);
        if (!empty) $error("EMPTY flag did not assert");

        // Wrap-around
        for (int i=0;i<4;i++) write_fifo(8'hC0+i);
        for (int i=0;i<4;i++) read_fifo(8'hC0+i);

        $display("SIMULATION COMPLETE");
        $finish;
    end
endmodule
