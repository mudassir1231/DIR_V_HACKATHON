`include"activation_sram.v"
`include"weights_sram.v"

module top(
  input clk,
  input en,
  input reset,
  output compute_done
  
);
  
  wire [63:0] act_out;
  wire [31:0] weight_out;
  wire rst;
  wire [(24*64-1):0] pe_register_vals;
  wire tx;
  reg [5:0] cycles_count;
  // Instantiating weight_sram with an instance name
  weights_sram weight_sram_inst (
    .clk(clk),
    .en(en),
    .reset(reset),
    .weight_out(weight_out)
  );

  // Instantiating activation_sram with an instance name
  activation_sram activation_sram_inst (
    .clk(clk),
    .en(en),
    .reset(reset),
    .act_out(act_out)
  );

  // Instantiating systolic_array with corrected parameters and port list
  systolic_array systolic_array_inst (
    .clk(clk),
    .rst(reset),
    .compute_done(compute_done),
    .top_inputs(weight_out),
    .left_inputs(act_out),
    .cycles_count(cycles_count),
    .pe_register_vals(pe_register_vals),
    .tx(tx)
  );

endmodule
