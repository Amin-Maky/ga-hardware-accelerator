`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Academic Project
// Engineer: Prof. Ali Mahani
// 
// Create Date: Fall 2025
// Design Name: Genetic Algorithm Accelerator
// Module Name: lfsr_random
// Project Name: GA_Prj
// Target Devices: xc7vx485tffg1157-1 (Virtex-7)
// Tool Versions: Vivado 2024.2
// Description: 
// Original baseline Linear Feedback Shift Register (LFSR) module for 
// pseudo-random number generation.
// 
// Note: This version contains hardcoded feedback taps and a hardcoded 
// reset seed (8'hFF) that do not scale with the WIDTH parameter. Changing 
// the WIDTH in this version will break the maximal-length sequence or 
// cause synthesis warnings, intended for student enhancement.
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created (Original baseline code)
// Additional Comments:
// Initial unscalable version provided for academic RTL debugging tasks.
// 
//////////////////////////////////////////////////////////////////////////////////

module lfsr_random #(
    parameter WIDTH = 8
)(
    input logic clk,
    input logic rst_n,
    input logic enable,
    output logic [WIDTH-1:0] random_out
);
    // LFSR polynomial taps for maximum period
    // Using x^8 + x^6 + x^5 + x^4 + 1 for 8-bit LFSR
    logic [WIDTH-1:0] lfsr_reg;
    logic feedback;
    
    assign feedback = lfsr_reg[7] ^ lfsr_reg[5] ^ lfsr_reg[4] ^ lfsr_reg[3];
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Non-zero seed value
            lfsr_reg <= 8'hFF;
        end else if (enable) begin
            // Shift right and insert feedback bit
            lfsr_reg <= {feedback, lfsr_reg[WIDTH-1:1]};
        end
    end
    
    assign random_out = lfsr_reg;
endmodule
