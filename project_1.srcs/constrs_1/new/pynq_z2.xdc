## Clock 125 MHz
set_property PACKAGE_PIN H16 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 8.000 -name sys_clk_pin -waveform {0 4} [get_ports clk]

## Reset (BTN0)
set_property PACKAGE_PIN D19 [get_ports rst_n]
set_property IOSTANDARD LVCMOS33 [get_ports rst_n]

## Switches
set_property PACKAGE_PIN G15 [get_ports {sw[0]}]
set_property PACKAGE_PIN P15 [get_ports {sw[1]}]
set_property PACKAGE_PIN W13 [get_ports {sw[2]}]
set_property PACKAGE_PIN T16 [get_ports {sw[3]}]
set_property PACKAGE_PIN P16 [get_ports {sw[4]}]
set_property PACKAGE_PIN R16 [get_ports {sw[5]}]
set_property PACKAGE_PIN N15 [get_ports {sw[6]}]
set_property PACKAGE_PIN R18 [get_ports {sw[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports sw[*]]

## LEDs
set_property PACKAGE_PIN R14 [get_ports {led[0]}]
set_property PACKAGE_PIN P14 [get_ports {led[1]}]
set_property PACKAGE_PIN N16 [get_ports {led[2]}]
set_property PACKAGE_PIN M14 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports led[*]]
