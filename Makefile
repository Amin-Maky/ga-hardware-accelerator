.PHONY: all sim project clean

all: sim

sim:
	@echo "Running Smoke Testbench..."
	mkdir -p fpga/build
	cd fpga/build && xvlog -sv ../../rtl/*.sv ../../tb/sv/tb_genetic_algorithm_smoke.sv
	cd fpga/build && xelab tb_genetic_algorithm_smoke -s top_sim
	cd fpga/build && xsim top_sim -R

project:
	@echo "Generating Vivado Project..."
	mkdir -p fpga/build
	cd fpga/build && vivado -mode batch -source ../vivado/Ga_Prj.tcl -nojournal -nolog

clean:
	@echo "Cleaning build artifacts..."
	rm -rf fpga/build/* *.log *.jou

