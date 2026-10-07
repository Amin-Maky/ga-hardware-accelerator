# This script was edited by Am/148.

set ROOT [file normalize [file join [file dirname [info script]] "../../rtl"]]

set SIMROOT [file normalize [file join [file dirname [info script]] "../../tb"]]

create_project Ga_Prj $ROOT/../fpga/build/Ga_Prj -part xc7vx485tffg1157-1 -force

# Add simulation (testbench) files
add_files -norecurse -fileset [current_fileset] [list \
    $ROOT/crossover.sv \
    $ROOT/fitness_evaluator.sv \
    $ROOT/genetic_algorithm.sv \
    $ROOT/lfsr_random.sv \
    $ROOT/mutation.sv \
    $ROOT/population_memory.sv \
    $ROOT/selection.sv \
]

# Set Top Module explicitly
set_property top genetic_algorithm [current_fileset]

# Add simulation (testbench) files
add_files -norecurse -fileset [current_fileset -simset] [list \
    $SIMROOT/sv/tb_genetic_algorithm.sv \
]

# Set the top module for simulation
set_property top tb_genetic_algorithm [current_fileset -simset]

