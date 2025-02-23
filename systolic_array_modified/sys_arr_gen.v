`define m5_num_rows 8
`define m5_data_width 8

wire [(8 - 1):0] L0_activation_random_a0;

// For $reset.
wire L0_reset_a0;

// For $result.
wire [31:0] L0_result_a0;

// For $weight_random.
wire [(8 - 1):0] L0_weight_random_a0;

// For /row_el$weight_out.
wire RowEl_weight_out_a0 [(8 - 1) : 0];

// For /row_el/col_el$out.
wire [31:0] RowEl_ColEl_out_a0 [(8 - 1) : 0][(8 - 1) : 0];
reg  [31:0] RowEl_ColEl_out_a1 [(8 - 1) : 0][(8 - 1) : 0];




   //
   // Scope: /row_el[(m5_num_rows - 1) : 0]
   //
generate for (genvar row_el =  0; row_el <= (8 - 1) ; row_el=row_el+1) begin : L1gen_RowEl
      // Staging of signal $weight_out, which had no assignment.
      assign RowEl_weight_out_a0[row_el] = 'x;


      //
      // Scope: /col_el[(m5_num_cols - 1) : 0]
      //
  for (genvar col_el =  0; col_el <= (8 - 1) ; col_el=col_el+1) begin : L2gen_ColEl
         // Staging of $activation.
         always @(posedge clk) L1b_RowEl[row_el].L2b_ColEl[col_el].L2_activation_a1[7:0] <= L1b_RowEl[row_el].L2b_ColEl[col_el].L2_activation_a0[7:0];

         // Staging of $out.
         always @(posedge clk) RowEl_ColEl_out_a1[row_el][col_el][31:0] <= RowEl_ColEl_out_a0[row_el][col_el][31:0];

         // Staging of $weight.
         always @(posedge clk) L1b_RowEl[row_el].L2b_ColEl[col_el].L2_weight_a1[7:0] <= L1b_RowEl[row_el].L2b_ColEl[col_el].L2_weight_a0[7:0];

      end
   end endgenerate
