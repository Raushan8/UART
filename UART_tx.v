module uart_tx(
    input clk,
    input reset,
    input baud_tick,
    input tx_start,
    input [7:0] data_in,

    output reg tx,
    output reg busy,
    output reg tx_done
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
// UART Transmitter FSM
//--------------------------------------------------
always @(posedge clk or posedge reset)
begin
    if(reset)
    begin
        state     <= IDLE;
        tx        <= 1'b1;      // UART line remains HIGH when idle
        busy      <= 1'b0;
        tx_done   <= 1'b0;
        shift_reg <= 8'd0;
        bit_count <= 3'd0;
    end

    else
    begin

        // Default
        tx_done <= 1'b0;

        case(state)

        //--------------------------------------------------
        // IDLE STATE
        //--------------------------------------------------
        IDLE:
        begin
            tx <= 1'b1;
            busy <= 1'b0;

            if(tx_start)
            begin
                busy <= 1'b1;
                shift_reg <= data_in;
                bit_count <= 3'd0;
                state <= START;
            end
        end

        //--------------------------------------------------
        // START BIT
        //--------------------------------------------------
        START:
        begin
            tx <= 1'b0;

            if(baud_tick)
                state <= DATA;
        end

        //--------------------------------------------------
        // DATA BITS
        //--------------------------------------------------
        DATA:
        begin
            if(baud_tick)
            begin
                tx <= shift_reg[0];
                shift_reg <= shift_reg >> 1;

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
            tx <= 1'b1;

            if(baud_tick)
            begin
                busy <= 1'b0;
                tx_done <= 1'b1;
                state <= IDLE;
            end
        end

        default:
            state <= IDLE;

        endcase

    end
