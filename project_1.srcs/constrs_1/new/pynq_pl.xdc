## Clock 125MHz
set_property PACKAGE_PIN H16 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -period 8.000 [get_ports clk]

## Reset button (BTN0)
set_property PACKAGE_PIN R14 [get_ports rst_btn]
set_property IOSTANDARD LVCMOS33 [get_ports rst_btn]

## LEDs
set_property PACKAGE_PIN R4  [get_ports {led[0]}]
set_property PACKAGE_PIN P4  [get_ports {led[1]}]
set_property PACKAGE_PIN N4  [get_ports {led[2]}]
set_property PACKAGE_PIN R3  [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {led[*]}]
