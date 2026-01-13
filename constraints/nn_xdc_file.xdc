#clock 
create_clock -name sysclk -period 20 [get_ports {clk}]
set_property PACKAGE_PIN W5 [get_ports {clk}]
# Example: set_property IOSTANDARD LVDS_25 [get_ports [list data_p* data_n*]]
set_property IOSTANDARD LVCMOS33 [get_ports {clk}]

#start input      
set_property PACKAGE_PIN U18 [get_ports {start}]
# Example: set_property IOSTANDARD LVDS_25 [get_ports [list data_p* data_n*]]
set_property IOSTANDARD LVCMOS33 [get_ports {start}]

#done led        
set_property PACKAGE_PIN U16 [get_ports {done}]
# Example: set_property IOSTANDARD LVDS_25 [get_ports [list data_p* data_n*]]
set_property IOSTANDARD LVCMOS33 [get_ports {done}]

# 7 SEGMENT CATHODE
set_property IOSTANDARD LVCMOS33 [get_ports {CA}]
set_property IOSTANDARD LVCMOS33 [get_ports {CB}]
set_property IOSTANDARD LVCMOS33 [get_ports {CC}]
set_property IOSTANDARD LVCMOS33 [get_ports {CD}]
set_property IOSTANDARD LVCMOS33 [get_ports {CE}]
set_property IOSTANDARD LVCMOS33 [get_ports {CF}]
set_property IOSTANDARD LVCMOS33 [get_ports {CG}]



set_property PACKAGE_PIN W7 [get_ports {CA}]
set_property PACKAGE_PIN W6 [get_ports {CB}]
set_property PACKAGE_PIN U8 [get_ports {CC}]
set_property PACKAGE_PIN V8 [get_ports {CD}]
set_property PACKAGE_PIN U5 [get_ports {CE}]
set_property PACKAGE_PIN V5 [get_ports {CF}]
set_property PACKAGE_PIN U7 [get_ports {CG}]

# 7 SEGMENT ANODE
set_property PACKAGE_PIN U2 [get_ports {AN[0]}]
set_property PACKAGE_PIN U4 [get_ports {AN[1]}]
set_property PACKAGE_PIN V4 [get_ports {AN[2]}]
set_property PACKAGE_PIN W4 [get_ports {AN[3]}]
    
set_property IOSTANDARD LVCMOS33 [get_ports {AN[*]}]

      