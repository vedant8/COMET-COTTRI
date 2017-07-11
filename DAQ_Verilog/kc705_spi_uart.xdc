#
#
# DEVICE
# ------
#
# On the KC705 board, bank 0 and the CFGBVS pin are connected to a 2.5v supply. 
# 
# Configuration voltage supplied to bank 0
# Specified as an actual voltage value
set_property CONFIG_VOLTAGE 2.5 [current_design]
#
# Configuration Bank Voltage Selection (CFGBVS)
# Specified as VCCO (as in this case) or GND
set_property CFGBVS VCCO [current_design]
#
#
# Essential Bits File Generation
# ------------------------------
set_property bitstream.seu.essentialbits yes [current_design]
#
#
# TIMING
# ------
#
# 200MHz clock from oscillator on KC705 board
#
create_clock -period 5 -name clk200 -waveform {0 2.5} -add [get_ports clk200_p]
# 100MHz clock from oscillator on KC705 board
#
create_clock -period 10 -name clk -waveform {0 5} 
#
# 200MHz internal clock
#
# create_clock -period 5 -name clk -waveform {0 2.5} -add [get_nets clk]
#
# Signals that appear to be clocks and need to be given a definition to prevent Vivado warnings
#
create_clock -period 100 -name JTAG_Loader_DRCK -waveform {0 10} -add [get_pins program_rom/instantiate_loader.jtag_loader_6_inst/jtag_loader_gen.BSCAN_7SERIES_gen.BSCAN_BLOCK_inst/DRCK]
create_clock -period 1000 -name JTAG_Loader_UPDATE -waveform {0 80} -add [get_pins program_rom/instantiate_loader.jtag_loader_6_inst/jtag_loader_gen.BSCAN_7SERIES_gen.BSCAN_BLOCK_inst/UPDATE]
#
# Tell Vivado to treat all clocks as asynchronous to again prevent unnecessary constraints and warnings.
#
set_clock_groups -name my_async_clocks -asynchronous -group [get_clocks clk200] -group [get_clocks JTAG_Loader_DRCK] -group [get_clocks JTAG_Loader_UPDATE]
#
#
#
# I/O timing is not critical but constraints prevent unnecessary constraints and Vivado warnings.
# Unfortunately Vivado is still reporting 'partial input delay' and 'partial output delay' warnings.
#
#
set_max_delay 50 -from [get_ports uart_rx] -to [get_clocks clk200] -quiet -datapath_only
set_min_delay  0 -from [get_ports uart_rx] -to [get_clocks clk200] -quiet 
set_max_delay 50 -from [get_ports cpu_rst] -to [get_clocks clk200] -quiet -datapath_only
set_min_delay  0 -from [get_ports cpu_rst] -to [get_clocks clk200] -quiet 
#
set_max_delay 50 -from [get_clocks clk200] -to [get_ports uart_tx] -quiet -datapath_only
set_min_delay  0 -from [get_clocks clk200] -to [get_ports uart_tx] -quiet 
#
#
#create_generated_clock -name cclk -source [get_pins STARTUPE2_inst/USRCCLKO] -combinational [get_pins STARTUPE2_inst/USRCCLKO]
##set_clock_latency -min  0.5 [get_clocks cclk]
##set_clock_latency -max  6.7 [get_clocks cclk]
#set_input_delay -clock cclk -max 7 [get_ports spi_miso] -clock_fall
#set_input_delay -clock cclk -min 1 [get_ports spi_miso] -clock_fall
#set_output_delay -clock cclk -max 2 [get_ports spi_mosi]
#set_output_delay -clock cclk -min -3 [get_ports spi_mosi]
#set_output_delay -clock cclk -max 4 [get_ports spi_cs_b]
#set_output_delay -clock cclk -min -4 [get_ports spi_cs_b]
#
# DEFINE I/O PINS
# ---------------
#
#
# 200MHz Differential Clock
# -------------------------
# 
set_property PACKAGE_PIN AD12 [get_ports clk200_p]
set_property IOSTANDARD DIFF_SSTL15 [get_ports clk200_p]
#
set_property PACKAGE_PIN AD11 [get_ports clk200_n]
set_property IOSTANDARD DIFF_SSTL15 [get_ports clk200_n]
#
#
# USB-UART
# --------
#
set_property PACKAGE_PIN M19 [get_ports uart_rx]
set_property IOSTANDARD LVCMOS25 [get_ports uart_rx]
#
set_property PACKAGE_PIN K24 [get_ports uart_tx]
set_property IOSTANDARD LVCMOS25 [get_ports uart_tx]
set_property SLEW SLOW [get_ports uart_tx]
set_property DRIVE 4 [get_ports uart_tx]
#
#
# CPU_RST press switch (SW7)
# --------------------------

# This input is not used by this design but the constraints have been provided for 
# additional reference.

#    Active High

 set_property PACKAGE_PIN AB7 [get_ports cpu_rst]
 set_property IOSTANDARD LVCMOS15 [get_ports cpu_rst]

#SPI LINES
set_property PACKAGE_PIN P24 [get_ports spi_mosi]
set_property IOSTANDARD LVCMOS25 [get_ports spi_mosi]
set_property SLEW SLOW [get_ports spi_mosi]
set_property DRIVE 8 [get_ports spi_mosi]
set_property PACKAGE_PIN R25 [get_ports spi_miso]
set_property IOSTANDARD LVCMOS25 [get_ports spi_miso]

set_property PACKAGE_PIN U19 [get_ports spi_cs_b]
set_property IOSTANDARD LVCMOS25 [get_ports spi_cs_b]
set_property SLEW SLOW [get_ports spi_cs_b]
set_property DRIVE 8 [get_ports spi_cs_b]


#LEDs
set_property PACKAGE_PIN AB8 [get_ports {led[0]}]
set_property PACKAGE_PIN AA8 [get_ports {led[1]}]
set_property PACKAGE_PIN AC9 [get_ports {led[2]}]
set_property PACKAGE_PIN AB9 [get_ports {led[3]}]
set_property PACKAGE_PIN AE26 [get_ports {led[4]}]
set_property PACKAGE_PIN G19 [get_ports {led[5]}]
set_property PACKAGE_PIN E18 [get_ports {led[6]}]
set_property PACKAGE_PIN F16 [get_ports {led[7]}]

set_property IOSTANDARD LVCMOS18 [get_ports {led[0]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[1]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[2]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[3]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[4]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[5]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[6]}]
set_property IOSTANDARD LVCMOS18 [get_ports {led[7]}]

#LCD
set_property PACKAGE_PIN Y11 [get_ports LCD_RS]
set_property IOSTANDARD LVCMOS18 [get_ports LCD_RS]
set_property PACKAGE_PIN Y10 [get_ports LCD_DB7]
set_property IOSTANDARD LVCMOS18 [get_ports LCD_DB7]
set_property PACKAGE_PIN AA11 [get_ports LCD_DB6]
set_property IOSTANDARD LVCMOS18 [get_ports LCD_DB6]
set_property PACKAGE_PIN AA10 [get_ports LCD_DB5]
set_property IOSTANDARD LVCMOS18 [get_ports LCD_DB5]
set_property PACKAGE_PIN AA13 [get_ports LCD_DB4]
set_property IOSTANDARD LVCMOS18 [get_ports LCD_DB4]
set_property PACKAGE_PIN AB13 [get_ports LCD_RW]
set_property IOSTANDARD LVCMOS18 [get_ports LCD_RW]
set_property PACKAGE_PIN AB10 [get_ports LCD_E]
set_property IOSTANDARD LVCMOS18 [get_ports LCD_E]


#------------------------------------------------------------------------------------------
# End of File
#------------------------------------------------------------------------------------------
#
