# =========================================================
# Vivado Project TCL
# Target FPGA : Artix-7 xc7a35tcpg236-1
# Tool        : Vivado 2025.1
# =========================================================

# Resolve repository root
set ROOT_DIR [file normalize [file dirname [info script]]/..]

# Project name
set PROJ_NAME nn_fpga_accelerator

# Create project
create_project $PROJ_NAME $ROOT_DIR/build/$PROJ_NAME -part xc7a35tcpg236-1

puts "ROOT_DIR = $ROOT_DIR"
puts "RTL files found:"
puts [glob -nocomplain $ROOT_DIR/rtl/*]
puts [glob -nocomplain $ROOT_DIR/rtl/*]

# Add RTL
add_files [glob $ROOT_DIR/rtl/*.sv]

add_files -fileset sim_1 [glob $ROOT_DIR/sim/*.sv]
set_property top neural_network_testbench [get_filesets sim_1]

# Add memory initialization files
add_files [glob $ROOT_DIR/mem/*.coe]


# Add IP definitions
add_files [glob -nocomplain $ROOT_DIR/ip/**/*.xci]

# Generate IP output products
set ip_files [get_files *.xci]
if {[llength $ip_files] > 0} {
    generate_target all $ip_files
    export_ip_user_files -of_objects $ip_files -no_script -force
}


# Add constraints
add_files -fileset constrs_1 [glob $ROOT_DIR/constraints/*.xdc]

set_property top neural_network [get_filesets sources_1]
