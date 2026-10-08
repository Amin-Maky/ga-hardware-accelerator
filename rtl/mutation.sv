`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Academic Project
// Engineer: Prof. Ali Mahani
// 
// Create Date: Fall 2025
// Design Name: Genetic Algorithm Accelerator
// Module Name: mutation
// Project Name: GA_Prj
// Target Devices: xc7vx485tffg1157-1 (Virtex-7)
// Tool Versions: Vivado 2024.2
// Description: 
// Original baseline module for the mutation step in the Genetic Algorithm.
// Iterates over the chromosome and flips bits based on a mutation probability.
// 
// Note: This version contains an intentional logic and width-mismatch bug. 
// Inside the loop, a 1-bit value (mutation_mask[i]) is directly compared 
// against an 8-bit threshold (mutation_rate), rendering the probability 
// logic fundamentally flawed. Intended for student debugging.
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created (Original baseline code)
// Additional Comments:
// Initial buggy version provided for academic RTL debugging tasks.
// 
//////////////////////////////////////////////////////////////////////////////////

module mutation #(
    parameter CHROMOSOME_WIDTH = 8
)(
    input logic clk,
    input logic rst_n,
    input logic start_mutation,
    input logic [CHROMOSOME_WIDTH-1:0] child_in,
    input logic [CHROMOSOME_WIDTH-1:0] mutation_mask, // Random bits to determine mutation
    input logic [7:0] mutation_rate, // 0-255, higher means more likely to mutate
    output logic [CHROMOSOME_WIDTH-1:0] child_out,
    output logic mutation_done
);
    // Mutation logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            child_out <= '0;
            mutation_done <= 1'b0;
        end else if (start_mutation) begin
            // For each bit, apply mutation if random value < mutation_rate
            for (int i = 0; i < CHROMOSOME_WIDTH; i++) begin
                // If random bit < mutation_rate, flip the bit
                child_out[i] <= (mutation_mask[i] < mutation_rate) ? ~child_in[i] : child_in[i];
                // how???
            end
            mutation_done <= 1'b1;
        end else begin
            mutation_done <= 1'b0;
        end
    end
endmodule