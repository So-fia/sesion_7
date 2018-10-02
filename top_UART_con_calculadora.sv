`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.05.2018 19:26:02
// Design Name: 
// Module Name: top_UART_con_calculadora
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


module top_UART_con_calculadora(
        input logic CLK100MHZ, CPU_RESETN, UART_TXD_IN,
        output logic [7:0] AN,
        output logic CA, CB, CC, CD, CE, CF, CG, DP
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

logic [15:0] cable_OPA, cable_OPB;
logic [1:0] cable_operacion;
logic [11:0] stateID;

    UART_RX_CTRL uart_rx_ctrl_inst(
        .clock(CLK100MHZ),
        .rx_ready(start_cable),
        .rx_data(data_cable),
        .reset(rst),
        .OP_A(cable_OPA),
        .OP_B(cable_OPB),
        .operacion(cable_operacion),
        .trigger(),
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

endmodule
