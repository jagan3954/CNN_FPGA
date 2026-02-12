`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12.02.2026 08:15:53
// Design Name: 
// Module Name: CNN_top
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

module cnn_top(
    input clk,
    input rst_n,
    input valid_in,
    input [7:0] data_in,

    output [3:0] decision,
    output valid_out
);

wire signed [11:0] conv_out_1, conv_out_2, conv_out_3;
wire signed [11:0] conv2_out_1, conv2_out_2, conv2_out_3;
wire signed [11:0] max_value_1, max_value_2, max_value_3;
wire signed [11:0] max2_value_1, max2_value_2, max2_value_3;
wire signed [11:0] fc_out_data;

wire valid_out_1, valid_out_2, valid_out_3;
wire valid_out_4, valid_out_5;

// Conv1
conv1_layer conv1_layer(
  .clk(clk),
  .rst_n(rst_n),
  .data_in(data_in),
  .conv_out_1(conv_out_1),
  .conv_out_2(conv_out_2),
  .conv_out_3(conv_out_3),
  .valid_out_conv(valid_out_1)
);

// Pool1
maxpool_relu #(.CONV_BIT(12), .HALF_WIDTH(12), .HALF_HEIGHT(12), .HALF_WIDTH_BIT(4))
maxpool_relu_1(
  .clk(clk),
  .rst_n(rst_n),
  .valid_in(valid_out_1),
  .conv_out_1(conv_out_1),
  .conv_out_2(conv_out_2),
  .conv_out_3(conv_out_3),
  .max_value_1(max_value_1),
  .max_value_2(max_value_2),
  .max_value_3(max_value_3),
  .valid_out_relu(valid_out_2)
);

// Conv2
conv2_layer conv2_layer(
  .clk(clk),
  .rst_n(rst_n),
  .valid_in(valid_out_2),
  .max_value_1(max_value_1),
  .max_value_2(max_value_2),
  .max_value_3(max_value_3),
  .conv2_out_1(conv2_out_1),
  .conv2_out_2(conv2_out_2),
  .conv2_out_3(conv2_out_3),
  .valid_out_conv2(valid_out_3)
);

// Pool2
maxpool_relu #(.CONV_BIT(12), .HALF_WIDTH(4), .HALF_HEIGHT(4), .HALF_WIDTH_BIT(3))
maxpool_relu_2(
  .clk(clk),
  .rst_n(rst_n),
  .valid_in(valid_out_3),
  .conv_out_1(conv2_out_1),
  .conv_out_2(conv2_out_2),
  .conv_out_3(conv2_out_3),
  .max_value_1(max2_value_1),
  .max_value_2(max2_value_2),
  .max_value_3(max2_value_3),
  .valid_out_relu(valid_out_4)
);

// Fully Connected
fully_connected #(.INPUT_NUM(48), .OUTPUT_NUM(10), .DATA_BITS(8))
fully_connected(
  .clk(clk),
  .rst_n(rst_n),
  .valid_in(valid_out_4),
  .data_in_1(max2_value_1),
  .data_in_2(max2_value_2),
  .data_in_3(max2_value_3),
  .data_out(fc_out_data),
  .valid_out_fc(valid_out_5)
);

// Comparator
comparator comparator(
  .clk(clk),
  .rst_n(rst_n),
  .valid_in(valid_out_5),
  .data_in(fc_out_data),
  .decision(decision),
  .valid_out(valid_out)
);

endmodule
