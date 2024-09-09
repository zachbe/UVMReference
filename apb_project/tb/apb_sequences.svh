
//A few flavours of apb sequences

`ifndef APB_SEQUENCES_SV
`define APB_SEQUENCES_SV

//------------------------
//Base APB sequence derived from uvm_sequence and parameterized with sequence item of type apb_rw
//------------------------
class apb_base_seq extends uvm_sequence#(apb_rw);

  `uvm_object_utils(apb_base_seq)

  function new(string name ="");
    super.new(name);
  endfunction

  //Main Body method that gets executed once sequence is started
  task body();
     apb_rw rw_trans;
     //Create 10 random APB read/write transaction and send to driver
     repeat(10) begin
       rw_trans = apb_rw::type_id::create(.name("rw_trans"),.contxt(get_full_name()));
       start_item(rw_trans);
       assert (rw_trans.randomize());
       finish_item(rw_trans);
     end
  endtask
  
endclass

//------------------------
//6.1: Resgiter read/write
//
//Verify that all registers can be read from and written to correctly
//------------------------
class apb_reg_rw_seq extends uvm_sequence#(apb_rw);

  `uvm_object_utils(apb_reg_rw_seq)

  function new(string name ="");
    super.new(name);
  endfunction

  //Main Body method that gets executed once sequence is started
  task body();
     apb_rw w0_trans;
     apb_rw w1_trans;
     apb_rw r0_trans;
     apb_rw r1_trans;
     //Create transactions to write to registers
     //Offsets range from 0x00 to 0x014
     integer addr;
     for (addr = 32'h00; addr <= 32'h014; addr = addr + 32'h004) begin
       // Write all 0
       w0_trans = apb_rw::type_id::create(.name("w0_trans"),.contxt(get_full_name()));
       start_item(w0_trans);
       w0_trans.addr = addr;
       w0_trans.apb_cmd = apb_rw::WRITE;
       w0_trans.data = 32'h0;
       finish_item(w0_trans);
       
       // Read all 0
       r0_trans = apb_rw::type_id::create(.name("r0_trans"),.contxt(get_full_name()));
       start_item(r0_trans);
       r0_trans.addr = addr;
       r0_trans.apb_cmd = apb_rw::READ;
       finish_item(r0_trans);


       // Write all 1
       w1_trans = apb_rw::type_id::create(.name("w1_trans"),.contxt(get_full_name()));
       start_item(w1_trans);
       w1_trans.addr = addr;
       w1_trans.apb_cmd = apb_rw::WRITE;
       w1_trans.data = 32'hFFFFFFFF;
       finish_item(w1_trans);
       
       // Read all 1
       r1_trans = apb_rw::type_id::create(.name("r1_trans"),.contxt(get_full_name()));
       start_item(r1_trans);
       r1_trans.addr = addr;
       r1_trans.apb_cmd = apb_rw::READ;
       finish_item(r1_trans);
       
     end
  endtask
  
endclass

`endif
