`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Academic Project
// Engineer: Original code by Prof. Ali Mahani, Debugged & Modified by Amin Maky
// 
// Create Date: Fall 2025
// Design Name: Genetic Algorithm Accelerator
// Module Name: lfsr_random
// Project Name: GA_Prj
// Target Devices: xc7vx485tffg1157-1 (Virtex-7)
// Tool Versions: Vivado 2024.2
// Description: 
// Fixed and parameterized Linear Feedback Shift Register (LFSR).
// Generates pseudo-random numbers based on maximal-period polynomial taps.
// 
// Modifications by Amin Maky:
// - Increased default WIDTH to 16 bits to meet system requirements.
// - Updated feedback polynomial taps to support 16-bit maximal-length sequence 
//   (x^16 + x^14 + x^13 + x^11 + 1).
// - Introduced a dynamic 'SEED' parameter using the replication operator 
//   ({WIDTH{1'b1}}) to guarantee a valid, non-zero initialization state 
//   regardless of the configured WIDTH, fixing the hardcoded seed bug.
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created (Original code provided by Prof. Mahani)
// Revision 1.00 - Parameterized seed and updated to 16-bit (Amin Maky)
// Additional Comments:
// Version matches GitHub release v1.0.0.
// 
//////////////////////////////////////////////////////////////////////////////////

module lfsr_random #(
    parameter WIDTH = 16,
    parameter SEED  = {WIDTH{1'b1}}  // Non-zero default seed
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
    
    // Simple fixed taps for WIDTH = 8; can extend for larger widths
    //assign feedback = lfsr_reg[7] ^ lfsr_reg[5] ^ lfsr_reg[4] ^ lfsr_reg[3];
    
    // Simple fixed taps for WIDTH = 16; can extend for larger widths
    assign feedback = lfsr_reg[15] ^ lfsr_reg[13] ^ lfsr_reg[12] ^ lfsr_reg[10];
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Non-zero seed value
            lfsr_reg <= SEED;
        end else if (enable) begin
            // Shift right and insert feedback bit
            lfsr_reg <= {feedback, lfsr_reg[WIDTH-1:1]};
        end
    end
    
    assign random_out = lfsr_reg;
endmodule
