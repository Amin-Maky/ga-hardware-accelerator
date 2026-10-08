`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Academic Project
// Engineer: Prof. Ali Mahani
// 
// Create Date: Fall 2025
// Design Name: Genetic Algorithm Accelerator
// Module Name: crossover
// Project Name: GA_Prj
// Target Devices: xc7vx485tffg1157-1 (Virtex-7)
// Tool Versions: Vivado 2024.2
// Description: 
// Original baseline module for single-point crossover operation. 
// Takes two parent chromosomes and generates a child based on a crossover point.
// 
// Note: This version contains intentional Verilog part-select syntax limitations 
// and hardcoded bit-slicing (ignoring the actual crossover_point) intended 
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

module crossover #(
    parameter CHROMOSOME_WIDTH = 8
)(
    input logic clk,
    input logic rst_n,
    input logic start_crossover,
    input logic [CHROMOSOME_WIDTH-1:0] parent1,
    input logic [CHROMOSOME_WIDTH-1:0] parent2,
    input logic [2:0] crossover_point, // Point at which to split the chromosomes
    output logic [CHROMOSOME_WIDTH-1:0] child,
    output logic crossover_done
);
    // Crossover logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            child <= '0;
            crossover_done <= 1'b0;
        end else if (start_crossover) begin
            // Single-point crossover
     //       child <= {parent1[CHROMOSOME_WIDTH-1:crossover_point], parent2[crossover_point-1:0]};
            child <= {parent1[CHROMOSOME_WIDTH-1:2], parent2[2:0]};
            crossover_done <= 1'b1;
        end else begin
            crossover_done <= 1'b0;
        end
    end
endmodule