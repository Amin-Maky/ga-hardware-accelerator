`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Academic Project
// Engineer: Original code by Prof. Ali Mahani, Debugged & Modified by Amin Maky
// 
// Create Date: Fall 2025
// Design Name: Genetic Algorithm Accelerator
// Module Name: mutation
// Project Name: GA_Prj
// Target Devices: xc7vx485tffg1157-1 (Virtex-7)
// Tool Versions: Vivado 2024.2
// Description: 
// Fixed mutation module. Correctly processes mutation probability for each 
// bit of the chromosome using proper bit-width matching.
// 
// Modifications by Amin Maky:
// - Increased default CHROMOSOME_WIDTH to 16.
// - Fixed the 1-bit vs 8-bit comparison bug by implementing a combinational 
//   expansion block. The 1-bit random values are replicated to 8 bits 
//   (either 8'h00 or 8'hFF) using the replication operator {8{...}}.
// - Utilized SystemVerilog's Indexed Part-Select syntax (+:) to dynamically 
//   slice and assign the expanded 8-bit segments cleanly inside the loop.
// - Separated the expansion logic (always_comb) from the sequential mutation 
//   logic (always_ff) for cleaner synthesis and better timing.
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created (Original code provided by Prof. Mahani)
// Revision 1.00 - Width mismatch fixed using Indexed Part-Select (Amin Maky)
// Additional Comments:
// Version matches GitHub release v1.0.0.
// 
//////////////////////////////////////////////////////////////////////////////////

module mutation #(
    parameter CHROMOSOME_WIDTH = 16
)(
    input logic clk,
    input logic rst_n,
    input logic start_mutation,
    input logic [CHROMOSOME_WIDTH-1:0] child_in,
    input logic [CHROMOSOME_WIDTH-1:0] random_values, // 8-bit random for each bit
    input logic [7:0] mutation_rate, // 0-255, higher means more likely to mutate
    output logic [CHROMOSOME_WIDTH-1:0] child_out,
    output logic mutation_done
);

    logic [CHROMOSOME_WIDTH*8-1:0] expanded_random;
    always_comb begin
        for (int i = 0; i < CHROMOSOME_WIDTH; i++) begin
            expanded_random[i*8 +: 8] = {8{random_values[i]}}; // hint : line 66
        end
    end

    // Mutation logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            child_out <= '0;
            mutation_done <= 1'b0;
        end else if (start_mutation) begin
            // For each bit, apply mutation if random value < mutation_rate
            for (int i = 0; i < CHROMOSOME_WIDTH; i++) begin
                // If random bit < mutation_rate, flip the bit
                if (expanded_random[i*8 +: 8] < mutation_rate) // hint : line 66
                    child_out[i] <= ~child_in[i];
                else
                    child_out[i] <= child_in[i];
                // child_out[i] <= (mutation_mask[i] < mutation_rate) ? ~child_in[i] : child_in[i];
                // how???
            end
            mutation_done <= 1'b1;
        end else begin
            mutation_done <= 1'b0;
        end
    end
endmodule

// it means like:
// data[0 +: 8]  : data[7:0]
// data[8 +: 8]  : data[15:8]
// data[16 +: 8] : data[23:16]
// data[24 +: 8] : data[31:24]
