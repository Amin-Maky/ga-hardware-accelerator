`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Academic Project
// Engineer: Prof. Ali Mahani
// 
// Create Date: Fall 2025
// Design Name: Genetic Algorithm Accelerator
// Module Name: fitness_evaluator
// Project Name: GA_Prj
// Target Devices: xc7vx485tffg1157-1 (Virtex-7)
// Tool Versions: Vivado 2024.2
// Description: 
// Original baseline module for evaluating chromosome fitness. 
// Uses a basic One-Max problem approach (counting the number of '1' bits).
// 
// Note: This version contains an intentional RTL coding bug. It uses 
// non-blocking assignments ('<=') inside a for-loop for accumulation, 
// which results in incorrect synthesis and logical failure, intended 
// for student debugging.
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created (Original baseline code)
// Additional Comments:
// Initial buggy version provided for academic RTL debugging tasks.
// 
//////////////////////////////////////////////////////////////////////////////////

module fitness_evaluator #(
    parameter CHROMOSOME_WIDTH = 8,
    parameter FITNESS_WIDTH = 10
)(
    input logic clk,
    input logic rst_n,
    input logic start_evaluation,
    input logic [CHROMOSOME_WIDTH-1:0] chromosome,
    output logic [FITNESS_WIDTH-1:0] fitness,
    output logic evaluation_done
);
    // Example fitness function: count number of '1' bits (maximize)
    // Replace with your specific fitness function
    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            fitness <= '0;
            evaluation_done <= 1'b0;
        end else if (start_evaluation) begin
            fitness <= '0;
            // Count '1' bits
            for (int i = 0; i < CHROMOSOME_WIDTH; i++) begin
                if (chromosome[i]) begin
                    fitness <= fitness + 1'b1;
                end
            end
            evaluation_done <= 1'b1;
        end else begin
            evaluation_done <= 1'b0;
        end
    end
endmodule