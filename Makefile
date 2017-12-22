DEVICE = hx8k
PIN_DEF=ice40hx8k.pcf

all: demos

# ------ TEMPLATES ------
%.blif: %.v
	yosys -q -p "synth_ice40 -blif $@" $^

%.asc: $(PIN_DEF) %.blif
	arachne-pnr -d $(subst hx,,$(subst lp,,$(DEVICE))) -o $@ -p $^

%.bin: %.asc
	icepack $^ $@

%.rpt: %.asc
	icetime -d $(DEVICE) -mtr $@ $<

%_tb.vvp: %_tb.v %.v
	iverilog -o $@ $^

%_tb.vcd: %_tb.vvp
	vvp -N $< +vcd=$@

# ------ DEMOS ------
demos: basic

#  BASIC
basic: src/demos/basic.bin
basic-prog: src/demos/basic.bin
	iceprog $<
src/demos/basic.bin: src/demos/basic.asc
src/demos/basic.asc: src/demos/basic.blif
src/demos/basic.blif: src/demos/basic.v src/tm1638.v

# ------ TEST BENCHES ------
tests: tm1638_tb

tm1638_tb: src/tm1638_tb.vcd
src/tm1638_tb.vcd: src/tm1638_tb.vvp
src/tm1638_tb.vvp: src/tm1638_tb.v src/tm1638.v

# ------ HELPERS ------
clean:
	rm -f src/**/*.blif src/**/*.asc src/**/*.bin src/**/*.vvp src/**/*.vcd

.SECONDARY:
.PHONY: all demos tests clean
