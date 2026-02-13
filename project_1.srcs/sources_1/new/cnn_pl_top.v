`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.02.2026 09:10:01
// Design Name: 
// Module Name: cnn_pl_top
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

module cnn_pl_top(
    input  wire clk,
    input  wire rst_btn,
    output wire [3:0] led
);

    reg [7:0] pixel_data = 0;
    reg valid_in = 0;
    reg [9:0] counter = 0;

    wire [3:0] decision;
    wire valid_out;

    // Simple fake pixel generator
    always @(posedge clk) begin
        if (!rst_btn) begin
            counter <= 0;
            valid_in <= 0;
        end else begin
            counter <= counter + 1;
            pixel_data <= counter[7:0];
            valid_in <= 1;
        end
    end

    cnn_top cnn_core (
        .clk       (clk),
        .rst_n     (rst_btn),
        .valid_in  (valid_in),
        .data_in   (pixel_data),
        .decision  (decision),
        .valid_out (valid_out)
    );

    assign led = decision;

endmodule

