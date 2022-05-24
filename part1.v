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
	wire [23:0] writedata_left, writedata_right, writedata_left_buff, writedata_right_buff;
	wire reset = ~KEY[0];
	reg [23:0] lbuff0, lbuff1, lbuff2, lbuff3, lbuff4, lbuff5, lbuff6, lbuff7;
	reg [23:0] rbuff0, rbuff1, rbuff2, rbuff3, rbuff4, rbuff5, rbuff6, rbuff7;
	reg [23:0] sum_left;
	reg [23:0] sum_right;
	wire [23:0] noise;
	wire enable = 1'b1;

	/////////////////////////////////
	// Your code goes here 
	/////////////////////////////////
	
	assign writedata_left = write_ready ? sum_left : writedata_left;
	assign writedata_right = write_ready ? sum_right : writedata_right;
	assign read = read_ready;
	assign write = write_ready;
	

always @ (posedge CLOCK_50)
	begin
		if(read_ready == 1'b1)
			begin
//				lbuff0 <= readdata_left >> 3;
//				lbuff1 <= lbuff0;
//				lbuff2 <= lbuff1;
//				lbuff3 <= lbuff2;
//				lbuff4 <= lbuff3;
//				lbuff5 <= lbuff4;
//				lbuff6 <= lbuff5;
//				lbuff7 <= lbuff6;
//				sum_left <= lbuff0 + lbuff1 + lbuff2 + lbuff3 + lbuff4 + lbuff5 + lbuff6 + lbuff7;	
				sum_left <= readdata_left+noise;		
			end
	end
	
always @ (posedge CLOCK_50)
	begin
		if(read_ready == 1'b1)
			begin
//				rbuff0 <= readdata_right >> 3;
//				rbuff1 <= rbuff0;
//				rbuff2 <= rbuff1;
//				rbuff3 <= rbuff2;
//				rbuff4 <= rbuff3;
//				rbuff5 <= rbuff4;
//				rbuff6 <= rbuff5;
//				rbuff7 <= rbuff6;
//				sum_right <= rbuff0 + rbuff1 + rbuff2 + rbuff3 + rbuff4 + rbuff5 + rbuff6 + rbuff7;		
				sum_right <= readdata_right+noise;
			end
	end
	
noise_generator ng(CLOCK50, enable, noise);

	
	
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
	
