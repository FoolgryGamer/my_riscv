`include "CPU.v"
`include "RAM.v"
`include "ROM.v"
`timescale 1ns / 100ps 

module tb_Main;
    reg clk;
    reg rst;

    wire [31:0] inst_addr;
    wire [31:0] inst;
    wire        inst_ce;

    wire        data_ce;
    wire        data_we;
    wire [31:0] data_addr;
    wire [31:0] wdata;
    wire [31:0] rdata;
    
    CPU riscv0 (
        .clk(clk),
        .rst(rst),

        .inst_addr_o(inst_addr),
        .inst_i     (inst),
        .inst_ce_o  (inst_ce),

        .data_ce_o  (data_ce),
        .data_we_o  (data_we),
        .data_addr_o(data_addr),
        .data_i     (rdata),
        .data_o     (wdata)
    );
    
    ROM rom(
        .ADDRESS(inst_addr),

        .DATA(inst)
    );

    RAM ram(
        .ADDRESS(data_addr),
        .DATA_IN(wdata),
        .WRITE_ENABLE(data_we),
        .CLK(clk),

        .DATA_OUT(rdata)    
    );

    initial begin
        clk = 1'b0;
        forever #50 clk = ~clk;
    end

    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, riscv_soc_tb);
    end

    initial begin
        rst = 1'b1;
        #300 rst = 1'b0;
        #10000 $display("---     result is %d         ---\n");
        #1000 $finish;
        // #1000   $stop;
    end
    
endmodule