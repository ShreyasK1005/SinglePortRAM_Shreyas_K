// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples
`include "define.sv"
`include "interface.sv"
//`include "ram_package.sv";
 `include "ram_transaction.sv"
 `include "ram_generator.sv"
 `include "ram_driver.sv"
 `include "ram_monitor.sv"
 `include "ram_reference_model.sv"
 `include "ram_scoreboard.sv"
 `include "ram_environment.sv"
 `include "ram_test.sv"
module top();
 //Importing the ram package
// import ram_package ::*; 
 //Declaring variables for clock and reset
 logic clk;
 logic reset;
 //Generating the clock
 initial
 begin
 forever #10 clk=~clk; // Period is 20ns --> 
//Frequency is 50Mhz
 end
 //Asserting and de-asserting the reset
 initial
 begin
   clk=0;
 @(posedge clk);
 reset=0;
 repeat(1)@(posedge clk);
 reset=1;
 end
  //Instantiating the interface
 ram_if intrf(clk,reset);
 //Instantiating the DUV
 RAM DUV(.clk(clk),
         .reset(reset),
 .address(intrf.address),
 .data_in(intrf.data_in),
 .write_enb(intrf.write_enb),
 .read_enb(intrf.read_enb), 
 .data_out(intrf.data_out)
 );
 //Instantiating the Test 
 ram_test test= new(intrf.DRV,intrf.MON,intrf.REF_SB);
 //Calling the test's run task which starts the execution of the testbench architecture 
 initial
 begin
 test.run();
 #100 $finish();
 end
  initial
    begin
     $dumpfile("dump.vcd");  
      $dumpvars;
    end
endmodule