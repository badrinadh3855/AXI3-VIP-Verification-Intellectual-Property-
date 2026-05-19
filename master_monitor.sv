class master_monitor extends uvm_monitor;

`uvm_component_utils(master_monitor)

//uvm_analysis_port#(axi_xtn)mst_mon_port;
virtual axi_mif.MST_MON vif;
master_config m_cfg;
axi_xtn xtn,xtn1,xtn2,xtn3,xtn4;
axi_xtn q1[$],q2[$];


	semaphore sem_awdc = new();
	semaphore sem_wdrc = new();
	semaphore sem_wdc = new(1);
	semaphore sem_awc = new(1);
	semaphore sem_wrc = new(1);

	semaphore sem_ardc = new();
	semaphore sem_arc = new(1);
	semaphore sem_rdc = new(1);


//Constructor
function new(string name="master_monitor",uvm_component parent=null);
super.new(name,parent);
endfunction

//Build phase
function void build_phase(uvm_phase phase);
super.build_phase(phase);
	if(!uvm_config_db#(master_config)::get(this,"","master_config",m_cfg))
		`uvm_fatal(get_type_name(),"get the fatal")
endfunction

//Connect phase
function void connect_phase(uvm_phase phase);
super.connect_phase(phase);
vif=m_cfg.vif;
endfunction 

//Run Phase
task run_phase(uvm_phase phase);
forever
	begin
		collect_data();
	end
endtask

//user defined 
task collect_data();
fork
	begin
		sem_awc.get(1);
		collect_awaddr();
		sem_awdc.put(1);
		sem_awc.put(1);
	end

	begin
               
		sem_awdc.get(1);
		sem_wdc.get(1);
		collect_wdata(q1.pop_front());
		sem_wdc.put(1);
		sem_wdrc.put(1);
	end

	begin
		sem_wdrc.get(1);
		sem_wrc.get(1);
		collect_bresp();
		sem_wrc.put(1);
	end

	begin
		sem_arc.get(1);
		collect_raddr();
		sem_arc.put(1);
		sem_ardc.put(1);
	end

	begin
		sem_ardc.get(1);
		sem_rdc.get(1);
		collect_rdata(q2.pop_front());
		sem_rdc.put(1);
	end
join_any
endtask

//////////////////////////////////////////////////////
task collect_awaddr();
xtn = axi_xtn::type_id::create("xtn");
wait(vif.mst_mon_cb.AWVALID && vif.mst_mon_cb.AWREADY)
	
	xtn.AWVALID = vif.mst_mon_cb.AWVALID;
	xtn.AWADDR = vif.mst_mon_cb.AWADDR;
	xtn.AWSIZE = vif.mst_mon_cb.AWSIZE;
	xtn.AWID = vif.mst_mon_cb.AWID;
	xtn.AWLEN = vif.mst_mon_cb.AWLEN;
	xtn.AWBURST = vif.mst_mon_cb.AWBURST;
	q1.push_back(xtn);

	`uvm_info(get_type_name(),$sformatf("Printing from waddr collect task %s",xtn.sprint()),UVM_LOW)

	@(vif.mst_mon_cb);
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
		wait(vif.mst_mon_cb.WVALID && vif.mst_mon_cb.WREADY)
		xtn1.WSTRB[i] = vif.mst_mon_cb.WSTRB;
				
		if(vif.mst_mon_cb.WSTRB == 15)
			xtn1.WDATA[i] = vif.mst_mon_cb.WDATA;

		if(vif.mst_mon_cb.WSTRB == 8)
			xtn1.WDATA[i] = vif.mst_mon_cb.WDATA[31:24];

		if(vif.mst_mon_cb.WSTRB == 4)
			xtn1.WDATA[i] = vif.mst_mon_cb.WDATA[23:16];

		if(vif.mst_mon_cb.WSTRB == 2)
			xtn1.WDATA[i] = vif.mst_mon_cb.WDATA[15:8];

		if(vif.mst_mon_cb.WSTRB == 1)
			xtn1.WDATA[i] = vif.mst_mon_cb.WDATA[7:0];

		if(vif.mst_mon_cb.WSTRB == 7)
			xtn1.WDATA[i] = vif.mst_mon_cb.WDATA[23:0];

		if(vif.mst_mon_cb.WSTRB == 14)
			xtn1.WDATA[i] = vif.mst_mon_cb.WDATA[31:0];

		if(vif.mst_mon_cb.WSTRB == 12)
			xtn1.WDATA[i] = vif.mst_mon_cb.WDATA[31:16];

		if(vif.mst_mon_cb.WSTRB == 3)
			xtn1.WDATA[i] = vif.mst_mon_cb.WDATA[15:0];

			xtn1.WID = vif.mst_mon_cb.WID;
			xtn1.WLAST = vif.mst_mon_cb.WLAST;
			xtn1.WVALID = vif.mst_mon_cb.WVALID;
			@(vif.mst_mon_cb);
	end

`uvm_info(get_type_name(),$sformatf("Printing from wdata collect task %s",xtn1.sprint()),UVM_LOW)
endtask


////////////////////////////////////////////////////////////
task collect_bresp();	
	xtn2= axi_xtn::type_id::create("xtn2");
	wait(vif.mst_mon_cb.BREADY && vif.mst_mon_cb.BVALID)
	xtn2.BRESP = vif.mst_mon_cb.BRESP;
	`uvm_info(get_type_name(),$sformatf("Printing from wresponse collect task %s",xtn3.sprint()),UVM_LOW)
	@(vif.mst_mon_cb);
endtask


//////////////////////////////////////////////////////
task collect_raddr();
xtn3 = axi_xtn::type_id::create("xtn3");
wait(vif.mst_mon_cb.ARVALID && vif.mst_mon_cb.ARREADY)
	xtn3.ARVALID = vif.mst_mon_cb.ARVALID;
	xtn3.ARADDR = vif.mst_mon_cb.ARADDR;
	xtn3.ARSIZE = vif.mst_mon_cb.ARSIZE;
	xtn3.ARID = vif.mst_mon_cb.ARID;
	xtn3.ARLEN = vif.mst_mon_cb.ARLEN;
	xtn3.ARBURST = vif.mst_mon_cb.ARBURST;
	q2.push_back(xtn3);

	`uvm_info(get_type_name(),$sformatf("Printing from waddr collect task %s",xtn3.sprint()),UVM_LOW)

	@(vif.mst_mon_cb);
endtask


//////////////////////////////////////////////////////	
task collect_rdata(axi_xtn xtnh);
xtn4 = axi_xtn::type_id::create("xtn4");
xtn4 = xtnh;
xtn4.cal_raddr();
xtn4.RDATA = new[xtn4.ARLEN + 1];
foreach(xtn4.RDATA[i]) 
	begin
		wait(vif.mst_mon_cb.RVALID && vif.mst_mon_cb.RREADY)

			xtn4.RDATA[i] = vif.mst_mon_cb.RDATA ;
			xtn4.RID = vif.mst_mon_cb.RID;
			xtn4.RRESP[i] = vif.mst_mon_cb.RRESP;
			xtn4.RLAST = vif.mst_mon_cb.RLAST;
			xtn4.RVALID = vif.mst_mon_cb.RVALID;
			xtn4.RREADY = vif.mst_mon_cb.RREADY;

	end

`uvm_info(get_type_name(),$sformatf("Printing from wdata collect task %s",xtn4.sprint()),UVM_LOW)
@(vif.mst_mon_cb);
endtask
				
endclass


