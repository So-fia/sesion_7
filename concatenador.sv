`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.05.2018 00:38:08
// Design Name: 
// Module Name: concatenador
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


module concatenador(
    input logic [7:0] OP_1, OP_2,
    output logic [15:0] DATA16
    );
    
assign DATA16=[OP_1, OP_2};

endmodule
