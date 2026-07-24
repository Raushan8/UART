`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2026 13:05:17
// Design Name: 
// Module Name: uart_rx_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps

module uart_rx_tb;

reg clk;
reg reset;
reg baud_tick;
reg rx;

wire [7:0] data_out;
wire data_valid;

//--------------------------------------------------
// Instantiate UART Receiver
//--------------------------------------------------
uart_rx dut(
    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick),
    .rx(rx),
    .data_out(data_out),
    .data_valid(data_valid)
);

//--------------------------------------------------
// Clock Generation (10 ns Period)
//--------------------------------------------------
always #5 clk = ~clk;

//--------------------------------------------------
// Baud Tick Generation
//--------------------------------------------------
always
begin
    baud_tick = 0;
    #80;
    baud_tick = 1;
    #10;
    baud_tick = 0;
end

//--------------------------------------------------
// Test Sequence
//--------------------------------------------------
initial
begin

    clk = 0;
    reset = 1;
    rx = 1;          // UART line is HIGH during idle

    #20;
    reset = 0;

    //--------------------------------------------------
    // Transmit Byte : 8'b10100101
    //--------------------------------------------------

    // Start Bit
    #70;
    rx = 0;

    // Bit0 = 1
    #90;
    rx = 1;

    // Bit1 = 0
    #90;
    rx = 0;

    // Bit2 = 1
    #90;
    rx = 1;

    // Bit3 = 0
    #90;
    rx = 0;

    // Bit4 = 0
    #90;
    rx = 0;

    // Bit5 = 1
    #90;
    rx = 1;

    // Bit6 = 0
    #90;
    rx = 0;

    // Bit7 = 1
    #90;
    rx = 1;

    // Stop Bit
    #90;
    rx = 1;

    #300;

    $finish;

end

endmodule