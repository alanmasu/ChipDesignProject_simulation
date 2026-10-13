source /PATH/TO/environment.tcl

set init_verilog $NETLIST
set init_top_cell $TOP
set init_lef_file [list $TECH_LEF $CELL_LEF $PHYS_LEF]
set init_mmmc_file $MMMC

setDesignMode -process 130
set init_gnd_net VSS
set init_pwr_net VDD

# Exact command/options can vary by Innovus release.
init_design

checkDesign -all > $REPORT_DIR/01_checkDesign.rpt
check_timing > $REPORT_DIR/01_check_timing.rpt
report_analysis_views > $REPORT_DIR/01_analysis_views.rpt
report_constraint -all_violators > $REPORT_DIR/01_constraints.rpt
report_area > $REPORT_DIR/01_area.rpt
report_timing -max_paths 10 > $REPORT_DIR/01_timing.rpt

saveDesign $DB_DIR/01_initialized.enc

# Baseline experiment. Change ONE variable at a time.
# floorPlan -site CoreSite -r 1 0.75 10 10 10 10
checkFPlan

# Pin assignment is a deliberate physical decision.
# Use the installed Innovus editPin syntax.
checkPinAssignment
legalizePin

report_area > $REPORT_DIR/02_floorplan_area.rpt
report_timing -max_paths 10 > $REPORT_DIR/02_floorplan_timing.rpt
reportCongestion -overflow > $REPORT_DIR/02_floorplan_congestion.rpt

saveDesign $DB_DIR/02_floorplan.enc

# Power planning is technology dependent.
# Define VDD/VSS, rings, stripes and standard-cell rail connections.
#
# globalNetConnect VDD -type pgpin -pin VDD -all
# globalNetConnect VSS -type pgpin -pin VSS -all
# addRing ...
# addStripe ...
# sroute ...
#
# Do not copy stripe width/spacing without checking local technology rules.

report_area > $REPORT_DIR/03_power_area.rpt
saveDesign $DB_DIR/03_power.enc
# run a useful congestion experiment in Innovus: 1-Adjust stripe layers or pitch, 2-Reduce utilization or spread a hotspot

# Typical placement concept:
place_opt_design

report_area > $REPORT_DIR/04_place_area.rpt
report_timing -max_paths 20 > $REPORT_DIR/04_place_timing.rpt
reportCongestion -overflow > $REPORT_DIR/04_place_congestion.rpt

saveDesign $DB_DIR/04_place.enc

timeDesign -preCTS

# Typical pre-CTS optimization concept:
optDesign -preCTS

report_area > $REPORT_DIR/05_prects_area.rpt
report_timing -max_paths 20 > $REPORT_DIR/05_prects_timing.rpt
reportCongestion -overflow > $REPORT_DIR/05_prects_congestion.rpt

saveDesign $DB_DIR/05_pre_cts.enc


# Modern Innovus CTS is commonly handled through CCOpt.
# Typical concepts:
create_ccopt_clock_tree_spec
ccopt_design

report_timing -max_paths 20 > $REPORT_DIR/06_cts_timing.rpt
report_clock_tree > $REPORT_DIR/06_clock_tree.rpt

saveDesign $DB_DIR/06_cts.enc
