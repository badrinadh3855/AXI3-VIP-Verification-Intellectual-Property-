class slave_monitor extends uvm_monitor;

`uvm_component_utils(slave_monitor)
virtual axi_sif.SLV_MON vif;
slave_config s_cfg;
axi_xtn xtn,xtn1,xtn2,xtn3,xtn4;
axi_xtn q1[$], q2[$];

	semaphore sem_wac = new(1);
	semaphore sem_wadd = new();
	semaphore sem_wdc = new(1);
	semaphore sem_wrc = new(1);
	semaphore sem_drdc = new();
	semaphore sem_radd = new();
	semaphore sem_rac = new(1);
	semaphore sem_rdc = new(1);

//Constructor
function new(string name="slave_monitor",uvm_component parent=null);
super.new(name,parent);
endfunction

//Build Phase
function void build_phase(uvm_phase phase);
super.build_phase(phase);
	if(!uvm_config_db#(slave_config)::get(this,"","slave_config",s_cfg))
		`uvm_fatal(get_type_name(),"cannot get configuration in slave driver")
endfunction

//Connect Phase
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
vif=s_cfg.vif;
endfunction



task run_phase(uvm_phase phase);
super.run_phase(phase);
	forever
		collect_data();
endtask


task collect_data();

	fork
		begin
			sem_wac.get(1);
			collect_waddr();
			sem_wac.put(1);
			sem_wadd.put(1);
		end

		begin
			sem_wadd.get(1);
			sem_wdc.get(1);
			collect_wdata(q1.pop_front());
			sem_drdc.put(1);
			sem_wdc.put(1);
		end

		begin
			sem_drdc.put(1);
			sem_wrc.put(1);
			collect_wresp();
			sem_wrc.put(1);
		end

		begin
			sem_rac.get(1);
			collect_raddr();
			sem_radd.put(1);
			sem_rac.put(1);
		end

		begin
			sem_radd.get(1);
			sem_rdc.get(1);
			collect_rdata(q2.pop_front());
			sem_rdc.put(1);
		end
	join_any
endtask


//////////////////////////////////////////////////////
task collect_waddr();
xtn = axi_xtn::type_id::create("xtn");
wait(vif.slv_mon_cb.AWVALID && vif.slv_mon_cb.AWREADY)
	
	xtn.AWVALID = vif.slv_mon_cb.AWVALID;
	xtn.AWADDR = vif.slv_mon_cb.AWADDR;
	xtn.AWSIZE = vif.slv_mon_cb.AWSIZE;
	xtn.AWID = vif.slv_mon_cb.AWID;
	xtn.AWLEN = vif.slv_mon_cb.AWLEN;
	xtn.AWBURST = vif.slv_mon_cb.AWBURST;
	q1.push_back(xtn);

	`uvm_info(get_type_name(),$sformatf("Printing from waddr collect task %s",xtn.sprint()),UVM_LOW)

	@(vif.slv_mon_cb);
endtask

//////////////////////////////////////////////////////
task collect_wdata(axi_xtn xtnh);

	xtn1 = axi_xtn::type_id::create("xtn1");
	xtn1 = xtn;
	xtn1.cal_addr();
	xtn1.WDATA = new[xtn.AWLEN+1];
	xtn1.WSTRB = new[xtn.WDATA.size()];
	
	foreach(xtn1.WDATA[i]) 
	begin
		wait(vif.slv_mon_cb.WVALID && vif.slv_mon_cb.WREADY)
		xtn1.WSTRB[i] = vif.slv_mon_cb.WSTRB;
				
		if(vif.slv_mon_cb.WSTRB == 15)
			xtn1.WDATA[i] = vif.slv_mon_cb.WDATA;

		if(vif.slv_mon_cb.WSTRB == 8)
			xtn1.WDATA[i] = vif.slv_mon_cb.WDATA[31:24];

		if(vif.slv_mon_cb.WSTRB == 4)
			xtn1.WDATA[i] = vif.slv_mon_cb.WDATA[23:16];

		if(vif.slv_mon_cb.WSTRB == 2)
			xtn1.WDATA[i] = vif.slv_mon_cb.WDATA[15:8];

		if(vif.slv_mon_cb.WSTRB == 1)
			xtn1.WDATA[i] = vif.slv_mon_cb.WDATA[7:0];

		if(vif.slv_mon_cb.WSTRB == 7)
			xtn1.WDATA[i] = vif.slv_mon_cb.WDATA[23:0];

		if(vif.slv_mon_cb.WSTRB == 14)
			xtn1.WDATA[i] = vif.slv_mon_cb.WDATA[31:0];

		if(vif.slv_mon_cb.WSTRB == 12)
			xtn1.WDATA[i] = vif.slv_mon_cb.WDATA[31:16];

		if(vif.slv_mon_cb.WSTRB == 3)
			xtn1.WDATA[i] = vif.slv_mon_cb.WDATA[15:0];

			xtn1.WID = vif.slv_mon_cb.WID;
			xtn1.WLAST = vif.slv_mon_cb.WLAST;
			xtn1.WVALID = vif.slv_mon_cb.WVALID;
			@(vif.slv_mon_cb);
	end

`uvm_info(get_type_name(),$sformatf("Printing from wdata collect task %s",xtn1.sprint()),UVM_LOW)
endtask


////////////////////////////////////////////////////////////
task collect_wresp();	
	xtn2= axi_xtn::type_id::create("xtn2");
	wait(vif.slv_mon_cb.BREADY && vif.slv_mon_cb.BVALID)
	xtn2.BRESP = vif.slv_mon_cb.BRESP;
	`uvm_info(get_type_name(),$sformatf("Printing from wresponse collect task %s",xtn3.sprint()),UVM_LOW)
	@(vif.slv_mon_cb);
endtask


//////////////////////////////////////////////////////
task collect_raddr();
xtn3 = axi_xtn::type_id::create("xtn3");
wait(vif.slv_mon_cb.ARVALID && vif.slv_mon_cb.ARREADY)
	xtn3.ARVALID = vif.slv_mon_cb.ARVALID;
	xtn3.ARADDR = vif.slv_mon_cb.ARADDR;
	xtn3.ARSIZE = vif.slv_mon_cb.ARSIZE;
	xtn3.ARID = vif.slv_mon_cb.ARID;
	xtn3.ARLEN = vif.slv_mon_cb.ARLEN;
	xtn3.ARBURST = vif.slv_mon_cb.ARBURST;
	q2.push_back(xtn3);

	`uvm_info(get_type_name(),$sformatf("Printing from waddr collect task %s",xtn3.sprint()),UVM_LOW)

	@(vif.slv_mon_cb);
endtask


//////////////////////////////////////////////////////	
task collect_rdata(axi_xtn xtnh);
xtn4 = axi_xtn::type_id::create("xtn4");
xtn4 = xtnh;
xtn4.cal_raddr();
xtn4.RDATA = new[xtn4.ARLEN + 1];
foreach(xtn4.RDATA[i]) 
	begin
		wait(vif.slv_mon_cb.RVALID && vif.slv_mon_cb.RREADY)

			xtn4.RDATA[i] = vif.slv_mon_cb.RDATA ;
			xtn4.RID = vif.slv_mon_cb.RID;
			xtn4.RRESP[i] = vif.slv_mon_cb.RRESP;
			xtn4.RLAST = vif.slv_mon_cb.RLAST;
			xtn4.RVALID = vif.slv_mon_cb.RVALID;
			xtn4.RREADY = vif.slv_mon_cb.RREADY;

	end

`uvm_info(get_type_name(),$sformatf("Printing from wdata collect task %s",xtn4.sprint()),UVM_LOW)
@(vif.slv_mon_cb);
endtask
				
endclass


