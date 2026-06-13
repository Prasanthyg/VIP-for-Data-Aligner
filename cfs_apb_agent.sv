`ifndef  CFS_APB_AGENT_SV
  `define CFS_APB_AGENT_SV

  class cfs_apb_agent extends uvm_agent;

  ` uvm_component_utils(cfs_apb_agent)
  function new(string name = "", uvm_component parent);
  super.new(name, parent);
  endfunction


  //building a handler for apb_agent_config class and building an instance of it
  //in the build phase
    
    cfs_apb_agent_config agent_config;
    
    //drv, sqr, monior, coverage handler after the comment post the connect phase
    cfs_apb_driver driver;
    cfs_apb_sequencer sequencer;
    cfs_apb_monitor monitor;
    
    
    
    cfs_apb_coverage coverage;


    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        agent_config = cfs_apb_agent_config::type_id::create("agent_config", this);

        if(agent_config.get_active_passive()==UVM_ACTIVE) begin
            driver = cfs_apb_drive::type_id::create("driver", this);
            sequencer = cfs_apb_sequencer::type_id::create("sequencer", this);
            //follow this up with connecting the seq_item_port of driver with seq_item_export of sequencer in the connect phase of the agent

        end

        if(agent_config.get_has_coverage()==1) begin
          coverage = cfs_apb_coverage::type_id::create("coverage", this);
          //post this proceed to populate the apb_coverage class with the appropriate coverage points and bins in the 
          //build phase of the coverage class

      end
    endfunction

    //follow this up with creating an instance of our agent in the environoment
    //post this set the virtual interface in the config db in the  connect phase of the agent

    virtual function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        cfs_apb_vif vif;
        string      vif_name = "vif";

        if(!uvm_config_db(cfs_apb_vif vif)::get(this,"",vif_name , vif)) begin
            `uvm_fatal("APB_NO_VIF", $sformatf("Could not get from the database the APB virtual interface using name \"%0s\"", vif_name))
        end
        else begin
            agent_config.set_vif(vif);
        end
        
        //connecting the monitor to coverage using the uvm_analysis_impl_decl(_item) instance declated in the coverage class
        if(agent_config.get_has_coverage()) begin
          monitor.output_port.connect(coverage.port_item);
        end

        //see the omment in the build phase about connecting the seq_item_port of driver with seq_item_export of sequencer
        if(agent_config.get_active_passive()==UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
            driver.agent_config = agent_config;//connect the agent config handler to the driver and monitor 
            //so that they can access the vif and the control fields in the agent config class
        end

        
    endfunction

    //instantiating the driver and sequencer in the agent, do this based on the active passive control in the agent config class

   

   
    
    
  endclass

`endif