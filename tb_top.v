`timescale 1ns/1ps

module tb_top;

    // Testbench signals
    reg clk;
    reg reset;
    wire uart_tx;

    // Clock generation (50 MHz, period 20 ns)
    always #10 clk = ~clk;

    // Instantiate the top module
    top uut (
        .clk(clk),
        .reset(reset),
        .uart_tx(uart_tx)
    );

    // Simulation setup
    initial begin
        // Initialize signals
        clk = 0;
        reset = 1;

        // Wait for 100 ns and release reset
        #100;
        reset = 0;

        // Run simulation for a sufficient number of clock cycles
        #10000;

        // End simulation
        $finish;
    end

    // Monitor UART transmission
    initial begin
        $monitor("Time: %0dns, UART_TX = %b", $time, uart_tx);
    end

endmodule
