set TOP aes128_iterative

set BASE_DIR "/home/alanma/Chip-Design-Project/L07"

set SCRIPT_DIR "$BASE_DIR/scripts"
set REPORT_DIR  "reports"

set BL_DIR "$BASE_DIR/genus_results_bl"
set DB_DIR "$BL_DIR/baseline.db"

# LEF files definition
set CELL_LEF "/cad/dk/c/Sky130/sky130_scl_9T_0.1.2/sky130_scl_9T/lef/sky130_scl_9T.lef"
set TECH_LEF "/cad/dk/c/Sky130/sky130_scl_9T_0.1.2/sky130_scl_9T_tech/lef/sky130_scl_9T.tlef"
set PHYS_LEF "/cad/dk/c/Sky130/sky130_scl_9T_0.1.2/sky130_scl_9T_tech/lef/sky130_scl_9T_phyCells.lef"


set NETLIST  "$BL_DIR/baseline_mapped.v"
set MMMC     "$SCRIPT_DIR/mmmc.tcl"

# Replace all placeholders with the local course installation.
