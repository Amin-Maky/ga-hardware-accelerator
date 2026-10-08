`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Academic Project
// Engineer: Prof. Ali Mahani
// 
// Create Date: Fall 2025
// Design Name: Genetic Algorithm Accelerator
// Module Name: population_memory
// Project Name: GA_Prj
// Target Devices: xc7vx485tffg1157-1 (Virtex-7)
// Tool Versions: Vivado 2024.2
// Description: 
// Original baseline memory module for storing the genetic algorithm population.
// Implements a simple synchronous write, asynchronous read memory array.
// 
// Note: This version lacks explicit synthesis directives. Depending on the 
// POPULATION_SIZE, Vivado might infer Distributed RAM (using LUTs/FFs) 
// instead of Block RAM, leading to inefficient resource utilization.
// 
// Dependencies: None
// 
// Revision:
// Revision 0.01 - File Created (Original baseline code)
// Additional Comments:
// Initial version provided for academic RTL optimization tasks.
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
   logic [CHROMOSOME_WIDTH-1:0] population [POPULATION_SIZE-1:0];
    
    always_ff @(posedge clk) begin
        if (write_enable) begin
            population[write_addr] <= write_data;
        end
    end
    
    assign read_data = population[read_addr];
endmodule