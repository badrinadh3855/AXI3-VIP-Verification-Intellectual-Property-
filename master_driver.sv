class master_driver extends uvm_driver#(axi_xtn);

`uvm_component_utils(master_driver)

virtual axi_mif.AXI_MDRV mvif;
master_config m_cfg;
	
axi_xtn xtn;
axi_xtn q1[$],q2[$],q3[$],q4[$],q5[$];
	
	semaphore sem_awdc = new();//Write address dependency signal
	semaphore sem_wdrc = new();//write data dependency
	semaphore sem_wdc = new(1);//write data
	semaphore sem_awc = new(1);//write address
	semaphore sem_wrc = new(1);//Write response

	semaphore sem_ardc = new();//Read address dependency
	semaphore sem_arc = new(1);//read address
	semaphore sem_rdc = new(1);//read data

//Constructor
function new(string name="master_driver",uvm_component parent=null);
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
	mvif=m_cfg.vif;
endfunction 

//Run phase
task run_phase(uvm_phase phase);
	super.run_phase(phase);
forever
	begin
	seq_item_port.get_next_item(req);
	drive(req);
	`uvm_info(get_type_name(),$sformatf("Prinitng from driver %s",req.sprint()),UVM_LOW)
	seq_item_port.item_done();
	end
endtask

//User defined task
task drive(axi_xtn xtn);
q1.push_back(xtn);
q2.push_back(xtn);
q3.push_back(xtn);
q4.push_back(xtn);
q5.push_back(xtn);
fork
	begin
		sem_awc.get(1);
		drive_awaddr(q1.pop_front());
		sem_awdc.put(1);
		sem_awc.put(1);
	end

	begin
               	sem_awdc.get(1);
		sem_wdc.get(1);
		drive_wdata(q2.pop_front());
		sem_wdc.put(1);
		sem_wdrc.put(1);
	end

	begin
		sem_wdrc.get(1);
		sem_wrc.get(1);
		drive_bresp(q3.pop_front());
		sem_wrc.put(1);
	end

	begin
		sem_arc.get(1);
		drive_raddr(q4.pop_front());
		sem_arc.put(1);
		sem_ardc.put(1);
	end

	begin
		sem_ardc.get(1);
		sem_rdc.get(1);
		drive_rdata(q5.pop_front());
		sem_rdc.put(1);
	end
join_any
endtask

//Driving write address
task drive_awaddr(axi_xtn xtn);
	$display("start of drive_awaddr");
	@(mvif.mst_drv_cb)
	mvif.mst_drv_cb.AWVALID<=1;
	mvif.mst_drv_cb.AWADDR<=xtn.AWADDR;
	mvif.mst_drv_cb.AWSIZE<=xtn.AWSIZE;
	mvif.mst_drv_cb.AWID<=xtn.AWID;
	mvif.mst_drv_cb.AWLEN<=xtn.AWLEN;
	mvif.mst_drv_cb.AWBURST<=xtn.AWBURST;

	@(mvif.mst_drv_cb);
	wait(mvif.mst_drv_cb.AWREADY)
	mvif.mst_drv_cb.AWVALID<=0;
	
	repeat($urandom_range(1,5))
		@(mvif.mst_drv_cb);
	
	$display("end of drive_awadrr");
endtask

//Driving write data
task drive_wdata(axi_xtn xtn);
	$display("start ofdrive_wdata");
	@(mvif.mst_drv_cb)
foreach(xtn.WDATA[i])
		begin
			mvif.mst_drv_cb.WVALID<=1;
			mvif.mst_drv_cb.WDATA<=xtn.WDATA[i];
			mvif.mst_drv_cb.WSTRB<=xtn.WSTRB[i];
			mvif.mst_drv_cb.WID<=xtn.WID;
			if(i==(xtn.AWLEN))
				mvif.mst_drv_cb.WLAST<=1;
			else
				mvif.mst_drv_cb.WLAST<=0;
			
			@(mvif.mst_drv_cb);
			wait(mvif.mst_drv_cb.WREADY)
				mvif.mst_drv_cb.WVALID<=0;
				mvif.mst_drv_cb.WLAST<=0;

			repeat($urandom_range(1,5))
				@(mvif.mst_drv_cb);

		end
		$display("end of drive_wdata");

endtask

//Driving write response
task drive_bresp(axi_xtn xtn);
	$display("start ofdrive_bresp");
	@(mvif.mst_drv_cb)
	mvif.mst_drv_cb.BREADY<=1;
	@(mvif.mst_drv_cb);
	wait(mvif.mst_drv_cb.BVALID)
		mvif.mst_drv_cb.BREADY<=0;
		repeat($urandom_range(1,5))
			@(mvif.mst_drv_cb);
	
	$display("end of drive_bresp");
endtask

//Driving read address
task drive_raddr(axi_xtn xtn);
	$display("start of drive_raddr");
	repeat($urandom_range(1,5))
		@(mvif.mst_drv_cb);
	mvif.mst_drv_cb.ARVALID<=1;
	mvif.mst_drv_cb.ARADDR<=xtn.ARADDR;
	mvif.mst_drv_cb.ARSIZE<=xtn.ARSIZE;
	mvif.mst_drv_cb.ARID<=xtn.ARID;
	mvif.mst_drv_cb.ARLEN<=xtn.ARLEN;
	mvif.mst_drv_cb.ARBURST<=xtn.ARBURST;
//	q5.push_back(xtn);
		@(mvif.mst_drv_cb);
	$display("inside drive_raddr before wait ARREADY");
		wait(mvif.mst_drv_cb.ARREADY)
					
		mvif.mst_drv_cb.ARVALID<=0;
		repeat($urandom_range(1,5))
			@(mvif.mst_drv_cb);
	
	$display("end of drive_raddr");
endtask

//Driving read data/response
task drive_rdata(axi_xtn xtn);
int mem[int];
$display("start of drive_rdata");
	for(int i=0;i<(xtn.ARLEN+1);i++)
		begin
			mvif.mst_drv_cb.RREADY<=1;
			@(mvif.mst_drv_cb);
			wait(mvif.mst_drv_cb.RVALID)
				
			mvif.mst_drv_cb.RREADY<=0;
			repeat($urandom_range(1,5))
			@(mvif.mst_drv_cb);
		end
	$display("end of drive_rdata");
endtask

endclass

