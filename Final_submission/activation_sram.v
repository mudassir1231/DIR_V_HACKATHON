module activation_sram(input wire clk, input wire en, input wire reset, output reg [63:0] act_out);
  reg [63:0] mem[7:0] = '{default : 1235};
  
  reg [7:0] count_1;
  reg [7:0] count_2;
  reg [7:0] count_3;
  reg [7:0] count_4;
  reg [7:0] count_5;
  reg [7:0] count_6;
  reg [7:0] count_7;
  reg [7:0] count_8;
  
  localparam [2:0] idle = 3'b000;
  localparam [2:0] start_op = 3'b001;
  localparam [2:0] out = 3'b010;
  localparam [2:0] count_incr = 3'b011;
  localparam [2:0] res = 3'b100;
  reg [5:0] iter;
  
  reg [5:0] state;
  
  always @(posedge clk or negedge reset) begin
    if(!reset) 
      state <= idle;
   
    
    else begin
      case(state)
        idle: begin
        	act_out <= '0;
    		{count_1, count_2, count_3, count_4, count_5, count_6, count_7, count_8} <= '0;
          	iter <= 0;
          	state <= en ? start_op : idle;
        end
        start_op : begin
          state <= out;
        end
        out : begin
          act_out[7:0] <= mem[iter][7:0];
          act_out[15:8] <= (count_2 % 2 == 0) ? mem[iter][15:8] : 0;
          act_out[23:16] <= (count_3 % 3 ==0) ? mem[iter][23:16] : 0;
          act_out[31:24] <= (count_4 % 4 == 0) ? mem[iter][31:24] : 0;
          act_out[39:32] <= (count_5 % 5 == 0) ? mem[iter][39:32] : 0;
          act_out[47:40] <= (count_6 % 6 == 0) ? mem[iter][47:40] : 0;
          act_out[55:48] <= (count_7 % 7 ==0) ? mem[iter][55:48] : 0;
          act_out[63:56] <= (count_8 % 8 == 0) ? mem[iter][63:56] : 0;
          
          state <= (iter == 7) ? idle : count_incr;
        end
        
        count_incr: begin
          count_1 <= count_1 + 1;
          count_2 <= count_2 + 1;
          count_3 <= count_3 + 1;
          count_4 <= count_4 + 1;
          count_5 <= count_5 + 1;
          count_6 <= count_6 + 1;
          count_7 <= count_7 + 1;
          count_8 <= count_8 + 1;
          
          iter <= iter + 1;
          
          state <= out;
        end
        
        default : state <= idle;
      endcase
           
    end
  end
  
endmodule
