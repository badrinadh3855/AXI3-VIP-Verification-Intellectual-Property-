class master_agent_top extends uvm_env;

`uvm_component_utils(master_agent_top)
master_agent magt[];
environment_config m_cfg;

function new(string name="master_agent_top",uvm_component parent=null);
super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
super.build_phase(phase);
	if(!uvm_config_db#(environment_config)::get(this,"","environment_config",m_cfg))
	`uvm_fatal(get_type_name(),"cannot get configuration in master agent top")

magt=new[m_cfg.no_of_master_agent];
foreach(magt[i])
begin
		uvm_config_db#(master_config)::set(this,$sformatf("*magt[%0d]*",i),"master_config",m_cfg.mstr_cfg[i]);
		magt[i]=master_agent::type_id::create($sformatf("magt[%0d]",i),this);
	end
endfunction

endclass
