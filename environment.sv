class environment extends uvm_env;

`uvm_component_utils(environment)

//properties
master_agent_top magt_top;
slave_agent_top sagt_top;
scoreboard sb;
environment_config m_cfg;
virtual_sequencer vsqrh;
//Constructor
function new(string name="environment",uvm_component parent=null);
super.new(name,parent);
endfunction

//Build phase
function void build_phase(uvm_phase phase);
super.build_phase(phase);
	if(!uvm_config_db#(environment_config)::get(this,"","environment_config",m_cfg))
		`uvm_fatal(get_type_name(),"cannot get configuration in environment agent")

	if(m_cfg.has_master_agt)
		magt_top=master_agent_top::type_id::create("magt_top",this);

	if(m_cfg.has_slave_agt)
		sagt_top=slave_agent_top::type_id::create("sagt_top",this);

	if(m_cfg.has_scoreboard)
		sb=scoreboard::type_id::create("sb",this);

		vsqrh = virtual_sequencer::type_id::create("req",this);
endfunction

//Connect Phase
/*function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
endfunction

*/


	function void connect_phase(uvm_phase phase);
		for(int i=0; i<m_cfg.no_of_master_agent; i++) begin
			vsqrh.ms_seqr[i] = magt_top.magt[i].mseqrh ;
		end
	endfunction
endclass
