`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.02.2026 09:51:43
// Design Name: 
// Module Name: cnn_fpga_tb_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module cnn_fpga_top(
    input  wire clk,
    input  wire rst_n,
    input  wire [7:0] sw,     // switches as fake pixel input
    output wire [3:0] led
);

wire [3:0] decision;
wire valid_out;

cnn_top cnn_core (
    .clk(clk),
    .rst_n(rst_n),
    .valid_in(1'b1),     // always valid for now
    .data_in(sw),        // using switches as input
    .decision(decision),
    .valid_out(valid_out)
);

// Show decision on LEDs
assign led = decision;

endmodule


