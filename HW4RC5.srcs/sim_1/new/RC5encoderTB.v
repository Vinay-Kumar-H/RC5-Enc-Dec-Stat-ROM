`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/12/2021 02:26:01 PM
// Design Name: 
// Module Name: RC5encoderTB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module RC5encoderTB(

);
    reg  clk;
    reg clr;
    reg[63:0] din;
    wire[63:0] dout;
    reg[63:0] file_din;
    reg[63:0] file_dout;
    integer file_pointer;
    RC5Encoder UUT (.clk(clk),.clr(clr),.din(din),.dout(dout));
    always begin : clock_generation
            clk<=0;
            #25
            clk<=1;
            #25;
    end
    //comment below always block if we want to use clr as part of data assignment process
    always begin : clr_generation
            clr<=0;
            #25
            clr<=1;
            #575;
    end
    
    always  begin
        file_pointer=$fopen("message.mem","r");
        if(file_pointer==0)begin
            $display("could not open the test case file, please check it");
            $finish;
        end
        while(!$feof(file_pointer)) begin
            $fscanf(file_pointer,"%h %h\n",file_din,file_dout);
            assign din=file_din;
             /*We can use this if we don't want to write seperate process for clr
             clr<=0;
             #25
             clr<=1;
             #575*/
             //If we write seperate process for clear the delay will be twice as that of clr cycle, to offset the timing delay,
             //as both this block and clr block run in combination.
            #1150
            if(dout!=file_dout) begin
                $display("The test case didn't passs, %h!=%h",dout,file_dout);
                $finish;
            end
        end
        $display("All test completed successfully");
        $finish;
    end

endmodule
