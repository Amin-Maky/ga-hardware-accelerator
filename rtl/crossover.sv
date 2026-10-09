`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Academic Project
// Engineer: Original code by Prof. Ali Mahani, Debugged & Modified by Amin Maky
// 
// Create Date: Fall 2025
// Design Name: Genetic Algorithm Accelerator
// Module Name: crossover
// Project Name: GA_Prj
// Target Devices: xc7vx485tffg1157-1 (Virtex-7)
// Tool Versions: Vivado 2024.2
// Description: 
// Fixed and fully parameterized single-point crossover module. 
// Dynamically splits two parent chromosomes and combines them into a child 
// without violating Verilog's constant part-select constraints.
// 
// Modifications by Amin Maky:
// - Fixed the illegal dynamic part-select error by implementing a dynamic 
//   bitwise mask generated via combinational logic shifting.
// - Parameterized 'crossover_point' width using $clog2(CHROMOSOME_WIDTH).
// - Added boundary constraints (0 and max width) for the crossover point.
// - Guided synthesis tool using 'shreg_extract' attribute for optimal mapping.
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created (Original code provided by Prof. Mahani)
// Revision 1.00 - Debugged, parameterized, and masked (Amin Maky)
// Additional Comments:
// Version matches GitHub release v1.0.0.
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
    input logic [$clog2(CHROMOSOME_WIDTH)-1:0] crossover_point, // Point at which to split the chromosomes
    output logic [CHROMOSOME_WIDTH-1:0] child,
    output logic crossover_done
);

    logic [$clog2(CHROMOSOME_WIDTH):0] cp; // temp
    (* shreg_extract = "yes" *)
    logic [CHROMOSOME_WIDTH-1:0] mask;
    logic [CHROMOSOME_WIDTH-1:0] mixed;
    
    
    always_comb begin
        cp = crossover_point;
        
        if (cp == 0)
            cp = 1;
        else if (cp > CHROMOSOME_WIDTH-1)
            cp = CHROMOSOME_WIDTH-1;

        mask  = {CHROMOSOME_WIDTH{1'b1}} >> (CHROMOSOME_WIDTH - cp);
        mixed = (parent1 & ~mask) | (parent2 & mask);
    end
    // Crossover logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            child <= '0;
            crossover_done <= 1'b0;
        end else if (start_crossover) begin
            // Single-point crossover
            // child <= {parent1[CHROMOSOME_WIDTH-1:2], parent2[2:0]};
            // child <= { parent1[CHROMOSOME_WIDTH-1:crossover_point], parent2[crossover_point-1:0] }; Error!!
            child <= mixed;
            crossover_done <= 1'b1;
        end else begin
            crossover_done <= 1'b0;
        end
    end
endmodule