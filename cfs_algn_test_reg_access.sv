`ifndef CFS_ALGN_TEST_REG_ACCESS_SV
  `define CFS_ALGN_TEST_REG_ACCESS_SV

  class cfs_algn_test_reg_access extends cfs_algn_test_base;

    `uvm_component_utils(cfs_algn_test_reg_access)
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
    endfunction
    
    virtual task run_phase(uvm_phase phase);
        phase.raise_objection(this, "TEST_DONE");

      //call the simple sequnence, start it, by creating an instance of it and sending it to the sequnecer

      #(100ns);

      //parallelizing the three sequences, simple, rw and random, and see the generated code for each of them in the sequence body task, 
      //and also see the difference in the generated code when we use the `uvm_do macro in the simple sequence instead of start_item and finish_item methods
    fork  
        begin 
            cfs_apb_sequence_simple seq_simple = cfs_apb_sequence_simple::type_id::create("seq_simple"); ;
            
            void'(seq_simple.randomize() with {
                item.addr == 'h222;
            });
            seq_simple.start(env.apb_agent.sequencer);
    
        end

        begin 
            cfs_apb_sequence_rw seq_rw = cfs_apb_sequence_rw::type_id::create("seq_rw"); ;
            
            void'(seq_rw.randomize() with {
                addr == 'h4; //example, seq should randomize the address to 4 and the direction to read, and the data can be random
            });
            seq_rw.start(env.apb_agent.sequencer);
    
        end

        begin 
            cfs_apb_sequence_random seq_random = cfs_apb_sequence_random::type_id::create("seq_random"); ;
            
            void'(seq_random.randomize() with {
                num_items == 3; //example, seq should randomize the number of items to 5 and each item should be randomized as well
            });
            seq_random.start(env.apb_agent.sequencer);
    
        end
    join

      `uvm_info("DEBUG", "this is the end of the test", UVM_LOW)


      phase.drop_objection(this, "TEST_DONE"); 

      
    endtask
   
    
    
  endclass

`endif