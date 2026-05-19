class master_agent extends uvm_agent;

`uvm_component_utils(master_agent)

master_driver mdrvh;
master_monitor mmonh;
master_sequencer mseqrh;
master_config m_cfg;

function new(string name="master_agent",uvm_component parent=null);
super.new(name,parent);
endfunction

//Build Phase
function void build_phase(uvm_phase phase);
super.build_phase(phase);
	if(!uvm_config_db#(master_config)::get(this,"","master_config",m_cfg))
		`uvm_fatal(get_type_name(),"cannot get configuration in master agent")

		mmonh=master_monitor::type_id::create("mmonh",this);
		if(is_active==UVM_ACTIVE)
			mdrvh=master_driver::type_id::create("mdrvh",this);
			mseqrh=master_sequencer::type_id::create("mseqrh",this);
endfunction

//Connect phase
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
if(m_cfg.is_active==UVM_ACTIVE)
	mdrvh.seq_item_port.connect(mseqrh.seq_item_export);
endfunction


endclass
