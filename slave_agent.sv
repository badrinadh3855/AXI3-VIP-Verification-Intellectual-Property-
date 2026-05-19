class slave_agent extends uvm_agent;

`uvm_component_utils(slave_agent)

slave_driver sdrvh;
slave_monitor smonh;
slave_sequencer sseqrh;
slave_config m_cfg;

function new(string name="slave_agent",uvm_component parent=null);
super.new(name,parent);
endfunction

function void build_phase(uvm_phase phase);
super.build_phase(phase);
	if(!uvm_config_db#(slave_config)::get(this,"","slave_config",m_cfg))
		`uvm_fatal(get_type_name(),"cannot get configuration in slave agent")

		smonh=slave_monitor::type_id::create("smonh",this);
		if(is_active==UVM_ACTIVE)
			sdrvh=slave_driver::type_id::create("sdrvh",this);
			sseqrh=slave_sequencer::type_id::create("sseqrh",this);
endfunction


endclass
