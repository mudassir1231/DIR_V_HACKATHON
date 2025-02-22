module top (
    input wire clk,
    input wire reset,
    output wire uart_tx  // UART transmit signal
);

    reg [31:0] cyc_cnt = 0;
    reg [7:0] uart_data;
    reg uart_send;
    wire uart_busy;
    reg passed;
    reg failed;

    // SPRAM for inputs, weights, and outputs
    reg [7:0] sram_input_mem[0:63];     // SRAM to store input activations
    reg [7:0] sram_weight_mem[0:63];    // SRAM to store weights
    reg [31:0] sram_output_mem[0:63];   // SRAM to store convolution output

    // UART Module Instantiation
    uart_tx_8n1 uart_transmitter (
        .clk(clk),
        .txbyte(uart_data),
        .senddata(uart_send),
        .txdone(uart_done),
        .tx(uart_tx)
    );

    // Clock and cycle counter
    always @(posedge clk or posedge reset) begin
        if (reset)
            cyc_cnt <= 0;
        else
            cyc_cnt <= cyc_cnt + 1;
    end

    // Load input activations and weights into SRAM
    initial begin
       
        integer i;
        for (i = 0; i < 64; i = i + 1) begin
            sram_input_mem[i] = $random % 256;   // Random 8-bit input activations
            sram_weight_mem[i] = $random % 256;  // Random 8-bit filter weights
        end
    end

    // Convolution operation
    integer row_el, col_el;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Clear output SRAM on reset
            integer i;
            for (i = 0; i < 64; i = i + 1) begin
                sram_output_mem[i] <= 0;
            end
        end else begin
            for (row_el = 0; row_el = 7; row_el = row_el + 1) begin
                for (col_el = 0; col_el = 7; col_el = col_el + 1) begin
                    integer idx = row_el * 8 + col_el;
                    sram_output_mem[idx] <= sram_input_mem[idx] * sram_weight_mem[idx];
                end
            end
        end
    end

    // UART transmission of results (after convolution is done)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            uart_data <= 8'b0;
            uart_send <= 1'b0;
            passed <= 1'b0;
            failed <= 1'b0;
        end else if (cyc_cnt == 40) begin
            // Start streaming output over UART
            uart_data <= sram_output_mem[0][7:0];  // Transmit lower byte of first result
            uart_send <= 1'b1;
            passed <= 1'b1;
            failed <= 1'b0;
        end else begin
            uart_send <= 1'b0;
        end
    end

endmodule


// 8N1 UART Module, transmit only
module uart_tx_8n1 (
    input clk,        // input clock
    input [7:0] txbyte, // outgoing byte
    input senddata,   // trigger tx
    output reg txdone, // outgoing byte sent
    output tx         // tx wire
);

    /* Parameters */
    parameter STATE_IDLE = 8'd0;
    parameter STATE_STARTTX = 8'd1;
    parameter STATE_TXING = 8'd2;
    parameter STATE_TXDONE = 8'd3;

    /* State variables */
    reg [7:0] state = STATE_IDLE;
    reg [7:0] buf_tx = 8'b0;
    reg [7:0] bits_sent = 8'b0;
    reg txbit = 1'b1;

    /* Wiring */
    assign tx = txbit;

    /* always */
    always @(posedge clk) begin
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
            buf_tx <= buf_tx >> 1;
            bits_sent <= bits_sent + 1;
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
