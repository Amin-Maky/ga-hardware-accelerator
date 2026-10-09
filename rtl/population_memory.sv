`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Academic Project
// Engineer: Original code by Prof. Ali Mahani, Optimized by Amin Maky
// 
// Create Date: Fall 2025
// Design Name: Genetic Algorithm Accelerator
// Module Name: population_memory
// Project Name: GA_Prj
// Target Devices: xc7vx485tffg1157-1 (Virtex-7)
// Tool Versions: Vivado 2024.2
// Description: 
// Optimized memory module for storing the genetic algorithm population.
// 
// Modifications by Amin Maky:
// - Added the Vivado synthesis attribute (* ram_style = "block" *) to the 
//   population array. This forces the synthesizer to map the memory to 
//   dedicated Block RAM (BRAM) rather than consuming valuable LUTs/Registers 
//   (Distributed RAM). This hardware-aware optimization significantly improves 
//   resource utilization, routing efficiency, and power consumption for 
//   larger population sizes.
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created (Original code provided by Prof. Mahani)
// Revision 1.00 - Added explicit BRAM inference attribute (Amin Maky)
// Additional Comments:
// Version matches GitHub release v1.0.0.
// 
//////////////////////////////////////////////////////////////////////////////////

module population_memory #(
    parameter CHROMOSOME_WIDTH = 8,
    parameter POPULATION_SIZE = 16,
    parameter ADDR_WIDTH = $clog2(POPULATION_SIZE)
)(
    input logic clk,
    input logic rst_n,
    input logic write_enable,
    input logic [ADDR_WIDTH-1:0] write_addr,
    input logic [ADDR_WIDTH-1:0] read_addr,
    input logic [CHROMOSOME_WIDTH-1:0] write_data,
    output logic [CHROMOSOME_WIDTH-1:0] read_data
);
    // Register to store population
    (* ram_style = "block" *)
    logic [CHROMOSOME_WIDTH-1:0] population [POPULATION_SIZE-1:0];
    
    always_ff @(posedge clk) begin
        if (write_enable) begin
            population[write_addr] <= write_data;
        end
    end
    assign read_data = population[read_addr];
endmodule