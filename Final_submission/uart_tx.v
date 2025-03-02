module uart_tx #(parameter CLK_FREQ = 50000000, parameter BAUD_RATE = 115200)(
    input clk,
    input rst,
    input [7:0] data,
    input send,
    output reg tx
);
    reg [3:0] bit_index;
    reg [9:0] shift_reg;
    reg [15:0] baud_count;
    reg transmitting;
   
    always @(posedge clk) begin
        if (rst) begin
            tx <= 1;
            transmitting <= 0;
            bit_index <= 0;
            baud_count <= 0;
        end else if (send && !transmitting) begin
            shift_reg <= {1'b1, data, 1'b0};
            transmitting <= 1;
            bit_index <= 0;
            baud_count <= 0;
        end else if (transmitting) begin
            if (baud_count == (CLK_FREQ / BAUD_RATE)) begin
                baud_count <= 0;
                tx <= shift_reg[0];
                shift_reg <= {1'b1, shift_reg[9:1]};
                bit_index <= bit_index + 1;
                if (bit_index == 9) transmitting <= 0;
            end else begin
                baud_count <= baud_count + 1;
            end
        end
    end
endmodule
