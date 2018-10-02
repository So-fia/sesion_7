`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.05.2018 01:01:35
// Design Name: 
// Module Name: top_rx_control
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


module top_rx_control(
    input logic CLK100MHZ, CPU_RESETN,//BTNC,
    input logic UART_TXD_IN,
    output logic [11:0] LED
//    input logic [7:0] SW
    );
    
logic rst, start_cable; 
logic [7:0] data_cable;
assign rst=~CPU_RESETN;

uart_basic uart_basic_inst(
    .clk(CLK100MHZ),
    .reset(rst),
	.rx(UART_TXD_IN),
	.rx_data(data_cable),
	.rx_ready(start_cable),
	.tx(),
	.tx_start(),
	.tx_data(),
	.tx_busy());

//PushButton_Debouncer deboincer(
//    .clk(CLK100MHZ),
//	.PB(BTNC),  // "PB" is the glitchy, asynchronous to clk, active low push-button signal
//	.PB_state(),  // 1 as long as the push-button is active (down)
//	.PB_down(),  // 1 for one clock cycle when the push-button goes down (i.e. just pushed)
//	.PB_up(start_cable));

UART_RX_CTRL uart_rx_ctrl_inst(
    .clock(CLK100MHZ),
    .rx_ready(start_cable),
    .rx_data(data_cable),
    .reset(rst),
    .OP_A(),
    .OP_B(),
    .operacion(),
    .trigger(),
    .stateID(LED));
    
endmodule