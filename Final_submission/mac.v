module MAC#(
    IN_WORD_SIZE = 8,
    OUT_WORD_SIZE = 16
)(
  input [7:0] a, b,
    input clk, clear,
  output reg [7:0] a_fwd, b_fwd,
  output reg [15:0] out
);
 
  reg [16:0] acc_reg;
    always @(posedge clk or posedge clear) begin
        if (clear) begin
            a_fwd <= 0;
            b_fwd <= 0;
            acc_reg <= 0;
            out <= 0;
        end else begin
            a_fwd <= a;
            b_fwd <= b;
          	acc_reg <= a * b;
            out <= a * b + acc_reg;
        end
    end
endmodule
