\m5_TLV_version 1d: tl-x.org
\m5
   
   // =================================================
   // Welcome!  New to Makerchip? Try the "Learn" menu.
   // =================================================
   
   use(m5-1.0)   /// uncomment to use M5 macro library.
\TLV mac($out, $activation, $weight, $reset, $activation_out, $weight_out)
   $out[31:0] = $reset ? 0 : \$signed($activation[7:0]) * \$signed($weight[7:0]) + >>1$out;
   $weight_out[7:0] = $reset ? 0 : >>1$weight;
   $activation_out[7:0] = $reset ? 0 : >>1$activation;
   
\TLV two_d_array(/row_index, /col_index, #rows, #columns, $activation1, $weight1, $reset, $activation_out, $weight_out)
   /row_index[*]
      /col_index[*]
         $activation[7:0] =  (#m4_strip_prefix(/col_index) == 0) ? $activation1 :  /row_index/col_index[(#m4_strip_prefix(/col_index) - 1) % (#columns)]$activation_out;
         $weight[7:0] = (#m4_strip_prefix(/row_index) == 0) ? $weight1 : /row_index[(#m4_strip_prefix(/row_index) - 1)%(#rows)]$weight_out;
         m5+mac($out, $activation, $weight, $reset, $activation_out, $weight_out)
\SV
   // Macro providing required top-level module definition, random
   // stimulus support, and Verilator config.
   m5_makerchip_module   // (Expanded in Nav-TLV pane.)
\TLV
   $reset = *reset;
   
   m5_var(data_width, 8)
   m5_var(num_rows, 8)
   m5_var(num_cols, 8)
   
   m4_rand($activation_random, (m5_data_width - 1), 0)
   m4_rand($weight_random, (m5_data_width - 1), 0)
   
   /row_el[(m5_num_rows - 1) : 0]
      /col_el[(m5_num_cols - 1) : 0]
         $activation_in = /top$activation_random;
         $weight_in = /top$weight_random;
         $reset = /top$reset;
         
   m5+two_d_array(/row_el, /col_el, m5_num_rows, m5_num_cols, $activation_in, $weight_in, $reset, $activation_out, $weight_out)
   
   $result[31:0] = /row_el[m5_num_rows-1]/col_el[m5_num_cols-1]$out;
   
   // Assert these to end simulation (before Makerchip cycle limit).
   *passed = *cyc_cnt > 40;
   *failed = 1'b0;
\SV
   endmodule
