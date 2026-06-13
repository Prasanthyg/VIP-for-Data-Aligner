`ifndef CFS_APB_SEQUENCE_SIMPLE_SV
  `define CFS_APB_SEQUENCE_SIMPLE_SV

class cfs_apb_sequence_simple extends cfs_apb_sequence_base;
    
    rand cfs_apb_item_drv item;//random item to be sent to the sequencer, and create it prior to randomization in the constructor of the sequence class.   
    
    `uvm_object_utils(cfs_apb_sequence_simple)
    
    function new(string name = "");
      super.new(name);
      item = cfs_apb_item_drv::type_id::create("item");//could also use the pregenrate function
    endfunction

    virtual task body();
      //send it to the sequencer using the start_item, finish_item and get_next_item methods of the uvm_sequence class
      start_item(item);
      finish_item(item);
    endtask
    //post this , in the test , get to starting this sequence

    //replace start_item, finish_item and get_next_item with the `uvm_do macros, and see the difference in the generated code in the sequence body task
    //`uvm_do(item); //wont work with the constraint we mentioned for the
    //instance of this item in the reg_access' run_phase task 'cuz the uvm_do macro will create a new instance of the item and randomize it!!

endclass

`endif