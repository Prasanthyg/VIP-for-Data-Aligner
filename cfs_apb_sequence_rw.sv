`ifndef CFS_APB_SEQUENCE_RW_SV
  `define CFS_APB_SEQUENCE_RW_SV

  class cfs_apb_sequence_rw extends cfs_apb_sequence_base;
    
    //Address
    rand cfs_apb_addr addr;
    
    //Write data
    rand cfs_apb_data wr_data;
    
    `uvm_object_utils(cfs_apb_sequence_rw)
    
    function new(string name = "");
      super.new(name);
    endfunction

    virtual task body();
        cfs_apb_item_drv item;
        item = cfs_apb_item_drv::type_id::create("item");

        //randomize the item and constraint the direction and address

        void'(item.randomize() with {
            dir = CFS_APB_READ;
            addr == local::addr;

        });

        start_item(item);
        finish_item(item);

        //post this add this in the test and call start(sequncer)

        //writing with `uvm_do_with, however the create() is not needed here, hence we should stick one of `uvm_do() or start/finish_item
        `uvm_do_with(item, {
            dir = CFS_APB_WRITE;
            addr == local::addr;
            data == local::wr_data;
        });

    endtask

endclass

`endif