module weights_sram(input wire clk, input wire en, input wire reset, output reg [31:0] weight_out);
  reg [31:0] mem[7:0] = '{default : 10204};
  
  reg [7:0] count_1;
  reg [7:0] count_2;
  reg [7:0] count_3;
  reg [7:0] count_4;
  
  localparam [2:0] idle = 3'b000;
  localparam [2:0] start_op = 3'b001;
  localparam [2:0] out = 3'b010;
  localparam [2:0] count_incr = 3'b011;
  
  
  reg [5:0] iter;
  
  reg [5:0] state;
  
  always @(posedge clk or negedge reset) begin
    if(!reset) 
      state <= idle;
   
    
    else begin
      case(state)
        idle: begin
        	weight_out <= '0;
    		{count_1, count_2, count_3, count_4} <= '0;
          	iter <= 0;
          	state <= en ? start_op : idle;
        end
        start_op : begin
          state <= out;
        end
        out : begin
          weight_out[7:0] <= mem[iter][7:0];
          weight_out[15:8] <= (count_2 % 2 == 0) ? mem[iter][15:8] : 0;
          weight_out[23:16] <= (count_3 % 3 ==0) ? mem[iter][23:16] : 0;
          weight_out[31:24] <= (count_4 % 4 == 0) ? mem[iter][31:24] : 0;
        
          
          state <= (iter == 3) ? idle : count_incr;
        end
        
        count_incr: begin
          count_1 <= count_1 + 1;
          count_2 <= count_2 + 1;
          count_3 <= count_3 + 1;
          count_4 <= count_4 + 1;
         
          
          iter <= iter + 1;
          //((count_2 % 2 == 0) && (count_3 % 3 == 0) && (count_4 % 4 == 0)) ? iter + 1 : iter;
          
          state <= out;
        end
        
        default : state <= idle;
      endcase
           
    end
  end
  
endmodule
