`timescale 10 ns / 1 ns
module tm1638_tb;
    reg clk, rst;

    wire [7:0] data_in;
    reg [7:0] data_out;
    wire [7:0] data_sig;

    reg rw, data_latch;

    wire busy, sclk, dio_out;
    reg dio_in;

    tm1638 u_tm1638 (
        .clk            (clk),
        .rst            (rst),
        .data_latch     (data_latch),
        .data           (data_sig),
        .rw             (rw),
        .busy           (busy),
        .sclk           (sclk),
        .dio_out        (dio_out),
        .dio_in         (dio_in)
    );

    assign data_in = data_sig;
    assign data_sig = rw ? data_out : 8'hZZ;

    reg [4095:0] vcdfile;

    initial
    begin
        if ($value$plusargs("vcd=%s", vcdfile)) begin
			$dumpfile(vcdfile);
			$dumpvars(0, tm1638_tb);
		end
        clk = 0;
        rst = 0;
        rw = 1;
        data_out = 0;
        data_latch = 0;
        dio_in = 0;

        #500
        // trigger reset
        rst = 1;
        #50
        rst = 0;
        #500

        // send 0x40
        data_out = 8'b01000000;
        data_latch = 1;
        #10
        data_latch = 0;
        #1000

        // send 0xAA
        data_out = 8'b10101010;
        data_latch = 1;
        #10
        data_latch = 0;
        #1000

        // send 0x55
        data_out = 8'b01010101;
        data_latch = 1;
        #10
        data_latch = 0;
        #1000

        // read
        rw = 0;
        data_latch = 1;
        dio_in = 1;
        #10
        data_latch = 0;
        dio_in = 1;
        #40
        dio_in = 0;
        #80
        dio_in = 1;
        #80
        dio_in = 0;
        #80
        dio_in = 1;
        #80
        dio_in = 0;
        #80
        dio_in = 1;
        #80
        dio_in = 0;
        #80
        dio_in = 1;
        #400

        // read
        rw = 0;
        data_latch = 1;
        dio_in = 1;
        #10
        data_latch = 0;
        dio_in = 0;
        #40
        dio_in = 1;
        #80
        dio_in = 0;
        #80
        dio_in = 1;
        #80
        dio_in = 0;
        #80
        dio_in = 1;
        #80
        dio_in = 0;
        #80
        dio_in = 1;
        #80
        dio_in = 0;
        #400
        $finish;
    end

    always @(posedge clk)
    begin
        ;
    end

    always
        #5 clk = !clk;

endmodule
