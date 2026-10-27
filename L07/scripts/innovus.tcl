
source "/home/alanma/Chip-Design-Project/L07/scripts/environment.tcl"

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

saveDesign db/01_initialized.enc


# Baseline experiment. Change ONE variable at a time.
floorPlan -site CoreSite -r 1 0.75 20 20 20 20
checkFPlan

# Pin assignment is a deliberate physical decision.
# Use the installed Innovus editPin syntax.
checkPinAssignment
legalizePin

report_area > $REPORT_DIR/02_floorplan_area.rpt
report_timing -max_paths 10 > $REPORT_DIR/02_floorplan_timing.rpt
reportCongestion -overflow > $REPORT_DIR/02_floorplan_congestion.rpt

saveDesign db/02_floorplan.enc

# Power planning is technology dependent.
# Define VDD/VSS, rings, stripes and standard-cell rail connections.
#
globalNetConnect VDD -type pgpin -pin VDD -all
globalNetConnect VSS -type pgpin -pin VSS -all

setAddRingMode 
    -ring_target default 
    -extend_over_row 0 
    -ignore_rows 0 
    -avoid_short 0 
    -skip_crossing_trunks none 
    -stacked_via_top_layer met5 
    -stacked_via_bottom_layer met1 
    -via_using_exact_crossover_size 1 
    -orthogonal_only true 
    -skip_via_on_pin {  standardcell } 
    -skip_via_on_wire_shape {  noshape }
addRing 
    -nets {VSS VDD} 
    -around user_defined 
    -user_defined_region {} 
    -type core_rings 
    -layer {top met5 bottom met5 left met4 right met4} 
    -width {top 5 bottom 5 left 5 right 5} 
    -spacing {top 5 bottom 5 left 5 right 5} 
    -offset {top 2.5 bottom 2.5 left 2.5 right 2.5} 
    -center 0 
    -threshold 0 
    -jog_distance 0 
    -snap_wire_center_to_grid None

# Vertcal power stipes
setAddStripeMode 
    -ignore_block_check false 
    -break_at none 
    -route_over_rows_only false 
    -rows_without_stripes_only false 
    -extend_to_closest_target none 
    -stop_at_last_wire_for_area false 
    -partial_set_thru_domain false 
    -ignore_nondefault_domains false 
    -trim_antenna_back_to_shape none 
    -spacing_type edge_to_edge 
    -spacing_from_block 0 
    -stripe_min_length stripe_width 
    -stacked_via_top_layer met5 
    -stacked_via_bottom_layer met1 
    -via_using_exact_crossover_size false 
    -split_vias false 
    -orthogonal_only true 
    -allow_jog { padcore_ring  block_ring } 
    -skip_via_on_pin {  standardcell } 
    -skip_via_on_wire_shape {  noshape   }
addStripe 
    -nets {VSS VDD} 
    -layer met4 
    -direction vertical 
    -width 4 
    -spacing 4 
    -number_of_sets 4 
    -start_from left 
    -start_offset 75 
    -stop_offset 75 
    -switch_layer_over_obs false 
    -max_same_layer_jog_length 2 
    -padcore_ring_top_layer_limit met5 
    -padcore_ring_bottom_layer_limit met1 
    -block_ring_top_layer_limit met5 
    -block_ring_bottom_layer_limit met1 
    -use_wire_group 0 
    -snap_wire_center_to_grid None

# # Horizontal power stripes
# setAddStripeMode 
#     -ignore_block_check false 
#     -break_at none 
#     -route_over_rows_only false 
#     -rows_without_stripes_only false 
#     -extend_to_closest_target none 
#     -stop_at_last_wire_for_area false 
#     -partial_set_thru_domain false 
#     -ignore_nondefault_domains false 
#     -trim_antenna_back_to_shape none 
#     -spacing_type edge_to_edge 
#     -spacing_from_block 0 
#     -stripe_min_length stripe_width 
#     -stacked_via_top_layer met5 
#     -stacked_via_bottom_layer met1 
#     -via_using_exact_crossover_size false 
#     -split_vias false 
#     -orthogonal_only true 
#     -allow_jog { padcore_ring  block_ring } 
#     -skip_via_on_pin {  standardcell } 
#     -skip_via_on_wire_shape {  noshape   }

# addStripe 
#     -nets {VSS VDD} 
#     -layer met5 
#     -direction horizontal 
#     -width 4 
#     -spacing 4 
#     -number_of_sets 4 
#     -start_from bottom 
#     -start_offset 75 
#     -stop_offset 75 
#     -switch_layer_over_obs false 
#     -max_same_layer_jog_length 2 
#     -padcore_ring_top_layer_limit met5 
#     -padcore_ring_bottom_layer_limit met1 
#     -block_ring_top_layer_limit met5 
#     -block_ring_bottom_layer_limit met1 
#     -use_wire_group 0 
#     -snap_wire_center_to_grid None

# Power Rails
setSrouteMode -viaConnectToShape { noshape }
sroute -connect { blockPin padPin padRing corePin floatingStripe } -layerChangeRange { met1(1) met5(5) } -blockPinTarget { nearestTarget } -padPinPortConnect { allPort oneGeom } -padPinTarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -floatingStripeTarget { blockring padring ring stripe ringpin blockpin followpin } -allowJogging 1 -crossoverViaLayerRange { met1(1) met5(5) } -nets { VDD VSS } -allowLayerChange 1 -blockPin useLef -targetViaLayerRange { met1(1) met5(5) }

# Do not copy stripe width/spacing without checking local technology rules.

report_area > $REPORT_DIR/03_power_area.rpt
saveDesign db/03_power.enc

# run a useful congestion experiment in Innovus: 1-Adjust stripe layers or pitch, 2-Reduce utilization or spread a hotspot

# Typical placement concept:
place_opt_design

report_area > $REPORT_DIR/04_place_area.rpt
report_timing -max_paths 20 > $REPORT_DIR/04_place_timing.rpt
reportCongestion -overflow > $REPORT_DIR/04_place_congestion.rpt

saveDesign db/04_place.enc

timeDesign -preCTS

# Typical pre-CTS optimization concept:
optDesign -preCTS

report_area > $REPORT_DIR/05_prects_area.rpt
report_timing -max_paths 20 > $REPORT_DIR/05_prects_timing.rpt
reportCongestion -overflow > $REPORT_DIR/05_prects_congestion.rpt

saveDesign db/05_pre_cts.enc


# Modern Innovus CTS is commonly handled through CCOpt.
# Typical concepts:
create_ccopt_clock_tree_spec
ccopt_design

report_timing -max_paths 20 > $REPORT_DIR/06_cts_timing.rpt
report_clock_tree > $REPORT_DIR/06_cts_clock_tree.rpt
report_area > $REPORT_DIR/06_cts_area.rpt
reportCongestion -overflow > $REPORT_DIR/06_cts_congestion.rpt

saveDesign db/06_cts.enc

optDesign -postCTS
timeDesign -postCTS -outDir $REPORT_DIR/07_postcts_timeDesign.rpt

report_timing -max_paths 20 > $REPORT_DIR/07_postcts_timing.rpt
report_clock_tree > $REPORT_DIR/07_postcts_clock_tree.rpt
report_area > $REPORT_DIR/07_postcts_area.rpt
reportCongestion -overflow > $REPORT_DIR/07_postcts_congestion.rpt
report_constraint -all_violators > $REPORT_DIR/07_postcts_constraint.rpt

saveDesign db/07_postcts.enc



routeDesign -globalDetail

reportCongestion -overflow > $REPORT_DIR/08_route_congestion_of.rpt
reportCongestion -hotSpot > $REPORT_DIR/08_route_congestion_hs.rpt
report_timing -max_paths 20 > $REPORT_DIR/08_route_timing.rpt
report_clock_tree > $REPORT_DIR/08_route_clock_tree.rpt
report_area > $REPORT_DIR/08_route_area.rpt
reportCongestion -overflow > $REPORT_DIR/08_route_congestion.rpt
report_constraint -all_violators > $REPORT_DIR/08_route_constraint.rpt

extractRC
rcOut -spef $REPORT_DIR/08_route_rc.spef

saveDesign db/08_route.enc


optDesign -postRoute

reportCongestion -overflow > $REPORT_DIR/09_postroute_congestion_of.rpt
reportCongestion -hotSpot > $REPORT_DIR/09_postroute_congestion_hs.rpt
report_timing -max_paths 20 > $REPORT_DIR/09_postroute_timing.rpt
report_timing -early -max_paths 20 > $REPORT_DIR/09_postroute_timing_hold.rpt
report_area > $REPORT_DIR/09_postroute_area.rpt
reportCongestion -overflow > $REPORT_DIR/09_postroute_congestion.rpt
report_constraint -all_violators > $REPORT_DIR/09_postroute_constraint.rpt
check_timing

extractRC
rcOut -spef $REPORT_DIR/09_postroute_rc.spef

timeDesign -postRoute -outDir $REPORT_DIR/09_postroute_timeDesign.rpt

verify_drc
verifyConnectivity -type all
