`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.07.2026 13:04:28
// Design Name: 
// Module Name: uart_rx
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

module uart_rx(

    input clk,
    input reset,
    input baud_tick,
    input rx,

    output reg [7:0] data_out,
    output reg data_valid

);

//--------------------------------------------------
// State Encoding
//--------------------------------------------------
localparam IDLE  = 2'b00,
           START = 2'b01,
           DATA  = 2'b10,
           STOP  = 2'b11;

reg [1:0] state;
reg [7:0] shift_reg;
reg [2:0] bit_count;

//--------------------------------------------------
// UART Receiver FSM
//--------------------------------------------------
always @(posedge clk or posedge reset)
begin

    if(reset)
    begin
        state      <= IDLE;
        shift_reg  <= 8'd0;
        bit_count  <= 3'd0;
        data_out   <= 8'd0;
        data_valid <= 1'b0;
    end

    else
    begin

        // Default
        data_valid <= 1'b0;

        case(state)

        //--------------------------------------------------
        // IDLE
        //--------------------------------------------------
        IDLE:
        begin
            bit_count <= 3'd0;

            if(rx == 1'b0)
                state <= START;
        end

        //--------------------------------------------------
        // START BIT
        //--------------------------------------------------
        START:
        begin
            if(baud_tick)
                state <= DATA;
        end

        //--------------------------------------------------
        // RECEIVE DATA
        //--------------------------------------------------
        DATA:
        begin

            if(baud_tick)
            begin

                shift_reg[bit_count] <= rx;

                if(bit_count == 3'd7)
                    state <= STOP;
                else
                    bit_count <= bit_count + 1;

            end

        end

        //--------------------------------------------------
        // STOP BIT
        //--------------------------------------------------
        STOP:
        begin

            if(baud_tick)
            begin

                if(rx == 1'b1)
                begin
                    data_out <= shift_reg;
                    data_valid <= 1'b1;
                end

                state <= IDLE;

            end

        end

        default:
            state <= IDLE;

        endcase

    end

end

endmodule