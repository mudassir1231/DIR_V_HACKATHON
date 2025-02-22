`timescale 1ns/1ps
module tb_top;

    // Testbench signals
    reg clk;
    reg reset;
    wire uart_tx;

    // Instantiate the top module
    top uut (
        .clk(clk),
        .reset(reset),
        .uart_tx(uart_tx)
    );

    // Clock generation: 10 ns period (50 MHz)
    always #5 clk = ~clk;

    // Random vector for initialization
    reg [256:0] RW_rand_vect;
    integer i;

    initial begin
        clk = 0;
        reset = 1;
        RW_rand_vect = 257'hDEADBEEFCAFEBABE0123456789ABCDEF0123456789ABCDEF0123456789ABCDEF;
        
        // Hold reset for a few clock cycles
        #20 reset = 0;
        
        // Wait for some time before reading SRAM
        #100;
        
        // Display the initialized SRAM content (inputs and weights)
        $display("=== Initializing Input and Weight SRAM ===");
        for (i = 0; i < 64; i = i + 1) begin
            $display("Time=%t, Input[%0d] = %d, Weight[%0d] = %d", $time, i, uut.sram_input_mem[i], i, uut.sram_weight_mem[i]);
        end
        
        // Wait for the convolution to complete (estimated time)
        #1000;
        
        // Display the results after convolution (outputs)
        $display("=== Convolution Results ===");
        for (i = 0; i < 64; i = i + 1) begin
            $display("Time=%t, Output[%0d] = %d", $time, i, uut.sram_output_mem[i]);
        end
        
        // Run the simulation for a longer time to observe UART output
        #5000;
        $finish;
    end

endmodule

