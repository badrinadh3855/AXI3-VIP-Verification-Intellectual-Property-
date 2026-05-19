class master_sequence extends uvm_sequence#(axi_xtn);

`uvm_object_utils(master_sequence)

//Constructor
function new(string name="master_sequence");
super.new(name);
endfunction

endclass

class master_fixed_seq00 extends master_sequence;

	`uvm_object_utils(master_fixed_seq00)
	bit [1:0] master_address = 2'b00;
	bit [1:0] slave_address  = 2'b00;

	function new(string name="master_fixed_seq");

		super.new(name);

	endfunction


	task body();


		begin
			
			req= axi_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with { AWBURST == 0; ARBURST == 0; write_slave == master_address; read_slave == slave_address;});
			finish_item(req);

		end

	endtask
endclass

class master_fixed_seq01 extends master_sequence;

	`uvm_object_utils(master_fixed_seq01)
	bit [1:0] master_address = 2'b01;
	bit [1:0] slave_address  = 2'b01;

	function new(string name="master_fixed_seq");

		super.new(name);

	endfunction


	task body();


		begin
			
			req= axi_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with { AWBURST == 0; ARBURST == 0; write_slave == master_address; read_slave == slave_address;});
			finish_item(req);

		end

	endtask
endclass
class master_fixed_seq10 extends master_sequence;

	`uvm_object_utils(master_fixed_seq10)
	bit [1:0] master_address = 2'b10;
	bit [1:0] slave_address  = 2'b10;

	function new(string name="master_fixed_seq");

		super.new(name);

	endfunction


	task body();

		begin
			
			req= axi_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with { AWBURST == 0; ARBURST == 0; write_slave == master_address; read_slave == slave_address;});
			finish_item(req);

		end

	endtask
endclass
class master_fixed_seq11 extends master_sequence;

	`uvm_object_utils(master_fixed_seq11)
	bit [1:0] master_address = 2'b11;
	bit [1:0] slave_address  = 2'b11;

	function new(string name="master_fixed_seq");

		super.new(name);

	endfunction


	task body();

		begin
			
			req= axi_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with { AWBURST == 0; ARBURST == 0; write_slave == master_address; read_slave == slave_address;});
			finish_item(req);

		end

	endtask
endclass


class master_incr_seq00 extends master_sequence;

	`uvm_object_utils(master_incr_seq00)
	bit [1:0] master_address = 2'b00;
	bit [1:0] slave_address  = 2'b00;

	function new(string name="master_incr_seq");

		super.new(name);

	endfunction


	task body();


		begin
			
			req= axi_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with { AWBURST == 1; ARBURST == 1; write_slave == master_address; read_slave == slave_address;});
			finish_item(req);

		end

	endtask
endclass

class master_incr_seq01 extends master_sequence;

	`uvm_object_utils(master_incr_seq01)
	bit [1:0] master_address = 2'b01;
	bit [1:0] slave_address  = 2'b01;

	function new(string name="master_incr_seq");

		super.new(name);

	endfunction


	task body();


		begin
			
			req= axi_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with { AWBURST == 1; ARBURST == 1; write_slave == master_address; read_slave == slave_address;});
			finish_item(req);

		end

	endtask
endclass
class master_incr_seq10 extends master_sequence;

	`uvm_object_utils(master_incr_seq10)
	bit [1:0] master_address = 2'b10;
	bit [1:0] slave_address  = 2'b10;

	function new(string name="master_incr_seq");

		super.new(name);

	endfunction


	task body();

		begin
			
			req= axi_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with { AWBURST == 1; ARBURST == 1; write_slave == master_address; read_slave == slave_address;});
			finish_item(req);

		end

	endtask
endclass
class master_incr_seq11 extends master_sequence;

	`uvm_object_utils(master_incr_seq11)
	bit [1:0] master_address = 2'b11;
	bit [1:0] slave_address  = 2'b11;

	function new(string name="master_incr_seq");

		super.new(name);

	endfunction


	task body();

		begin
			
			req= axi_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with { AWBURST == 1; ARBURST == 1; write_slave == master_address; read_slave == slave_address;});
			finish_item(req);

		end

	endtask
endclass

class master_wrap_seq00 extends master_sequence;

	`uvm_object_utils(master_wrap_seq00)
	bit [1:0] master_address = 2'b00;
	bit [1:0] slave_address  = 2'b00;

	function new(string name="master_wrap_seq");

		super.new(name);

	endfunction


	task body();


		begin
			
			req= axi_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with { AWBURST == 2; ARBURST == 2; write_slave == master_address; read_slave == slave_address;});
			finish_item(req);

		end

	endtask
endclass

class master_wrap_seq01 extends master_sequence;

	`uvm_object_utils(master_wrap_seq01)
	bit [1:0] master_address = 2'b01;
	bit [1:0] slave_address  = 2'b01;

	function new(string name="master_wrap_seq");

		super.new(name);

	endfunction


	task body();


		begin
			
			req= axi_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with { AWBURST == 2; ARBURST == 2; write_slave == master_address; read_slave == slave_address;});
			finish_item(req);

		end

	endtask
endclass
class master_wrap_seq10 extends master_sequence;

	`uvm_object_utils(master_wrap_seq10)
	bit [1:0] master_address = 2'b10;
	bit [1:0] slave_address  = 2'b10;

	function new(string name="master_wrap_seq");

		super.new(name);

	endfunction


	task body();

		begin
			
			req= axi_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with { AWBURST == 2; ARBURST == 2; write_slave == master_address; read_slave == slave_address;});
			finish_item(req);

		end

	endtask
endclass
class master_wrap_seq11 extends master_sequence;

	`uvm_object_utils(master_wrap_seq11)
	bit [1:0] master_address = 2'b11;
	bit [1:0] slave_address  = 2'b11;

	function new(string name="master_fixed_seq");

		super.new(name);

	endfunction


	task body();

		begin
			
			req= axi_xtn::type_id::create("req");
			start_item(req);
			assert(req.randomize() with { AWBURST == 2; ARBURST == 2; write_slave == master_address; read_slave == slave_address;});
			finish_item(req);

		end

	endtask
endclass






