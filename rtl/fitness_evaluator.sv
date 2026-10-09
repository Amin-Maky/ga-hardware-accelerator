`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Academic Project
// Engineer: Original code by Prof. Ali Mahani, Debugged & Modified by Amin Maky
// 
// Create Date: Fall 2025
// Design Name: Genetic Algorithm Accelerator
// Module Name: fitness_evaluator
// Project Name: GA_Prj
// Target Devices: xc7vx485tffg1157-1 (Virtex-7)
// Tool Versions: Vivado 2024.2
// Description: 
// Fixed fitness evaluator module. Correctly implements the One-Max fitness 
// function to count active bits in a chromosome.
// 
// Modifications by Amin Maky:
// - Fixed the accumulation bug inside the for-loop by introducing a 
//   combinational intermediate variable ('fitness_next') and using blocking 
//   assignments ('=') to properly generate the adder chain logic.
// - Assigned the final accumulated value to the output register using 
//   non-blocking assignment ('<=') to ensure correct sequential behavior.
// - Added '!evaluation_done' constraint to the start condition to prevent 
//   glitches and redundant re-evaluations if 'start_evaluation' is held high.
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created (Original code provided by Prof. Mahani)
// Revision 1.00 - RTL accumulation bug fixed and optimized (Amin Maky)
// Additional Comments:
// Version matches GitHub release v1.0.0.
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
    
    logic [FITNESS_WIDTH-1:0] fitness_next;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            fitness <= '0;
            evaluation_done <= 1'b0;
        end else if (start_evaluation && !evaluation_done) begin
            fitness_next = '0;
            for (int i = 0; i < CHROMOSOME_WIDTH; i++) begin
                if (chromosome[i])
                    fitness_next = fitness_next + 1'b1;
            end
            fitness <= fitness_next;
            evaluation_done <= 1'b1;
        end else begin
            evaluation_done <= 1'b0;
        end
    end

endmodule