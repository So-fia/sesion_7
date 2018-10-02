`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.05.2018 17:25:26
// Design Name: 
// Module Name: ALU_sw
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


module ALU_sw #(parameter N = 16) (
input logic [N-1:0] A, B,
input logic [1:0] SW,
output logic [N-1:0] Result
    );
    
 always_comb begin
    case (SW)
        2'b00: Result = A+B;
        2'b01: Result = A-B;
        2'b10: Result = A|B;
        2'b11: Result = A&B;
        default: Result = 16'd0;
        endcase
        end
 
endmodule
