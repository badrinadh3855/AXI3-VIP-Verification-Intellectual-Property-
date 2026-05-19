class virtual_sequence_base extends uvm_sequence #(uvm_sequence_item);


	`uvm_object_utils(virtual_sequence_base)


	master_sequencer ms_seqr[];

	environment_config axi_cfg;

	virtual_sequencer vsqr;
	function new(string name="virtual_sequence");
		super.new(name);
	endfunction

	task body();

		if(!uvm_config_db #(environment_config)::get(null,get_full_name(),"environment_config", axi_cfg))
			`uvm_fatal(get_type_name(),"Error in getting configuration")


		ms_seqr = new[axi_cfg.no_of_slave_agent];

		assert($cast(vsqr,m_sequencer))
		else
			`uvm_error(get_full_name(),"error in casting")



		foreach(ms_seqr[i]) begin
			ms_seqr[i] = vsqr.ms_seqr[i];
		end

	endtask

endclass



class virtual_fixed_test extends virtual_sequence_base;

	`uvm_object_utils(virtual_fixed_test)


	master_fixed_seq00 fixed_seq00;
	master_fixed_seq01 fixed_seq01;
	master_fixed_seq10 fixed_seq10;
	master_fixed_seq11 fixed_seq11;


	function new(string name="virtual_incr_test");
		super.new(name);
	endfunction

	task body();

		super.body();	
		fixed_seq00 = master_fixed_seq00::type_id::create("fixed_seq00");
		fixed_seq01 = master_fixed_seq01::type_id::create("fixed_seq01");
		fixed_seq10 = master_fixed_seq10::type_id::create("fixed_seq10");
		fixed_seq11 = master_fixed_seq11::type_id::create("fixed_seq11");

		fork
			fixed_seq00.start(ms_seqr[0]);
			fixed_seq01.start(ms_seqr[1]);
			fixed_seq10.start(ms_seqr[2]);
			fixed_seq11.start(ms_seqr[3]);
		join
	endtask

endclass




class virtual_incr_test extends virtual_sequence_base;

	`uvm_object_utils(virtual_incr_test)


	master_incr_seq00 incr_seq00;
	master_incr_seq01 incr_seq01;
	master_incr_seq10 incr_seq10;
	master_incr_seq11 incr_seq11;


	function new(string name="virtual_incr_test");
		super.new(name);
	endfunction

	task body();

		super.body();	
		incr_seq00 = master_incr_seq00::type_id::create("incr_seq00");
		incr_seq01 = master_incr_seq01::type_id::create("incr_seq01");
		incr_seq10 = master_incr_seq10::type_id::create("incr_seq10");
		incr_seq11 = master_incr_seq11::type_id::create("incr_seq11");

		fork
			incr_seq00.start(ms_seqr[0]);
			incr_seq01.start(ms_seqr[1]);
			incr_seq10.start(ms_seqr[2]);
			incr_seq11.start(ms_seqr[3]);
		join
	endtask

endclass



class virtual_wrap_test extends virtual_sequence_base;

	`uvm_object_utils(virtual_wrap_test)


	master_wrap_seq00 wrap_seq00;
	master_wrap_seq01 wrap_seq01;
	master_wrap_seq10 wrap_seq10;
	master_wrap_seq11 wrap_seq11;


	function new(string name="virtual_incr_test");
		super.new(name);
	endfunction

	task body();

		super.body();	
		wrap_seq00 = master_wrap_seq00::type_id::create("wrap_seq00");
		wrap_seq01 = master_wrap_seq01::type_id::create("wrap_seq01");
		wrap_seq10 = master_wrap_seq10::type_id::create("wrap_seq10");
		wrap_seq11 = master_wrap_seq11::type_id::create("wrap_seq11");

		fork
			wrap_seq00.start(ms_seqr[0]);
			wrap_seq01.start(ms_seqr[1]);
			wrap_seq10.start(ms_seqr[2]);
			wrap_seq11.start(ms_seqr[3]);
		join
	endtask

endclass
