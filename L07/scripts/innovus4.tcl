## Steps to run Innovus flow for the AES design.
# 0. doInitDesign
# 1. doFloorPlan
# 2. doPowerPlan
# 3. doPlaceCells
# 4. doPreCTS
# 5. doClockTreeSynthesis
# 6. doRoutingDesign
# 7. doPostRouteOptimization
# 8. doFinalChecks
#
# Use the following command to run the entire flow from scratch:
# doBuild 0 
#    or
# doBuildAll



# This will be a relative path to the working directory.
set WORK_DIR [exec pwd]
set BASE_DIR "$WORK_DIR/.."

set SCRIPT_DIR "$BASE_DIR/scripts"
set REPORT_DIR  "$WORK_DIR/reports"

set BL_DIR "$BASE_DIR/genus_results_bl"

## Exporting script path for re-load the same
set script_path [info script]
# set DB_DIR "$BL_DIR/baseline.db"

## Source the environment file to set up the Innovus environment variables and paths.
source "$SCRIPT_DIR/environment.tcl"

set init_verilog $NETLIST
set init_top_cell $TOP
set init_lef_file [list $TECH_LEF $CELL_LEF $PHYS_LEF]
set init_mmmc_file $SCRIPT_DIR/mmmc3.tcl

setDesignMode -process 130
set init_gnd_net VSS
set init_pwr_net VDD

file mkdir $REPORT_DIR db

# Exact command/options can vary by Innovus release.
proc doInitDesign {} {
    init_design


    checkDesign -all > $::REPORT_DIR/01_checkDesign.rpt
    check_timing > $::REPORT_DIR/01_check_timing.rpt
    report_analysis_views > $::REPORT_DIR/01_analysis_views.rpt
    report_constraint -all_violators > $::REPORT_DIR/01_constraints.rpt
    report_area > $::REPORT_DIR/01_area.rpt
    report_timing -max_paths 10 > $::REPORT_DIR/01_timing.rpt

    saveDesign db/01_initialized.enc
}

# Pin assignment is a deliberate physical decision.
proc doPinPlacement {} {
    # Place all input and spread it again to left edge
    getPinAssignMode -pinEditInBatch -quiet
    setPinAssignMode -pinEditInBatch true
    editPin -pinWidth 0.14 -pinDepth 0.595 -fixOverlap 1 -spreadDirection clockwise -edge 0 -layer 1 -spreadType side -pin {clk {key[0]} {key[1]} {key[2]} {key[3]} {key[4]} {key[5]} {key[6]} {key[7]} {key[8]} {key[9]} {key[10]} {key[11]} {key[12]} {key[13]} {key[14]} {key[15]} {key[16]} {key[17]} {key[18]} {key[19]} {key[20]} {key[21]} {key[22]} {key[23]} {key[24]} {key[25]} {key[26]} {key[27]} {key[28]} {key[29]} {key[30]} {key[31]} {key[32]} {key[33]} {key[34]} {key[35]} {key[36]} {key[37]} {key[38]} {key[39]} {key[40]} {key[41]} {key[42]} {key[43]} {key[44]} {key[45]} {key[46]} {key[47]} {key[48]} {key[49]} {key[50]} {key[51]} {key[52]} {key[53]} {key[54]} {key[55]} {key[56]} {key[57]} {key[58]} {key[59]} {key[60]} {key[61]} {key[62]} {key[63]} {key[64]} {key[65]} {key[66]} {key[67]} {key[68]} {key[69]} {key[70]} {key[71]} {key[72]} {key[73]} {key[74]} {key[75]} {key[76]} {key[77]} {key[78]} {key[79]} {key[80]} {key[81]} {key[82]} {key[83]} {key[84]} {key[85]} {key[86]} {key[87]} {key[88]} {key[89]} {key[90]} {key[91]} {key[92]} {key[93]} {key[94]} {key[95]} {key[96]} {key[97]} {key[98]} {key[99]} {key[100]} {key[101]} {key[102]} {key[103]} {key[104]} {key[105]} {key[106]} {key[107]} {key[108]} {key[109]} {key[110]} {key[111]} {key[112]} {key[113]} {key[114]} {key[115]} {key[116]} {key[117]} {key[118]} {key[119]} {key[120]} {key[121]} {key[122]} {key[123]} {key[124]} {key[125]} {key[126]} {key[127]} {plaintext[0]} {plaintext[1]} {plaintext[2]} {plaintext[3]} {plaintext[4]} {plaintext[5]} {plaintext[6]} {plaintext[7]} {plaintext[8]} {plaintext[9]} {plaintext[10]} {plaintext[11]} {plaintext[12]} {plaintext[13]} {plaintext[14]} {plaintext[15]} {plaintext[16]} {plaintext[17]} {plaintext[18]} {plaintext[19]} {plaintext[20]} {plaintext[21]} {plaintext[22]} {plaintext[23]} {plaintext[24]} {plaintext[25]} {plaintext[26]} {plaintext[27]} {plaintext[28]} {plaintext[29]} {plaintext[30]} {plaintext[31]} {plaintext[32]} {plaintext[33]} {plaintext[34]} {plaintext[35]} {plaintext[36]} {plaintext[37]} {plaintext[38]} {plaintext[39]} {plaintext[40]} {plaintext[41]} {plaintext[42]} {plaintext[43]} {plaintext[44]} {plaintext[45]} {plaintext[46]} {plaintext[47]} {plaintext[48]} {plaintext[49]} {plaintext[50]} {plaintext[51]} {plaintext[52]} {plaintext[53]} {plaintext[54]} {plaintext[55]} {plaintext[56]} {plaintext[57]} {plaintext[58]} {plaintext[59]} {plaintext[60]} {plaintext[61]} {plaintext[62]} {plaintext[63]} {plaintext[64]} {plaintext[65]} {plaintext[66]} {plaintext[67]} {plaintext[68]} {plaintext[69]} {plaintext[70]} {plaintext[71]} {plaintext[72]} {plaintext[73]} {plaintext[74]} {plaintext[75]} {plaintext[76]} {plaintext[77]} {plaintext[78]} {plaintext[79]} {plaintext[80]} {plaintext[81]} {plaintext[82]} {plaintext[83]} {plaintext[84]} {plaintext[85]} {plaintext[86]} {plaintext[87]} {plaintext[88]} {plaintext[89]} {plaintext[90]} {plaintext[91]} {plaintext[92]} {plaintext[93]} {plaintext[94]} {plaintext[95]} {plaintext[96]} {plaintext[97]} {plaintext[98]} {plaintext[99]} {plaintext[100]} {plaintext[101]} {plaintext[102]} {plaintext[103]} {plaintext[104]} {plaintext[105]} {plaintext[106]} {plaintext[107]} {plaintext[108]} {plaintext[109]} {plaintext[110]} {plaintext[111]} {plaintext[112]} {plaintext[113]} {plaintext[114]} {plaintext[115]} {plaintext[116]} {plaintext[117]} {plaintext[118]} {plaintext[119]} {plaintext[120]} {plaintext[121]} {plaintext[122]} {plaintext[123]} {plaintext[124]} {plaintext[125]} {plaintext[126]} {plaintext[127]} rst_n start}
    setPinAssignMode -pinEditInBatch false

    # Place all outputs and spread it again to right edge
    getPinAssignMode -pinEditInBatch -quiet
    setPinAssignMode -pinEditInBatch true
    editPin -fixOverlap 1 -spreadDirection clockwise -edge 2 -layer 3 -spreadType side -pin {done {ciphertext[0]} {ciphertext[1]} {ciphertext[2]} {ciphertext[3]} {ciphertext[4]} {ciphertext[5]} {ciphertext[6]} {ciphertext[7]} {ciphertext[8]} {ciphertext[9]} {ciphertext[10]} {ciphertext[11]} {ciphertext[12]} {ciphertext[13]} {ciphertext[14]} {ciphertext[15]} {ciphertext[16]} {ciphertext[17]} {ciphertext[18]} {ciphertext[19]} {ciphertext[20]} {ciphertext[21]} {ciphertext[22]} {ciphertext[23]} {ciphertext[24]} {ciphertext[25]} {ciphertext[26]} {ciphertext[27]} {ciphertext[28]} {ciphertext[29]} {ciphertext[30]} {ciphertext[31]} {ciphertext[32]} {ciphertext[33]} {ciphertext[34]} {ciphertext[35]} {ciphertext[36]} {ciphertext[37]} {ciphertext[38]} {ciphertext[39]} {ciphertext[40]} {ciphertext[41]} {ciphertext[42]} {ciphertext[43]} {ciphertext[44]} {ciphertext[45]} {ciphertext[46]} {ciphertext[47]} {ciphertext[48]} {ciphertext[49]} {ciphertext[50]} {ciphertext[51]} {ciphertext[52]} {ciphertext[53]} {ciphertext[54]} {ciphertext[55]} {ciphertext[56]} {ciphertext[57]} {ciphertext[58]} {ciphertext[59]} {ciphertext[60]} {ciphertext[61]} {ciphertext[62]} {ciphertext[63]} {ciphertext[64]} {ciphertext[65]} {ciphertext[66]} {ciphertext[67]} {ciphertext[68]} {ciphertext[69]} {ciphertext[70]} {ciphertext[71]} {ciphertext[72]} {ciphertext[73]} {ciphertext[74]} {ciphertext[75]} {ciphertext[76]} {ciphertext[77]} {ciphertext[78]} {ciphertext[79]} {ciphertext[80]} {ciphertext[81]} {ciphertext[82]} {ciphertext[83]} {ciphertext[84]} {ciphertext[85]} {ciphertext[86]} {ciphertext[87]} {ciphertext[88]} {ciphertext[89]} {ciphertext[90]} {ciphertext[91]} {ciphertext[92]} {ciphertext[93]} {ciphertext[94]} {ciphertext[95]} {ciphertext[96]} {ciphertext[97]} {ciphertext[98]} {ciphertext[99]} {ciphertext[100]} {ciphertext[101]} {ciphertext[102]} {ciphertext[103]} {ciphertext[104]} {ciphertext[105]} {ciphertext[106]} {ciphertext[107]} {ciphertext[108]} {ciphertext[109]} {ciphertext[110]} {ciphertext[111]} {ciphertext[112]} {ciphertext[113]} {ciphertext[114]} {ciphertext[115]} {ciphertext[116]} {ciphertext[117]} {ciphertext[118]} {ciphertext[119]} {ciphertext[120]} {ciphertext[121]} {ciphertext[122]} {ciphertext[123]} {ciphertext[124]} {ciphertext[125]} {ciphertext[126]} {ciphertext[127]} busy}
    setPinAssignMode -pinEditInBatch false

    # Legalize pin placement
    checkPinAssignment
    legalizePin
}

# Baseline experiment. Change ONE variable at a time.
proc doFloorPlan {} {
    floorPlan -site CoreSite -r 1 0.50 20 20 20 20
    checkFPlan

    # Call the pin assignment procedure
    doPinPlacement

    # Reporting and saving the design after floorplanning
    report_area > $::REPORT_DIR/02_floorplan_area.rpt
    report_timing -max_paths 10 > $::REPORT_DIR/02_floorplan_timing.rpt
    reportCongestion -overflow > $::REPORT_DIR/02_floorplan_congestion.rpt

    saveDesign db/02_floorplan.enc
}

# Power planning is technology dependent.
# Define VDD/VSS, rings, stripes and standard-cell rail connections.
#
proc doPowerPlan {} {
    globalNetConnect VDD -type pgpin -pin VDD -all
    globalNetConnect VSS -type pgpin -pin VSS -all

    setAddRingMode \
        -ring_target default \
        -extend_over_row 0 \
        -ignore_rows 0 \
        -avoid_short 0 \
        -skip_crossing_trunks none \
        -stacked_via_top_layer met5 \
        -stacked_via_bottom_layer met1 \
        -via_using_exact_crossover_size 1 \
        -orthogonal_only true \
        -skip_via_on_pin {  standardcell } \
        -skip_via_on_wire_shape {  noshape }


    addRing \
        -nets {VSS VDD} \
        -around user_defined \
        -user_defined_region {} \
        -type core_rings \
        -layer {top met5 bottom met5 left met4 right met4} \
        -width {top 5 bottom 5 left 5 right 5} \
        -spacing {top 5 bottom 5 left 5 right 5} \
        -offset {top 2.5 bottom 2.5 left 2.5 right 2.5} \
        -center 0 \
        -threshold 0 \

    #Power stripes 
    addStripe -nets {VDD VSS} \
            -direction vertical \
            -layer META
        -jog_distance 0 \
        -snap_wire_center_to_grid None


    # Vertcal power stipes
    setAddStripeMode \
        -ignore_block_check false \
        -break_at none \
        -route_over_rows_only false \
        -rows_without_stripes_only false \
        -extend_to_closest_target none \
        -stop_at_last_wire_for_area false \
        -partial_set_thru_domain false \
        -ignore_nondefault_domains false \
        -trim_antenna_back_to_shape none \
        -spacing_type edge_to_edge \
        -spacing_from_block 0 \
        -stripe_min_length stripe_width \
        -stacked_via_top_layer met5 \
        -stacked_via_bottom_layer met1 \
        -via_using_exact_crossover_size false \
        -split_vias false \
        -orthogonal_only true \
        -allow_jog { padcore_ring  block_ring } \
        -skip_via_on_pin {  standardcell } \
        -skip_via_on_wire_shape {  noshape   }


    addStripe \
        -nets {VSS VDD} \
        -layer met4 \
        -direction vertical \
        -width 4 \
        -spacing 4 \
        -number_of_sets 4 \
        -start_from left \
        -start_offset 75 \
        -stop_offset 75 \
        -switch_layer_over_obs false \
        -max_same_layer_jog_length 2 \
        -padcore_ring_top_layer_limit met5 \
        -padcore_ring_bottom_layer_limit met1 \
        -block_ring_top_layer_limit met5 \
        -block_ring_bottom_layer_limit met1 \
        -use_wire_group 0 \
        -snap_wire_center_to_grid None

    # # Horizontal power stripes
    # setAddStripeMode \
    #     -ignore_block_check false \
    #     -break_at none \
    #     -route_over_rows_only false \
    #     -rows_without_stripes_only false \
    #     -extend_to_closest_target none \
    #     -stop_at_last_wire_for_area false \
    #     -partial_set_thru_domain false \
    #     -ignore_nondefault_domains false \
    #     -trim_antenna_back_to_shape none \
    #     -spacing_type edge_to_edge \
    #     -spacing_from_block 0 \
    #     -stripe_min_length stripe_width \
    #     -stacked_via_top_layer met5 \
    #     -stacked_via_bottom_layer met1 \
    #     -via_using_exact_crossover_size false \
    #     -split_vias false \
    #     -orthogonal_only true \
    #     -allow_jog { padcore_ring  block_ring } \
    #     -skip_via_on_pin {  standardcell } \
    #     -skip_via_on_wire_shape {  noshape   }\


    # addStripe 
    #     -nets {VSS VDD} \
    #     -layer met5 \
    #     -direction horizontal \
    #     -width 4 \
    #     -spacing 4 \
    #     -number_of_sets 4 \
    #     -start_from bottom \
    #     -start_offset 75 \
    #     -stop_offset 75 \
    #     -switch_layer_over_obs false \
    #     -max_same_layer_jog_length 2 \
    #     -padcore_ring_top_layer_limit met5 \
    #     -padcore_ring_bottom_layer_limit met1 \
    #     -block_ring_top_layer_limit met5 \
    #     -block_ring_bottom_layer_limit met1 \
    #     -use_wire_group 0 \
    #     -snap_wire_center_to_grid None

    # Power Rails
    setSrouteMode -viaConnectToShape { noshape }
    sroute -connect { blockPin padPin padRing corePin floatingStripe } -layerChangeRange { met1(1) met5(5) } -blockPinTarget { nearestTarget } -padPinPortConnect { allPort oneGeom } -padPinTarget { nearestTarget } -corePinTarget { firstAfterRowEnd } -floatingStripeTarget { blockring padring ring stripe ringpin blockpin followpin } -allowJogging 1 -crossoverViaLayerRange { met1(1) met5(5) } -nets { VDD VSS } -allowLayerChange 1 -blockPin useLef -targetViaLayerRange { met1(1) met5(5) }

    # Do not copy stripe width/spacing without checking local technology rules.
    report_area > $::REPORT_DIR/03_power_area.rpt
    saveDesign db/03_power.enc
}

# run a useful congestion experiment in Innovus: 1-Adjust stripe layers or pitch, 2-Reduce utilization or spread a hotspot
proc doPlaceCells {} {
    # New Innovus UI
    place_opt_design 

    # # Old Innovus UI
    # placeDesign

    report_area > $::REPORT_DIR/04_place_area.rpt
    report_timing -max_paths 20 > $::REPORT_DIR/04_place_timing.rpt
    reportCongestion -overflow > $::REPORT_DIR/04_place_congestion.rpt

    saveDesign db/04_place.enc
}

proc doPreCTS {} {
    timeDesign -preCTS

    # Typical pre-CTS optimization concept:
    optDesign -preCTS

    report_area > $::REPORT_DIR/05_prects_area.rpt
    report_timing -max_paths 20 > $::REPORT_DIR/05_prects_timing.rpt
    reportCongestion -overflow > $::REPORT_DIR/05_prects_congestion.rpt

    saveDesign db/05_pre_cts.enc
}

proc doClockTreeSynthesis {} {
    # Modern Innovus CTS is commonly handled through CCOpt.
    create_ccopt_clock_tree_spec

    # # Old Innovus UI
    # set_ccopt_property buffer_cells {CLKBUFX2 CLKBUFX4 CLKBUFX8} 
    # set_ccopt_property inverter_cells {CLKINVX1 CLKINVX2 CLKINVX4 CLKINVX8} 
    # ccopt_design

    # New Innovus UI
    set_db cts_buffer_cells {CLKBUFX2 CLKBUFX4 CLKBUFX8}
    set_db cts_inverter_cells {CLKINVX1 CLKINVX2 CLKINVX4 CLKINVX8}
    clock_opt_design

    report_timing -max_paths 20 > $::REPORT_DIR/06_cts_timing.rpt
    report_clock_tree > $::REPORT_DIR/06_cts_clock_tree.rpt
    report_area > $::REPORT_DIR/06_cts_area.rpt
    reportCongestion -overflow > $::REPORT_DIR/06_cts_congestion.rpt

    saveDesign db/06_cts.enc

    optDesign -postCTS
    timeDesign -postCTS -outDir $::REPORT_DIR/07_postcts_timeDesign.rpt

    report_timing -max_paths 20 > $::REPORT_DIR/07_postcts_timing.rpt
    report_clock_tree > $::REPORT_DIR/07_postcts_clock_tree.rpt
    report_area > $::REPORT_DIR/07_postcts_area.rpt
    reportCongestion -overflow > $::REPORT_DIR/07_postcts_congestion.rpt
    report_constraint -all_violators > $::REPORT_DIR/07_postcts_constraint.rpt

    saveDesign db/07_postcts.enc
}

proc doRoutingDesign {} {
    
    routeDesign -globalDetail

    reportCongestion -overflow > $::REPORT_DIR/08_route_congestion_of.rpt
    reportCongestion -hotSpot > $::REPORT_DIR/08_route_congestion_hs.rpt
    report_timing -max_paths 20 > $::REPORT_DIR/08_route_timing.rpt
    report_clock_tree > $::REPORT_DIR/08_route_clock_tree.rpt
    report_area > $::REPORT_DIR/08_route_area.rpt
    reportCongestion -overflow > $::REPORT_DIR/08_route_congestion.rpt
    report_constraint -all_violators > $::REPORT_DIR/08_route_constraint.rpt

    extractRC
    rcOut -spef $::REPORT_DIR/08_route_rc.spef

    saveDesign db/08_route.enc
}

proc doPostRouteOptimization {} {
    optDesign -postRoute

    reportCongestion -overflow > $::REPORT_DIR/09_postroute_congestion_of.rpt
    reportCongestion -hotSpot > $::REPORT_DIR/09_postroute_congestion_hs.rpt
    report_timing -max_paths 20 > $::REPORT_DIR/09_postroute_timing.rpt
    report_timing -early -max_paths 20 > $::REPORT_DIR/09_postroute_timing_hold.rpt
    report_area > $::REPORT_DIR/09_postroute_area.rpt
    reportCongestion -overflow > $::REPORT_DIR/09_postroute_congestion.rpt
    report_constraint -all_violators > $::REPORT_DIR/09_postroute_constraint.rpt
    check_timing

    extractRC
    rcOut -spef $::REPORT_DIR/09_postroute_rc.spef

    timeDesign -postRoute -outDir $::REPORT_DIR/09_postroute_timeDesign.rpt
}

proc doFinalChecks {} {
    verify_drc
    verifyConnectivity -type all
}

proc doBuildAll {} {
    doInitDesign
    doFloorPlan
    doPowerPlan
    doPlaceCells
    doPreCTS
    doClockTreeSynthesis
    doRoutingDesign
    doPostRouteOptimization
    doFinalChecks
}

proc doBuild {fromStep} {
    if {$fromStep < 1} {
        doInitDesign
    }
    if {$fromStep < 2} {
        doFloorPlan
    }
    if {$fromStep < 3} {
        doPowerPlan
    }
    if {$fromStep < 4} {
        doPlaceCells
    }
    if {$fromStep < 5} {
        doPreCTS
    }
    if {$fromStep < 6} {
        doClockTreeSynthesis
    }
    if {$fromStep < 7} {
        doRoutingDesign
    }
    if {$fromStep < 8} {
        doPostRouteOptimization
    }
    if {$fromStep < 9} {
        doFinalChecks
    }
}

proc doReload {} {
    puts "Reloading script: $::script_path"
    source $::script_path
}