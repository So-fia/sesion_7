`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.05.2018 21:11:12
// Design Name: 
// Module Name: top_UART_completo
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


module top_UART_completo(
        input logic CLK100MHZ, CPU_RESETN, UART_TXD_IN,
        output logic [7:0] AN,
        output logic CA, CB, CC, CD, CE, CF, CG, DP, UART_RXD_OUT, rx_data, tx_data, tx_busy_out
        );
        
    logic rst, start_cable_rx, start_cable_tx;
    logic [7:0] data_cable_rx, data_cable_tx;
    assign rst=~CPU_RESETN;

    uart_basic uart_basic_inst(
        .clk(CLK100MHZ),
        .reset(rst),
        .rx(UART_TXD_IN),
        .rx_data(data_cable_rx),
        .rx_ready(start_cable_rx),
        .tx(UART_RXD_OUT),
        .tx_start(start_cable_tx),
        .tx_data(data_cable_tx),
        .tx_busy(tx_busy_out));
        
assign UART_TXD_IN = rx_data;
assign UART_RXD_OUT = tx_data;

logic [15:0] cable_OPA, cable_OPB;
logic [1:0] cable_operacion;
logic [11:0] stateID;
logic triggger;

    UART_RX_CTRL uart_rx_ctrl_inst(
        .clock(CLK100MHZ),
        .rx_ready(start_cable_rx),
        .rx_data(data_cable_rx),
        .reset(rst),
        .OP_A(cable_OPA),
        .OP_B(cable_OPB),
        .operacion(cable_operacion),
        .trigger(triggger),
        .stateID(stateID));

logic [15:0] cable_result;

ALU_sw #(.N(16))ALU_inst (
    .A(cable_OPA),
    .B(cable_OPB),
    .SW(cable_operacion),
    .Result(cable_result)
    );

logic [31:0] cable_resultado_hex;
always_comb begin
    case(stateID)
        12'b000000010000: cable_resultado_hex={16'd0, cable_OPA};
        12'b000100000000: cable_resultado_hex={16'd0, cable_OPB};
        12'b000000000001: cable_resultado_hex={16'd0, cable_result};
        default: cable_resultado_hex=32'd0;
        endcase
        end
logic [31:0] cable_display;

unsigned_to_bcd double_dabber(
    .clk(CLK100MHZ),            // Reloj
	.trigger(1'b1),        // Inicio de conversión
	.in(cable_resultado_hex),      // Número binario de entrada
	.idle(),      // Si vale 0, indica una conversión en proceso
	.bcd(cable_display) // Resultado de la conversión
	);
	
DRIVER_DISPLAY DRIVER_DISPLAY_INST(
        .clock(CLK100MHZ),
        .numero_binario(cable_display),
        .sevensegment({CA,CB,CC,CD,CE,CF,CG,DP}),
        .AN(AN)
        );

UART_TX_CTRL UART_TX_INST(
        .clock(CLK100MHZ),
	    .reset(~CPU_RESETN),
	    .PB(triggger),           // Push Button
	    .dataIn16(cable_result),       // Dato que se desea transmitir de 16 bits
	    .tx_data(data_cable_tx),        // Datos entregados al driver UART para transmision
	    .tx_start(start_cable_tx),       // Pulso para iniciar transmision por la UART
	    .busy(tx_busy_out)
	);
	
endmodule
