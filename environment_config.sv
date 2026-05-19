class environment_config extends uvm_sequence_item;

`uvm_object_utils(environment_config)

//properties
bit has_master_agt;
bit has_slave_agt;
bit has_scoreboard;

int no_of_master_agent;
int no_of_slave_agent;

master_config mstr_cfg[];
slave_config slave_cfg[];

//Constructor
function new(string name="environment_config");
super.new(name);
endfunction


endclass
