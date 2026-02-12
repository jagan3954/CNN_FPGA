`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2026 08:31:37
// Design Name: 
// Module Name: comparator
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


module fully_connected #(
    parameter FEATURE_COUNT = 64,      // <-- change to your flattened feature size
    parameter DATA_WIDTH    = 12,
    parameter WEIGHT_WIDTH  = 8,
    parameter ACC_WIDTH     = 24
)(
    input clk,
    input rst_n,
    input valid_in,
    input signed [DATA_WIDTH-1:0] feature_in,

    output reg valid_out,
    output reg signed [ACC_WIDTH-1:0] fc_out_data [0:9]
);

    reg signed [ACC_WIDTH-1:0] acc [0:9];
    reg [15:0] feature_counter;

    // Example weight ROM (replace with your trained weights)
    reg signed [WEIGHT_WIDTH-1:0] weight [0:9][0:FEATURE_COUNT-1];

    integer i;

    initial begin
        // You must load trained weights here
        // Example:
        // $readmemh("fc_weights_class0.txt", weight[0]);
        // ...
    end

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            feature_counter <= 0;
            valid_out <= 0;
            for (i=0; i<10; i=i+1) begin
                acc[i] <= 0;
                fc_out_data[i] <= 0;
            end
        end
        else begin
            valid_out <= 0;

            if (valid_in) begin
                for (i=0; i<10; i=i+1) begin
                    acc[i] <= acc[i] + feature_in * weight[i][feature_counter];
                end

                if (feature_counter == FEATURE_COUNT-1) begin
                    for (i=0; i<10; i=i+1)
                        fc_out_data[i] <= acc[i];

                    feature_counter <= 0;
                    valid_out <= 1;

                    for (i=0; i<10; i=i+1)
                        acc[i] <= 0;
                end
                else begin
                    feature_counter <= feature_counter + 1;
                end
            end
        end
    end

endmodule
