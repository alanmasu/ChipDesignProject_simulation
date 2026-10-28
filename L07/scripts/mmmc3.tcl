# Version:1.0 MMMC View Definition File
# Do Not Remove Above Line


# Read lib
# Also known as bc
create_library_set -name LIB_FF -timing $SKY130_DIR/sky130_scl_9T_0.1.2/sky130_scl_9T/lib/sky130_ff_1.98_0_nldm.lib

# Also known as wc
create_library_set -name LIB_SS -timing $SKY130_DIR/sky130_scl_9T_0.1.2/sky130_scl_9T/lib/sky130_ss_1.62_125_nldm.lib

# Also known as nc
create_library_set -name LIB_TT -timing $SKY130_DIR/sky130_scl_9T_0.1.2/sky130_scl_9T/lib/sky130_tt_1.8_25_nldm.lib


# Creating RC corners
create_rc_corner -name RC_TYP \
	-qx_tech_file $SKY130_DIR/sky130_release_0.1.0/quantus/extraction/typical/qrcTechFile \
	-T 25    


# Creating Delay corners
create_delay_corner -name DC_SETUP -library_set LIB_SS -rc_corner RC_TYP
create_delay_corner -name DC_HOLD  -library_set LIB_FF -rc_corner RC_TYP


# Constraing
create_constraint_mode -name FUNC -sdc_files  $BL_DIR/baseline3.sdc


# Creating analysis views
create_analysis_view -name SETUP -constraint_mode FUNC -delay_corner DC_SETUP
create_analysis_view -name HOLD  -constraint_mode FUNC -delay_corner DC_HOLD


set_analysis_view -setup SETUP -hold HOLD
