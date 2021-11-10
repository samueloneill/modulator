# Team: Team 29 - Sam O 879282 - Dwight M 879243

## Clock signal
set_property PACKAGE_PIN W5 [get_ports i_C100MHz]
	set_property IOSTANDARD LVCMOS33 [get_ports i_C100MHz]
	create_clock -add -name C100MHz_pin -period 10.000 -waveform {0 5} [get_ports i_C100MHz]

## Switches
set_property -dict {PACKAGE_PIN W13  IOSTANDARD LVCMOS33} [get_ports {i_SW7}]					
set_property -dict {PACKAGE_PIN V2  IOSTANDARD LVCMOS33} [get_ports {i_SW8}]					
set_property -dict {PACKAGE_PIN T3  IOSTANDARD LVCMOS33} [get_ports {i_SW9}]					
set_property -dict {PACKAGE_PIN T2  IOSTANDARD LVCMOS33} [get_ports {i_SW10}]					
set_property -dict {PACKAGE_PIN R3  IOSTANDARD LVCMOS33} [get_ports {i_SW11}]					
set_property -dict {PACKAGE_PIN W2  IOSTANDARD LVCMOS33} [get_ports {i_SW12}]					
set_property -dict {PACKAGE_PIN U1  IOSTANDARD LVCMOS33} [get_ports {i_SW13}]					
set_property -dict {PACKAGE_PIN T1  IOSTANDARD LVCMOS33} [get_ports {i_SW14}]					
set_property -dict {PACKAGE_PIN R2  IOSTANDARD LVCMOS33} [get_ports {i_SW15}]					

##7 segment display
##Cathodes
set_property -dict { PACKAGE_PIN W7   IOSTANDARD LVCMOS33 } [get_ports {o_segCathodes[6]}]
set_property -dict { PACKAGE_PIN W6   IOSTANDARD LVCMOS33 } [get_ports {o_segCathodes[5]}]
set_property -dict { PACKAGE_PIN U8   IOSTANDARD LVCMOS33 } [get_ports {o_segCathodes[4]}]
set_property -dict { PACKAGE_PIN V8   IOSTANDARD LVCMOS33 } [get_ports {o_segCathodes[3]}]
set_property -dict { PACKAGE_PIN U5   IOSTANDARD LVCMOS33 } [get_ports {o_segCathodes[2]}]
set_property -dict { PACKAGE_PIN V5   IOSTANDARD LVCMOS33 } [get_ports {o_segCathodes[1]}]
set_property -dict { PACKAGE_PIN U7   IOSTANDARD LVCMOS33 } [get_ports {o_segCathodes[0]}]

##Decimal point
set_property -dict { PACKAGE_PIN V7   IOSTANDARD LVCMOS33 } [get_ports {o_segDP}]

##Anodes
set_property -dict { PACKAGE_PIN U2   IOSTANDARD LVCMOS33 } [get_ports {o_segAnodes[0]}]
set_property -dict { PACKAGE_PIN U4   IOSTANDARD LVCMOS33 } [get_ports {o_segAnodes[1]}]
set_property -dict { PACKAGE_PIN V4   IOSTANDARD LVCMOS33 } [get_ports {o_segAnodes[2]}]
set_property -dict { PACKAGE_PIN W4   IOSTANDARD LVCMOS33 } [get_ports {o_segAnodes[3]}]

##Buttons
set_property -dict { PACKAGE_PIN T18  IOSTANDARD LVCMOS33} [get_ports i_reset]
set_property -dict { PACKAGE_PIN U17  IOSTANDARD LVCMOS33} [get_ports i_StartStop]

## Configuration options, can be used for all designs
set_property CONFIG_VOLTAGE 3.3 [current_design]
set_property CFGBVS VCCO [current_design]