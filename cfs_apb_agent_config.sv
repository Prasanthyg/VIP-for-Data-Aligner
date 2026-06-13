`ifndef CFS_APB_AGENT_CONFIG_SV
  `define CFS_APB_AGENT_CONFIG_SV
    class cfs_apb_agent_config extends uvm_component; //also can be an object class
    
    //Virtual interface -> declare it as a local variable and access it using getter and setter methods!
    local cfs_apb_vif vif;

    local uvm_active_passive_enum active_passive;

    `uvm_component_utils(cfs_apb_agent_config)

    local bit has_checks;

    local bit has_coverage;//initilaize it to 1 in the constructor and create a getter and setter for it
    
    function new(string name = "", uvm_component parent);
      super.new(name, parent);
      active_passive = UVM_ACTIVE;
      has_coverage  = 1;
    endfunction
    
    //Getter for the APB virtual interface
    virtual function cfs_apb_vif get_vif();
      return vif;
    endfunction
    
    //Setter for the APB virtual interface
    virtual function void set_vif(cfs_apb_vif value);
      if(vif == null) begin
        vif = value;
      end
      else begin
        `uvm_fatal("ALGORITHM_ISSUE", "Trying to set the APB virtual interface more than once")
      end
    endfunction

    virtual function uvm_active_passive_enum get_active_passive();
      return active_passive;
    endfunction

    virtual function void set_active_passive(uvm_active_passive_enum value);
      active_passive = value;
    endfunction

    virtual function bit get_has_coverage();
    return has_coverage;
   endfunction

    virtual function void set_has_coverage(bit value);
      has_coverage = value;
    endfunction
    
    //'cus we used getter and setter methods and also
    //since this config class is a uvm_component we can utilise uvm phases
    //to perfrom certain checks

    //example before run_phase starts, i.e in the start_of_simulation phase
    //we can check if the APB virtual interface is configured or not and print an appropriate message
    virtual function void start_of_simulation_phase(uvm_phase phase);
      super.start_of_simulation_phase(phase);
      
      if(get_vif() == null) begin
        `uvm_fatal("ALGORITHM_ISSUE", "The APB virtual interface is not configured at \"Start of simulation\" phase")
      end
      else begin
        `uvm_info("APB_CONFIG", "The APB virtual interface is configured at \"Start of simulation\" phase", UVM_DEBUG)
      end
    endfunction
    
  endclass

`endif CFS_APB_AGENT_CONFIG_SV