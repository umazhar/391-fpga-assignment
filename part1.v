module part1 (CLOCK_50, CLOCK2_50, KEY, FPGA_I2C_SCLK, FPGA_I2C_SDAT, AUD_XCK, 
		        AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK, AUD_ADCDAT, AUD_DACDAT);

	input CLOCK_50, CLOCK2_50;
	input [0:0] KEY;
	// I2C Audio/Video config interface
	output FPGA_I2C_SCLK;
	inout FPGA_I2C_SDAT;
	// Audio CODEC
	output AUD_XCK;
	input AUD_DACLRCK, AUD_ADCLRCK, AUD_BCLK;
	input AUD_ADCDAT;
	output AUD_DACDAT;
	
	// Local wires.
	wire read_ready, write_ready, read, write;
	wire [23:0] readdata_left, readdata_right;
	wire [23:0] writedata_left, writedata_right;
	wire reset = ~KEY[0];
	wire enable = 1'b1;

	/////////////////////////////////
	// Your code goes here 
	/////////////////////////////////

	wire [23:0] filter_out_left, filter_out_right;
	
	assign writedata_left = write_ready ? filter_out_left : writedata_left;
	assign writedata_right = write_ready ? filter_out_right : writedata_right;
	assign read = read_ready;
	assign write = write_ready;
	
	filter FILTER_LEFT(CLOCK_50, readdata_left, filter_out_left, read_ready);
	filter FILTER_RIGHT(CLOCK_50, readdata_right, filter_out_right, read_ready);

/////////////////////////////////////////////////////////////////////////////////
// Audio CODEC interface. 
//
// The interface consists of the following wires:
// read_ready, write_ready - CODEC ready for read/write operation 
// readdata_left, readdata_right - left and right channel data from the CODEC
// read - send data from the CODEC (both channels)
// writedata_left, writedata_right - left and right channel data to the CODEC
// write - send data to the CODEC (both channels)
// AUD_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio CODEC
// I2C_* - should connect to top-level entity I/O of the same name.
//         These signals go directly to the Audio/Video Config module
/////////////////////////////////////////////////////////////////////////////////
	clock_generator my_clock_gen(
		// inputs
		CLOCK2_50,
		reset,

		// outputs
		AUD_XCK
	);

	audio_and_video_config cfg(
		// Inputs
		CLOCK_50,
		reset,

		// Bidirectionals
		FPGA_I2C_SDAT,
		FPGA_I2C_SCLK
	);

	audio_codec codec(
		// Inputs
		CLOCK_50,
		reset,

		read,	write,
		writedata_left, writedata_right,

		AUD_ADCDAT,

		// Bidirectionals
		AUD_BCLK,
		AUD_ADCLRCK,
		AUD_DACLRCK,

		// Outputs
		read_ready, write_ready,
		readdata_left, readdata_right,
		AUD_DACDAT
	);

endmodule

module noise_generator (clk, enable, Q);
	input clk, enable;
	output [23:0] Q;
	reg [2:0] counter;
	always@ (posedge clk)
		if (enable)
			counter = counter + 1'b1;
	assign Q = {{10{counter[2]}}, counter, 11'd0};
endmodule

module filter(CLOCK_50, in, out, read_ready);
    input CLOCK_50;
    input [23:0] in;
    output [23:0] out;
    input read_ready;

    //registers for 8 stage filter
	reg signed [23:0] buff0, buff1, buff2, buff3, buff4, buff5, buff6, buff7;
	reg [23:0] sum;
	wire [23:0] noise;

    wire enable = 1'b1;
    noise_generator ng(CLOCK50, enable, noise);

    always @ (posedge CLOCK_50)
	begin
		if(read_ready == 1'b1)
			begin
				buff0 <= in >>> 3;
				buff1 <= buff0;
				buff2 <= buff1;
			    	buff3 <= buff2;
				buff4 <= buff3;
				buff5 <= buff4;
				buff6 <= buff5;
				buff7 <= buff6;		
			end
	end

	always @(*) begin
		sum = buff0 + buff1 + buff2 + buff3 + buff4 + buff5 + buff6 + buff7;	
	end
	assign out = sum;
endmodule


// module n_sample_filter(in, out, enable);
// 	input [23:0] in;
// 	output [23:0] out;
// 	input enable;

// 	wire N = 4'd8;

			


endmodule

module flip_flop()
	
endmodule
