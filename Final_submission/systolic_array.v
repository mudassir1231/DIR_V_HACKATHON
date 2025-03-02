module systolic_array#(
   parameter NUM_ROW = 8,
       parameter NUM_COL = 8,
      parameter  IN_WORD_SIZE = 64,
     parameter  OUT_WORD_SIZE = 24
)(
    input clk,
    input rst,
    output reg compute_done,
  input wire [31:0] top_inputs,
  input wire [63:0] left_inputs,
  output reg [5:0] cycles_count,
    output reg [OUT_WORD_SIZE * NUM_ROW * NUM_COL-1:0] pe_register_vals,
    output tx
);
    
   
  wire [15:0] pe_reg[8][4];
    
  wire [7:0] a_fwd[8][4];
  wire [7:0] b_fwd[8][4];
  
  
  	generate
      for(genvar r = 0; r <=7; r++) begin :rw_gen
        for(genvar c = 0; c <=3; c++) begin : cl_gen
          wire [7:0] act_in;
          wire[7:0] w_in;
          wire [7:0] act_out;
          wire [7:0] w_out;
           
          MAC mac_inst(.a(act_in),.b(top_inputs[((c*8) + 7) : (c*8)]), .a_fwd(act_out), .b_fwd(w_out), .clk(clk), .clear(!rst), .out(pe_reg[r][c]));  
          
        end
      end
      
    endgenerate
   
  generate
  	genvar i_1; genvar i_2;
    for(i_1 = 0; i_1 <= 7; i_1++) begin :r_assign
      for(i_2 = 0; i_2 <= 3; i_2++) begin : c_assign
        assign rw_gen[i_1].cl_gen[i_2].act_in = (i_2==0) ? left_inputs[((8*i_1)+7) : (8*i_1)] : rw_gen[(i_1+1)-1].cl_gen[(i_2+1)-1].act_out;
        assign rw_gen[i_1].cl_gen[i_2].w_in = (i_1==0) ? top_inputs[((8*i_2)+7) : (8*i_2)] : rw_gen[(i_1+1)-1].cl_gen[(i_2+1)-1].w_out;
      end
    end
  endgenerate
    
    reg [7:0] uart_data;
    reg send_uart;
   
    uart_tx uart_inst (
        .clk(clk),
        .rst(rst),
        .data(uart_data),
        .send(send_uart),
        .tx(tx)
    );
 
  always @(posedge clk) cycles_count <= !rst ? 0 : cycles_count + 1;
  int k_1; int k_2;
  
  always @(posedge clk) begin
    for(k_1 = 0; k_1 < 8; k_1++) begin
      for(k_2 = 0; k_2 < 4; k_2++) begin
        pe_register_vals <= pe_reg[k_1][k_2];
      end
    end
  end
  
  always @(posedge clk) compute_done <= (cycles_count == 8);
    
endmodule
