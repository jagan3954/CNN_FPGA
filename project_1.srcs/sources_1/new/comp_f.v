/*------------------------------------------------------------------------
 *
 *  Comparator for 10-Class Object Classification
 *  Takes 10 FC outputs and finds the maximum (winning class)
 *
 *------------------------------------------------------------------------*/

module comparator #(
    parameter OUTPUT_NUM = 10,
    parameter DATA_BITS = 12
)(
    input wire clk,
    input wire rst_n,
    input wire valid_in,
    input wire signed [DATA_BITS-1:0] data_in,
    output reg [3:0] decision,      // 4 bits for 0-9
    output reg valid_out
);

    // Buffer to store all 10 outputs from FC layer
    reg signed [DATA_BITS-1:0] buffer [0:OUTPUT_NUM-1];
    reg [3:0] buf_idx;
    reg state;
    
    // State machine: 
    // state=0: Collecting 10 FC outputs
    // state=1: Finding maximum and outputting decision

    always @(posedge clk) begin
        if (~rst_n) begin
            buf_idx <= 4'd0;
            state <= 1'b0;
            valid_out <= 1'b0;
            decision <= 4'd0;
        end else begin
            
            // Clear valid_out after one cycle
            if (valid_out == 1'b1) begin
                valid_out <= 1'b0;
            end

            if (valid_in == 1'b1) begin
                if (!state) begin
                    // Collect all 10 FC outputs into buffer
                    buffer[buf_idx] <= data_in;
                    buf_idx <= buf_idx + 4'd1;
                    
                    if (buf_idx == OUTPUT_NUM - 1) begin
                        buf_idx <= 4'd0;
                        state <= 1'b1;
                    end
                end else begin
                    // Find maximum value among all 10 outputs
                    state <= 1'b0;
                    valid_out <= 1'b1;
                    
                    // Start with class 0 as default
                    decision <= 4'd0;
                    
                    // Compare all 10 classes and find max
                    // This is a simple sequential comparison
                    if (buffer[1] > buffer[decision]) decision <= 4'd1;
                    if (buffer[2] > buffer[decision]) decision <= 4'd2;
                    if (buffer[3] > buffer[decision]) decision <= 4'd3;
                    if (buffer[4] > buffer[decision]) decision <= 4'd4;
                    if (buffer[5] > buffer[decision]) decision <= 4'd5;
                    if (buffer[6] > buffer[decision]) decision <= 4'd6;
                    if (buffer[7] > buffer[decision]) decision <= 4'd7;
                    if (buffer[8] > buffer[decision]) decision <= 4'd8;
                    if (buffer[9] > buffer[decision]) decision <= 4'd9;
                end
            end
        end
    end

endmodule