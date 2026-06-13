`ifndef CFS_APB_DRIVER_SV
  `define CFS_APB_DRIVER_SV

class cfs_apb_driver exends uvm_driver#(.REQ(cfs_apb_item_drv));
    `uvm_component_utils(cfs_apb_driver)

    function new(string name = "", uvm_component parent);
        super.new(name, parent);    

    endfunction

    //run phase of the driver get_next_item , display it  instead of driving it and then call item_done()
    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        cfs_apb_item_drv item;//item in which we'll get the data from the sequences
        forever begin
            //get the next item , and use the above item.
            //when a sequenece is called and the task drives one item we will get that
            //info using the pointer  below
            seq_item_port.get_next_item(item);
            //display the item
            `uvm_info("DEBUG", $sformatf("Driving \"%0s\": %0s", item.get_full_name(), item.convert2string()), UVM_NONE)            
            //indicate that the item is done
            seq_item_port.item_done();
        end
    endtask

endclass

`endif