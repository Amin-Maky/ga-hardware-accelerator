`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Academic Project
// Engineer: Original code by Prof. Ali Mahani, Debugged & Optimized by Amin Maky
// 
// Create Date: Fall 2025
// Design Name: Genetic Algorithm Accelerator
// Module Name: selection
// Project Name: GA_Prj
// Target Devices: xc7vx485tffg1157-1 (Virtex-7)
// Tool Versions: Vivado 2024.2
// Description: 
// Optimized Roulette Wheel Selection module. Selects a parent based on its 
// fitness value relative to the total population fitness.
// 
// Modifications by Amin Maky:
// - Increased default CHROMOSOME_WIDTH to 16.
// - Hardware Optimization: Added (* use_dsp = "yes" *) to force the heavy 
//   multiplication logic into dedicated DSP slices, saving LUTs and improving 
//   timing closure.
// - Arithmetic Fix: Introduced an intermediate 'scaled' signal with explicit 
//   width (CHROMOSOME_WIDTH + FITNESS_WIDTH) to prevent data truncation during 
//   the multiplication step.
// - FSM Synchronization: Fixed the handshake logic. The FSM now waits in the 
//   DONE state until 'start_selection' is deasserted, preventing unintended 
//   re-triggering.
// - Safety: Added a boundary condition check (current_idx < POPULATION_SIZE-1) 
//   in the SPINNING state to prevent out-of-bounds memory access.
// 
// Dependencies: lfsr_random
// 
// Revision:
// Revision 0.01 - File Created (Original code provided by Prof. Mahani)
// Revision 1.00 - FSM fixed and DSP optimization applied (Amin Maky)
// Additional Comments:
// Version matches GitHub release v1.0.0.
// 
//////////////////////////////////////////////////////////////////////////////////

module selection #(
    parameter CHROMOSOME_WIDTH = 16,
    parameter POPULATION_SIZE = 16,
    parameter ADDR_WIDTH = $clog2(POPULATION_SIZE),
    parameter FITNESS_WIDTH = 10  // Wider to accommodate sum of fitness values
)(
    input logic clk,
    input logic rst_n,
    input logic start_selection,
    input logic [FITNESS_WIDTH-1:0] fitness_values [POPULATION_SIZE-1:0],
    input logic [FITNESS_WIDTH-1:0] total_fitness,
    output logic [ADDR_WIDTH-1:0] selected_parent,
    output logic selection_done
);
    // States for selection FSM
    typedef enum logic [1:0] {
        IDLE,
        SPINNING,
        DONE
    } state_t;
    
    state_t state, next_state;
    (* shreg_extract = "yes" *)
    logic [FITNESS_WIDTH-1:0] roulette_position;
    logic [FITNESS_WIDTH-1:0] fitness_sum;
    logic [ADDR_WIDTH-1:0] current_idx;
    
    // LFSR for random number generation
    logic lfsr_enable;
    logic [CHROMOSOME_WIDTH-1:0] random_value;
    
    lfsr_random #(
        .WIDTH(CHROMOSOME_WIDTH)
    ) lfsr_inst (
        .clk(clk),
        .rst_n(rst_n),
        .enable(lfsr_enable),
        .random_out(random_value)
    );
    
    (* use_dsp = "yes" *)
    logic [CHROMOSOME_WIDTH + FITNESS_WIDTH - 1:0] scaled; // temp
    // Scale random value to total fitness range
    always_comb begin
        // Scale random number to be between 0 and total_fitness
        scaled = random_value * total_fitness;
        roulette_position = scaled >> CHROMOSOME_WIDTH;
        // roulette_position = (random_value * total_fitness) >> CHROMOSOME_WIDTH;
    end
    
    // Selection FSM
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            fitness_sum <= '0;
            current_idx <= '0;
            selected_parent <= '0;
            selection_done <= 1'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    fitness_sum <= '0;
                    current_idx <= '0;
                    selection_done <= 1'b0;
                end
                
                SPINNING: begin
                    if (fitness_sum + fitness_values[current_idx] >= roulette_position) begin
                        selected_parent <= current_idx;
                        selection_done <= 1'b1;
                    end else if (current_idx < POPULATION_SIZE-1) begin
                        fitness_sum <= fitness_sum + fitness_values[current_idx];
                        current_idx <= current_idx + 1'b1;
                    end
                end
                
                DONE: begin
                    // Maintain selected_parent and selection_done until top module clears start_selection
                    selection_done <= 1'b0; // ready for next selection ...
                end
            endcase
        end
    end
    
    // Next state logic
    always_comb begin
        next_state = state;
        lfsr_enable = 1'b0;
        
        case (state)
            IDLE: begin
                if (start_selection) begin
                    next_state = SPINNING;
                    lfsr_enable = 1'b1;
                end
            end
            
            SPINNING: if (selection_done) next_state = DONE;
            /*
            begin
                if (fitness_sum + fitness_values[current_idx] >= roulette_position || 
                    current_idx == POPULATION_SIZE-1) begin
                    next_state = DONE;
                end
            end
            */
            DONE: if (!start_selection) next_state = IDLE;
            /*
            begin
                next_state = IDLE;
            end
            */
        endcase
    end
endmodule