module filter_tb();
    reg CLOCK_50;
    reg [23:0] in;
    wire [23:0] out;
    reg read_ready;

    filter DUT(CLOCK_50, in, out, read_ready);

    initial begin
        CLOCK_50 = 0; #5;
        forever begin
            CLOCK_50 = 1; #5;
            CLOCK_50 = 0; #5;
        end
    end

    // task checker_out;  // create checker to check for out
    //     input [23:0] expected_out;
    //     begin 
    //         if( out !== expected_out ) begin
    //         $display("ERROR ** out is %b, expected out is %b", out, expected_out);
    //         err = 1'b1;
    //         end
    //     end
    // endtask


    initial begin
        read_ready = 1'b1;
        #10;
        in = 8;
        #10;
        in = 16;
        #10; 
        in = 8;
        #10;  
        in = 32;
        #10;
        in = 8;
        #10; 
        in = 16;
        #10; 
        in = 8;
        #10; 
        in = 8;
        #10; 
        in = 24;
        #10;
        in = 16;
        #10;
        in = 8;
        #10;
        
    end



endmodule