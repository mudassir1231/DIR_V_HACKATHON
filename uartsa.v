`include "sp_verilog.vh"
module top(
    input wire clk,
    input wire reset,
    output wire uart_tx,  // UART transmit signal
    //input wire uart_rx    // UART receive signal (if needed)
);
`include "sa_gen.v" //_\TLV

   reg [31:0] cyc_cnt = 0;
   reg [7:0] uart_data;
   reg uart_send;
   wire uart_busy;
   reg passed;  
   reg failed;  

   // Clock and cycle counter
   always @(posedge clk or posedge reset) begin
       if (reset)
           cyc_cnt <= 0;
       else
           cyc_cnt <= cyc_cnt + 1;
   end

   assign L0_activation_random_a0[7:0] = RW_rand_vect[(0 + (0)) % 257+:8];
   assign L0_weight_random_a0[7:0] = RW_rand_vect[(124 + (0)) % 257 +:8 ];
   
   generate for (row_el =  0; row_el <= 7 ; row_el=row_el+1) begin : L1_RowEl //_/row_el
      for (col_el =  0; col_el <= 7 ; col_el=col_el+1) begin : L2_ColEl //_/col_el

         // For $activation_in.
         wire L2_activation_in_a0;

         // For $reset.
         wire L2_reset_a0;

         // For $weight_in.
         wire L2_weight_in_a0;

         assign L2_activation_in_a0 = L0_activation_random_a0;
         assign L2_weight_in_a0 = L0_weight_random_a0;
         assign L2_reset_a0 = L0_reset_a0;
      end
   end endgenerate
         
   //_\source sa.tlv 13   // Instantiated from sa.tlv, 39 as: m5+two_d_array(/row_el, /col_el, m5_num_rows, m5_num_cols, $activation_in, $weight_in, $reset, $activation_out, $weight_out)
      generate for (row_el =  0; row_el <= 7 ; row_el=row_el+1) begin : L1b_RowEl //_/row_el

         // For /col_el$activation_out.
         wire [7:0] L1_ColEl_activation_out_a0 [7: 0];

         for (col_el =  0; col_el <= 7; col_el=col_el+1) begin : L2b_ColEl //_/col_el

            // For $activation.
            wire [7:0] L2_activation_a0;
            reg  [7:0] L2_activation_a1;

            // For $weight.
            wire [7:0] L2_weight_a0;
            reg  [7:0] L2_weight_a1;

            // For $weight_out.
            wire [7:0] L2_weight_out_a0;

            assign L2_activation_a0[7:0] =  (col_el == 0) ? L1_RowEl[row_el].L2_ColEl[col_el].L2_activation_in_a0 :  L1_ColEl_activation_out_a0[(col_el - 1) % 8];
            assign L2_weight_a0[7:0] = (row_el == 0) ? L1_RowEl[row_el].L2_ColEl[col_el].L2_weight_in_a0 : RowEl_weight_out_a0[(row_el - 1)%(`m5_num_rows)];
            //_\source sa.tlv 8   // Instantiated from sa.tlv, 18 as: m5+mac($out, $activation, $weight, $reset, $activation_out, $weight_out)
               assign RowEl_ColEl_out_a0[row_el][col_el][31:0] = L1_RowEl[row_el].L2_ColEl[col_el].L2_reset_a0 ? 0 : $signed(L2_activation_a0[7:0]) * $signed(L2_weight_a0[7:0]) + RowEl_ColEl_out_a1[row_el][col_el];
               assign L2_weight_out_a0[7:0] = L1_RowEl[row_el].L2_ColEl[col_el].L2_reset_a0 ? 0 : L2_weight_a1;
               assign L1_ColEl_activation_out_a0[col_el][7:0] = L1_RowEl[row_el].L2_ColEl[col_el].L2_reset_a0 ? 0 : L2_activation_a1;
               
            //_\end_source
         end
      end endgenerate
   //_\end_source
   
   assign L0_result_a0[31:0] = RowEl_ColEl_out_a0[7][7];
   
   // Assert these to end simulation (before Makerchip cycle limit).
   assign passed = cyc_cnt > 40;
   assign failed = 1'b0;
//_\SV
 


// Undefine macros defined by SandPiper (in "sa_gen.v").
`undef BOGUS_USE

   // UART Module Instantiation
      uart_tx_8n1 uart_transmitter (
       .clk(clk),
       .txbyte(uart_data),
       .senddata(uart_send),
       .txdone(uart_done),
        .tx(uart_tx)



   );

   // Send result over UART when simulation passes
   always @(posedge clk or posedge reset) begin
       if (reset) begin
           uart_data <= 8'b0;
           uart_send <= 1'b0;
           passed <= 1'b0;
           failed <= 1'b0;
       end else if (cyc_cnt == 40) begin
           uart_data <= L0_result_a0[7:0];  // Transmit lower byte of result
           uart_send <= 1'b1;               // Start sending data
           passed <= 1'b1;                  // Set passed when condition is met
           failed <= 1'b0;                  // Failed remains 0
       end else begin
           uart_send <= 1'b0;               // Reset send signal once data is sent
       end
   end
endmodule


// 8N1 UART Module, transmit only

module uart_tx_8n1 (
    clk,        // input clock
    txbyte,     // outgoing byte
    senddata,   // trigger tx
    txdone,     // outgoing byte sent
    tx,         // tx wire
    );

    /* Inputs */
    input clk;
    input[7:0] txbyte;
    input senddata;

    /* Outputs */
    output txdone;
    output tx;

    /* Parameters */
    parameter STATE_IDLE=8'd0;
    parameter STATE_STARTTX=8'd1;
    parameter STATE_TXING=8'd2;
    parameter STATE_TXDONE=8'd3;

    /* State variables */
    reg[7:0] state=8'b0;
    reg[7:0] buf_tx=8'b0;
    reg[7:0] bits_sent=8'b0;
    reg txbit=1'b1;
    reg txdone=1'b0;

    /* Wiring */
    assign tx=txbit;

    /* always */
    always @ (posedge clk) begin
        // start sending?
        if (senddata == 1 && state == STATE_IDLE) begin
            state <= STATE_STARTTX;
            buf_tx <= txbyte;
            txdone <= 1'b0;
        end else if (state == STATE_IDLE) begin
            // idle at high
            txbit <= 1'b1;
            txdone <= 1'b0;
        end

        // send start bit (low)
        if (state == STATE_STARTTX) begin
            txbit <= 1'b0;
            state <= STATE_TXING;
        end
        // clock data out
        if (state == STATE_TXING && bits_sent < 8'd8) begin
            txbit <= buf_tx[0];
            buf_tx <= buf_tx>>1;
            bits_sent = bits_sent + 1;
        end else if (state == STATE_TXING) begin
            // send stop bit (high)
            txbit <= 1'b1;
            bits_sent <= 8'b0;
            state <= STATE_TXDONE;
        end

        // tx done
        if (state == STATE_TXDONE) begin
            txdone <= 1'b1;
            state <= STATE_IDLE;
        end

    end

endmodule
