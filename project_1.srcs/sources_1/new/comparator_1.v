`timescale 1ns / 1ps

module comparator(
    input clk,
    input rst_n,
    input valid_in,
    input signed [11:0] data_in,
    output reg [3:0] decision,
    output reg valid_out
);

reg signed [11:0] max_val;
reg [3:0] class_idx;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        decision <= 0;
        valid_out <= 0;
        max_val <= 0;
        class_idx <= 0;
    end
    else begin
        valid_out <= 0;

        if (valid_in) begin
            if (class_idx == 0) begin
                max_val <= data_in;
                decision <= 0;
            end
            else begin
                if (data_in > max_val) begin
                    max_val <= data_in;
                    decision <= class_idx;
                end
            end

            if (class_idx == 9) begin
                valid_out <= 1;
                class_idx <= 0;
            end
            else begin
                class_idx <= class_idx + 1;
            end
        end
    end
end

endmodule