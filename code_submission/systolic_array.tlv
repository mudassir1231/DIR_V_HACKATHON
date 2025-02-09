\m5_TLV_version 1d: tl-x.org
\m5
   
   // =================================================
   // Welcome!  New to Makerchip? Try the "Learn" menu.
   // =================================================
   
   //use(m5-1.0)   /// uncomment to use M5 macro library.
\SV
   // Macro providing required top-level module definition, random
   // stimulus support, and Verilator config.
   m5_makerchip_module   // (Expanded in Nav-TLV pane.)
      //logic reset;
      logic [7:0] x_inp;
      logic [7:0] w_inp;
      logic [15:0] mat_mul;

      assign passed = cyc_cnt == 8;
      assign failed = cyc_cnt > 8;
      assign x_inp = 8'b01100111;
      assign w_inp = 8'b01100110;
      //assign reset = 0;
   
      systolic_array sys_array(clk, reset, x_inp, w_inp, mat_mul);     
   endmodule

   module systolic_array (input logic clk, input logic reset, input logic [7:0] x_inp, input logic [7:0] w_inp, output logic [15:0] matrix_result); 
\TLV
    m4_define_hier(['M4_ROWS'], 8)
    m4_define_hier(['M4_COLS'], 8)
   |processing_element
      @1
         /M4_ROWS_HIER
         /M4_COLS_HIER
         //m4_rand($rows, M4_ROWS_INDEX_MAX, 0);
         //m4_rand($columns, M4_COLS_INDEX_MAX, 0);
   |processing_element
      /rows_num[7:0]
         /columns_num[7:0]
            @1
               $x_in[7:0] = $reset ? 0 : (columns_num == 0) ? *x_inp : /top|processing_element/rows_num/columns_num[(#columns_num-1)%8]$x_out;
               $x_out[7:0] = (columns_num == 7) ? 0 : /top|processing_element/rows_num/columns_num[#columns_num]$x_in;
               $w_out[7:0] = (rows_num == 7) ? 0 : /top|processing_element/rows_num[#rows_num]$w_in;
               $w_in[7:0] = $reset ? 0 : (rows_num == 0) ? *w_inp : /top|processing_element/rows_num[(#rows_num -1 )%8]$w_out;
            
            
               $acc[15:0] = (>>1$w_in * >>1$x_in) + ($w_in * $x_in);
               //*matrix_result = /top|processing_element/rows_num[*]/columns_num[*]$acc;
               
   $reset = *reset;
   
   //...
   
   // Assert these to end simulation (before Makerchip cycle limit).
   
\SV
   endmodule
