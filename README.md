# tm1638-verilog
This is a basic verilog driver for the TM1638 LED driver chip.

![LED&Keys scanning LEDs](https://github.com/alangarf/tm1638-verilog/raw/master/media/scanning.gif)

The driver module itself just handles the timing and communication over the wire, the user is in full control of all registers and inputs to control the display module itself. It supports both read and write operation which means you can read back the state of the keys.

The included demo module is an example of the type of state machine you can build to just continuously scan the keypad for new key presses and equally update the display with new values.

The Makefile has been set up for yosys and arachne-pnr, along with and icarus verilog and GtkWave compatible testbench. The included demo is configured for the iCE40HX8K-B Breakoutboard and the constraints file expects the LED&KEYs board to be connected as follows:

TM1638 Pins | iCE40HX8K Pins
------------ | -------------
CLK | P1
DIO | P2
DTB | R1

Here is an example of the testbench, it is writing 0x40, 0xAA, 0x55 to the TM1638, and reading back 0xAA and 0x55 from the TM1638.

![LED&Keys scanning LEDs](https://github.com/alangarf/tm1638-verilog/raw/master/media/testbench.png)

Enjoy!
