class slave_sequence extends uvm_sequence#(axi_xtn);

`uvm_object_utils(slave_sequence)

function new(string name="slave_sequence");
super.new(name);
endfunction

endclass
