
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
// NEW: RW TEST
// This sequence creates 5 pairs of transactions.
// Each pair consists of a write transaction to a random address.
// Then, a read transaction is issued to the same address.
//------------------------
class apb_wr_seq extends uvm_sequence#(apb_rw);

  `uvm_object_utils(apb_wr_seq)

  function new(string name ="");
    super.new(name);
  endfunction

  //Main Body method that gets executed once sequence is started
  task body();
     apb_rw w_trans;
     apb_rw r_trans;
     //Create 5 pairs of AHB read-write transactions with the same address.
     repeat(5) begin
       w_trans = apb_rw::type_id::create(.name("w_trans"),.contxt(get_full_name()));
       start_item(w_trans);
       assert (w_trans.randomize()); // Random data and addr
       w_trans.apb_cmd = apb_rw::WRITE;
       finish_item(w_trans);
       
       r_trans = apb_rw::type_id::create(.name("r_trans"),.contxt(get_full_name()));
       start_item(r_trans);
       r_trans.apb_cmd = apb_rw::READ;
       r_trans.addr = w_trans.addr;
       finish_item(r_trans);
     end
  endtask
  
endclass

`endif
