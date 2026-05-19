class test extends uvm_test;

`uvm_component_utils(test)

//properties
bit has_master_agt =1;
bit has_slave_agt=1;
bit has_scoreboard=1;

int no_of_master_agent=4;
int no_of_slave_agent=4;

master_config mstr_cfg[];
slave_config slave_cfg[];
environment_config env_cfg;
master_sequence mseq;
environment envh;

//Constructor
function new(string name="test",uvm_component parent);
super.new(name,parent);
endfunction

//Build phase
function void build_phase(uvm_phase phase);
env_cfg=environment_config::type_id::create("env_cfg");

if(has_master_agt)
	env_cfg.mstr_cfg=new[no_of_master_agent];

if(has_slave_agt)
	env_cfg.slave_cfg=new[no_of_slave_agent];

config_db();
uvm_config_db#(environment_config)::set(this,"*","environment_config",env_cfg);
super.build_phase(phase);
envh=environment::type_id::create("envh",this);
endfunction

function void config_db();

if(has_master_agt)
begin
	mstr_cfg=new[no_of_master_agent];
	foreach(mstr_cfg[i])
	begin
		mstr_cfg[i]=master_config::type_id::create($sformatf("master_config[%0d]",i));
		if(!uvm_config_db#(virtual axi_mif)::get(this,"",$sformatf("axi_mif_%0d",i),mstr_cfg[i].vif))
			`uvm_fatal(get_type_name(),"cannot get configuration in test agent")

		mstr_cfg[i].is_active=UVM_ACTIVE;
		env_cfg.mstr_cfg[i]=mstr_cfg[i];
	end
end

if(has_slave_agt)
begin
	slave_cfg=new[no_of_slave_agent];
	foreach(slave_cfg[i])
	begin
		slave_cfg[i]=slave_config::type_id::create($sformatf("slave_config[%0d]",i));
		if(!uvm_config_db#(virtual axi_sif)::get(this,"",$sformatf("axi_sif_%0d",i),slave_cfg[i].vif))
			`uvm_fatal(get_type_name(),"cannot get configuration in test agent")

		slave_cfg[i].is_active=UVM_ACTIVE;
		env_cfg.slave_cfg[i]=slave_cfg[i];
	end
end

env_cfg.has_master_agt=has_master_agt;
env_cfg.has_slave_agt=has_slave_agt;

env_cfg.no_of_master_agent=no_of_master_agent;
env_cfg.no_of_slave_agent=no_of_slave_agent;			
endfunction

//end opf elaboration
function void end_of_elaboration_phase(uvm_phase phase);
uvm_top.print_topology();
endfunction
endclass


/*
///////////////////////  FIXED  ////////////////////////
class test_fixed extends test;

`uvm_component_utils(test_fixed)
master_seq_fixed fseq;
bit[1:0]master_address,slave_address;

//Constructor
function new(string name="test_fixed",uvm_component parent);
super.new(name,parent);
endfunction
//Build Phase
function void build_phase(uvm_phase phase);
super.build_phase(phase);
	uvm_config_db#(bit[1:0])::set(this,"*","master_address",master_address);
	uvm_config_db#(bit[1:0])::set(this,"*","slave_address",slave_address);
endfunction
//Run Phase
task run_phase(uvm_phase phase);
super.run_phase(phase);
phase.raise_objection(this);
	fseq=master_seq_fixed::type_id::create("fseq");
	fseq.start(envh.magt_top.magt[0].mseqrh);
	#500000;
phase.drop_objection(this);
endtask
endclass

///////////////////////  INCREMENT  ////////////////////////
class test_incr extends test;
`uvm_component_utils(test_incr)
master_seq_incr iseq;
bit[1:0]master_address,slave_address;
//Constructor
function new(string name="test_incr",uvm_component parent);
super.new(name,parent);
endfunction
//Build Phase
function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	uvm_config_db#(bit[1:0])::set(this,"*","master_address",master_address);
	uvm_config_db#(bit[1:0])::set(this,"*","slave_address",slave_address);
endfunction
//Run Phase
task run_phase(uvm_phase phase);
super.run_phase(phase);
phase.raise_objection(this);
	iseq=master_seq_incr::type_id::create("iseq");
	iseq.start(envh.magt_top.magt[2].mseqrh);
	#50;
phase.drop_objection(this);
endtask
endclass

///////////////////////  WRAPPER  ////////////////////////
class test_wrap extends test;

`uvm_component_utils(test_wrap)
master_seq_wrap wseq;
bit[1:0]master_address,slave_address;

//Constructor
function new (string name="test_wrap",uvm_component parent);
super.new(name,parent);
endfunction
//Build Phase
function void build_phase(uvm_phase phase);
super.build_phase(phase);
	uvm_config_db#(bit[1:0])::set(this,"*","master_address",master_address);
	uvm_config_db#(bit[1:0])::set(this,"*","slave_address",slave_address);
endfunction
//Run Phase
task run_phase(uvm_phase phase);
super.run_phase(phase);
phase.raise_objection(this);
	wseq=master_seq_wrap::type_id::create("wseq");
	wseq.start(envh.magt_top.magt[3].mseqrh);
	#50
phase.drop_objection(this);
endtask
endclass
*/


class test_fixed extends test;

	virtual_fixed_test seqs;

	`uvm_component_utils(test_fixed)

	function new(string name="test_fixed", uvm_component parent);
		super.new(name,parent);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
			seqs = virtual_fixed_test::type_id::create("seqs");
			seqs.start(envh.vsqrh);
			#5000000;
		phase.drop_objection(this);
	endtask
endclass


class test_incr extends test;

	virtual_incr_test seqs;

	`uvm_component_utils(test_incr)

	function new(string name="test_incr", uvm_component parent);
		super.new(name,parent);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
			seqs = virtual_incr_test::type_id::create("seqs");
			seqs.start(envh.vsqrh);
			#5000000;
		phase.drop_objection(this);
	endtask
endclass



class test_wrap extends test;

	virtual_wrap_test seqs;

	`uvm_component_utils(test_wrap)

	function new(string name="test_incr", uvm_component parent);
		super.new(name,parent);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
			seqs = virtual_wrap_test::type_id::create("seqs");
			seqs.start(envh.vsqrh);
			#5000000;
		phase.drop_objection(this);
	endtask
endclass




