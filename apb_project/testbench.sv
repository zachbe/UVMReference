//-------------------------------------------
// Top level Test module
//  Includes all env component and sequences files 
//    (you could ideally create an env package and import that as well instead of including)
//-------------------------------------------

 import uvm_pkg::*;
`include "uvm_macros.svh"

 //Include tb files
`include "tb/apb_if.svh"
`include "tb/apb_rw.svh"
`include "tb/apb_driver_seq_mon.svh"
`include "tb/apb_agent_env_config.svh"
`include "tb/apb_sequences.svh"
`include "tb/apb_test.svh"

//Include DUT files
`include "rtl/timer_unit_counter.sv"
`include "rtl/timer_unit_counter_presc.sv"
`include "rtl/apb_timer_unit.sv"

//--------------------------------------------------------
//Top level module that instantiates  just a physical apb interface
//No real DUT or APB slave as of now
//--------------------------------------------------------
module test;

  logic pclk;
  logic rstn;
  
  logic [31:0] paddr;
  logic        psel;
  logic        penable;
  logic        pwrite;
  logic [31:0] prdata;
  logic [31:0] pwdata;

  initial begin
     pclk=0;
     rstn=0;
     #1;
     rstn=1;
  end

   //Generate a clock
  always begin
     #10 pclk = ~pclk;
  end

  //Instantiate a physical interface for APB interface
  apb_if  apb_if(.pclk(pclk),
                 .paddr(paddr),
                 .psel(psel),
                 .penable(penable),
                 .pwrite(pwrite),
                 .prdata(prdata),
                 .pwdata(pwdata));

  //Timer module
  apb_timer_unit timer(
    .HCLK(pclk),
    .HRESETn(rstn),
    .PADDR(paddr),
    .PWDATA(pwdata),
    .PWRITE(pwrite),
    .PSEL(psel),
    .PENABLE(penable),
    .PREADY(pready),
    .PSLVERR(pslverr),

    .ref_clk_i(pclk),
    .stoptimer_i(1'b0),
    .event_lo_i(1'b0),
    .event_hi_i(1'b0));
 
  initial begin
    // Dump a VCD
    $dumpfile("testbench.vcd");
    $dumpvars(0, apb_if);
    $dumpvars(0, timer);
    //Pass this physical interface to test top (which will further pass it down to env->agent->drv/sqr/mon
    uvm_config_db#(virtual apb_if)::set( null, "uvm_test_top", "vif", apb_if);
    
    //Call the test - but passing run_test argument as test class name
    //Another option is to not pass any test argument and use +UVM_TEST on command line to sepecify which test to run
    
    //run_test("apb_base_test");
    //run_test("apb_wr_test");
    run_test("apb_minmax_test");
  end
  
  
endmodule


