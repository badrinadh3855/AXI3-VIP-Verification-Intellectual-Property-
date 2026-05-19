class slave_agent_top extends uvm_env;

`uvm_component_utils(slave_agent_top)

slave_agent sagt[];
environment_config m_cfg;


function new(string name="slave_agent_top",uvm_component parent=null);
super.new(name,parent);
endfunction


function void build_phase(uvm_phase phase);
super.build_phase(phase);
	if(!uvm_config_db#(environment_config)::get(this,"","environment_config",m_cfg))
	`uvm_fatal(get_type_name(),"cannot get configuration in slave agent top")

sagt=new[m_cfg.no_of_slave_agent];
foreach(sagt[i])
begin
		uvm_config_db#(slave_config)::set(this,$sformatf("*sagt[%0d]*",i),"slave_config",m_cfg.slave_cfg[i]);
		sagt[i]=slave_agent::type_id::create($sformatf("sagt[%0d]",i),this);
	end
endfunction

endclass
