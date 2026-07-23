`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 23.07.2026 23:34:31
// Design Name: 
// Module Name: uart_tx_tb
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

module uart_tx_tb;

reg clk;
reg reset;
reg baud_tick;
reg tx_start;
reg [7:0] data_in;

wire tx;
wire busy;
wire tx_done;

// Instantiate UART Transmitter
uart_tx dut(
    .clk(clk),
    .reset(reset),
    .baud_tick(baud_tick),
    .tx_start(tx_start),
    .data_in(data_in),
    .tx(tx),
    .busy(busy),
    .tx_done(tx_done)
);

//--------------------------------------------------
// Clock Generation (10 ns period)
//--------------------------------------------------
always #5 clk = ~clk;

//--------------------------------------------------
// Baud Tick Generation
//--------------------------------------------------
always begin
    baud_tick = 0;
    #80;
    baud_tick = 1;
    #10;
    baud_tick = 0;
end

//--------------------------------------------------
// Test Sequence
//--------------------------------------------------
initial begin

    clk = 0;
    reset = 1;
    tx_start = 0;
    data_in = 8'b00000000;

    #20;
    reset = 0;

    // Send 0xA5
    #20;
    data_in = 8'b10100101;
    tx_start = 1;

    #10;
    tx_start = 0;

    // Wait for transmission to finish
    #1200;

    // Send another byte
    data_in = 8'b11001100;
    tx_start = 1;

    #10;
    tx_start = 0;

    #1200;

    $finish;

end

endmodule
