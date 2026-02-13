module cnn_axis_wrapper (
    input  wire        s_axis_aclk,
    input  wire        s_axis_aresetn,
    input  wire [7:0]  s_axis_tdata,
    input  wire        s_axis_tvalid,
    output wire        s_axis_tready,
    input  wire        s_axis_tlast,

    output wire [3:0]  decision,
    output wire        valid_out
);

assign s_axis_tready = 1'b1;

cnn_top cnn_core (
    .clk       (s_axis_aclk),
    .rst_n     (s_axis_aresetn),
    .valid_in  (s_axis_tvalid),
    .data_in   (s_axis_tdata),
    .decision  (decision),
    .valid_out (valid_out)
);

endmodule
