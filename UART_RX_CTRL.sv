`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 13.05.2018 23:56:22
// Design Name: 
// Module Name: UART_RX_CTRL
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


module UART_RX_CTRL #(parameter max_number_delay = 100000)(
    input logic rx_ready,
    input logic [7:0] rx_data,
    input logic clock, reset,
    output logic [15:0] OP_A, OP_B,
    output logic [1:0] operacion,
    output logic trigger,
    output logic [11:0] stateID
    );
    
logic [7:0] data8;

logic [31:0] contador;
logic [7:0] OP_1A, OP_1B, OP_2A, OP_2B, OP_CMD;
//(*fsm_encoding="one_hot"*) enum logic [11:0] {wait_op1_LSB, store_op1_LSB, wait_op1_MSB, store_op1_MSB, wait_op2_LSB, store_op2_LSB, wait_op2_MSB, store_op2_MSB, wait_CMD, store_CMD, delay_1_cycle, trigger_TX_result} state, nextstate;

localparam wait_op1_LSB      = 12'b000000000001;
localparam store_op1_LSB     = 12'b000000000010;
localparam wait_op1_MSB      = 12'b000000000100;
localparam store_op1_MSB     = 12'b000000001000; 
localparam wait_op2_LSB      = 12'b000000010000;
localparam store_op2_LSB     = 12'b000000100000;
localparam wait_op2_MSB      = 12'b000001000000;
localparam store_op2_MSB     = 12'b000010000000; 
localparam wait_CMD          = 12'b000100000000;
localparam store_CMD         = 12'b001000000000;
localparam delay_1_cycle     = 12'b010000000000;
localparam trigger_TX_result = 12'b100000000000;
logic [11:0] state, nextstate;

always_ff @(posedge clock) begin
    if (reset)
        state <= wait_op1_LSB;
    else state <= nextstate;
    end

always_comb begin
    nextstate = state;
    trigger= 1'b0;
    data8='d0;
    
    case (state)
    
    wait_op1_LSB: if (rx_ready) 
                    nextstate = store_op1_LSB;
                
    store_op1_LSB: begin data8 = rx_data;
                    nextstate = wait_op1_MSB; end
    
    wait_op1_MSB: if (rx_ready)
                    nextstate = store_op1_MSB;
                    
    store_op1_MSB: begin data8 = rx_data;
                    nextstate = wait_op2_LSB; end
                    
    wait_op2_LSB: if (rx_ready)
                    nextstate = store_op2_LSB;
                    
    store_op2_LSB: begin data8 = rx_data;
                    nextstate = wait_op2_MSB; end
                    
    wait_op2_MSB: if (rx_ready)
                    nextstate = store_op2_MSB;
                    
    store_op2_MSB: begin data8 = rx_data;
                    nextstate = wait_CMD; end
                    
    wait_CMD:  if (rx_ready)
                    nextstate = store_CMD;
                    
    store_CMD: begin data8 = rx_data;
                    nextstate = delay_1_cycle; end
                    
    delay_1_cycle: if(contador >= max_number_delay)
                    nextstate = trigger_TX_result;
                    
    trigger_TX_result: begin trigger = 1'b1;
    
                        nextstate = wait_op1_LSB; end
endcase
end

assign stateID=state;

always_ff @(posedge clock) begin
    if (state==delay_1_cycle)
       contador <= contador + 'd1;
    else
       contador <= 'd0;
end
 
    FDCE fdce_A_1(
    .clk(clock),
    .RST_BTN_n(~reset),
    .switches(rx_data),
    .retain(stateID[1]),
    .leds(OP_1A)    
    );
FDCE fdce_A_2(
        .clk(clock),
        .RST_BTN_n(~reset),
        .switches(rx_data),
        .retain(stateID[3]),
        .leds(OP_2A)    
        );  
        
 assign OP_A = {OP_2A, OP_1A};
   
FDCE fdce_B_1(
            .clk(clock),
            .RST_BTN_n(~reset),
            .switches(rx_data),
            .retain(stateID[5]),
            .leds(OP_1B)    
            );
FDCE fdce_B_2(
                .clk(clock),
                .RST_BTN_n(~reset),
                .switches(rx_data),
                .retain(stateID[7]),
                .leds(OP_2B)   
                );
 assign OP_B = {OP_2B, OP_1B};
 
 FDCE fdce_cmd(
                 .clk(clock),
                 .RST_BTN_n(~reset),
                 .switches(rx_data),
                 .retain(stateID[9]),
                 .leds(OP_CMD)   
                 );
assign operacion= OP_CMD[1:0];



endmodule
