set TOP aes128_iterative

## Search on the local path if $BASE_DIR/env.tcl exists and source it if found.
if {[file exists $BASE_DIR/env.tcl]} {
    source $BASE_DIR/env.tcl
} else {
    puts "Warning: env.tcl not found, using default paths."
    set SKY130_DIR "/cad/dk/c/Sky130"
    # LEF files definition
}
set CELL_LEF "$SKY130_DIR/sky130_scl_9T_0.1.2/sky130_scl_9T/lef/sky130_scl_9T.lef"
set TECH_LEF "$SKY130_DIR/sky130_scl_9T_0.1.2/sky130_scl_9T_tech/lef/sky130_scl_9T.tlef"
set PHYS_LEF "$SKY130_DIR/sky130_scl_9T_0.1.2/sky130_scl_9T_tech/lef/sky130_scl_9T_phyCells.lef"

set NETLIST  "$BL_DIR/baseline_mapped.v"
set MMMC     "$SCRIPT_DIR/mmmc.tcl"
