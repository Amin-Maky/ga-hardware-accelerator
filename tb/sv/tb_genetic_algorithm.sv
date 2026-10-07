`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/30/2025 07:32:00 PM
// Design Name: 
// Module Name: GeneticAlgorithmTop_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_genetic_algorithm;

    parameter CHROMOSOME_WIDTH = 16;
    parameter POPULATION_SIZE  = 16;
    parameter MAX_GENERATIONS  = 20;
    parameter FITNESS_WIDTH    = 10;

    logic clk;
    logic rst_n;
    logic start_ga;
    logic [CHROMOSOME_WIDTH-1:0] initial_population;
    logic [CHROMOSOME_WIDTH-1:0] best_chromosome;
    logic [FITNESS_WIDTH-1:0]    best_fitness;
    logic ga_done;

    // DUT
    genetic_algorithm #(
        .CHROMOSOME_WIDTH(CHROMOSOME_WIDTH),
        .POPULATION_SIZE(POPULATION_SIZE),
        .MAX_GENERATIONS(MAX_GENERATIONS),
        .FITNESS_WIDTH(FITNESS_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .start_ga(start_ga),
        .initial_population(initial_population),
        .best_chromosome(best_chromosome),
        .best_fitness(best_fitness),
        .ga_done(ga_done)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz
    end

    initial begin
        rst_n = 0;
        start_ga = 0;
        initial_population = 0;

        #20;
        rst_n = 1; // End Reseting ...

        #10;
        start_ga = 1; // Start
        #10;          // and wait for one clk ...
        start_ga = 0;
        
        for (int i=0; i<POPULATION_SIZE; i++) begin
            initial_population = $random;
            @(posedge clk);
        end

        wait(ga_done);

        $display("==================================");
        $display("Genetic Algorithm Finished!");
        $display("Best Chromosome = %b", best_chromosome);
        $display("Best Fitness    = %d", best_fitness);
        $display("==================================");

        #20;
        $stop;
    end

    // just for checking ... (debug)
    initial begin
        $monitor("t=%0t | ga_done=%b | best_chromosome=%h | best_fitness=%d",
                 $time, ga_done, best_chromosome, best_fitness);
    end

endmodule
