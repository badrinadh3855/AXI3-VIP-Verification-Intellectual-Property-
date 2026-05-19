class slave_driver extends uvm_driver#(axi_xtn);

`uvm_component_utils(slave_driver)

virtual axi_sif.SLV_DRV vif;
slave_config s_cfg;
axi_xtn xtn,xtn1;
axi_xtn q1[$],q2[$],q3[$];
int count,ending;

	semaphore sem_awad=new();
	semaphore sem_wdrp=new();
	semaphore sem_awaddr=new(1); //write address
	semaphore sem_awdata=new(1); //write data
	semaphore sem_wrp=new(1); //write response
	semaphore sem_awrp=new(1);

	semaphore sem_radc=new();
	semaphore sem_rac=new(1);
	semaphore sem_rdc=new(1);

//Constructor
function new(string name="slave_driver",uvm_component parent=null);
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

//Run Phase
task run_phase(uvm_phase phase);
forever
	begin
		drive();
	end
endtask

//user defined task 
task drive();
xtn=axi_xtn::type_id::create("xtn");
fork
	begin
		sem_awaddr.get(1);
		read_awaddr(xtn);
		sem_awaddr.put(1);
		sem_awad.put(1);
	end
	begin
		sem_awad.get(1);
		sem_awdata.get(1);
		read_data(q1.pop_front());
		sem_awdata.put(1);
		sem_wdrp.put(1);
	end
	begin
		sem_wdrp.get(1);
		sem_wrp.get(1);
		drive_wresp(q2.pop_front());
		sem_wrp.put(1);
	end
	begin
		sem_rac.get(1);
		slave_raddr();
		sem_rac.put(1);
		sem_radc.put(1);
	end
	begin
		sem_radc.get(1);
		sem_rdc.get(1);
		slave_rdata(q3.pop_front());
		sem_rdc.put(1);
	end
join_any
endtask
	

///////////////////////////////////////////
task read_awaddr(axi_xtn xtn);
$display("start of read_awaddr");
	repeat($urandom_range(1,5))
	@(vif.slv_drv_cb);
		vif.slv_drv_cb.AWREADY<=1;
	@(vif.slv_drv_cb);
		wait(vif.slv_drv_cb.AWVALID);
		
		xtn.AWID=vif.slv_drv_cb.AWID;
		xtn.AWLEN=vif.slv_drv_cb.AWLEN;
		xtn.AWSIZE=vif.slv_drv_cb.AWSIZE;
		xtn.AWBURST=vif.slv_drv_cb.AWBURST;
		xtn.AWVALID=vif.slv_drv_cb.AWVALID;
		xtn.AWADDR=vif.slv_drv_cb.AWADDR;
	
		q1.push_back(xtn);
		q2.push_back(xtn);

	repeat($urandom_range(1,5))
	@(vif.slv_drv_cb);
		vif.slv_drv_cb.AWREADY<=0;
$display("end of read_awaddr");
endtask
		

///////////////////////////////////////////
task read_data(axi_xtn xtn);
int mem[int];
$display("start of read_data");

xtn.cal_addr();

$display("aligned:%0h",xtn.aligned_addr);
$display("address calculated in slave side %p",xtn.addr);

for(int i=0;i<(xtn.AWLEN+1);i++)
begin
	vif.slv_drv_cb.WREADY<=1;
	@(vif.slv_drv_cb);
		wait(vif.slv_drv_cb.WVALID)
		$display("slave driver start of awvalid");
		$display("WSTRB in slave driver is:%p",vif.slv_drv_cb.WSTRB);
				
			if(vif.slv_drv_cb.WSTRB==15)
				mem[xtn.addr[i]]=vif.slv_drv_cb.WDATA;

			if(vif.slv_drv_cb.WSTRB==8)
				mem[xtn.addr[i]]=vif.slv_drv_cb.WDATA[31:24];

			if(vif.slv_drv_cb.WSTRB==4)
				mem[xtn.addr[i]]=vif.slv_drv_cb.WDATA[23:16];

			if(vif.slv_drv_cb.WSTRB==2)
				mem[xtn.addr[i]]=vif.slv_drv_cb.WDATA[15:0];

			if(vif.slv_drv_cb.WSTRB==1)
				mem[xtn.addr[i]]=vif.slv_drv_cb.WDATA[7:0];

			if(vif.slv_drv_cb.WSTRB==7)
				mem[xtn.addr[i]]=vif.slv_drv_cb.WDATA[23:0];

			if(vif.slv_drv_cb.WSTRB==14)
				mem[xtn.addr[i]]=vif.slv_drv_cb.WDATA[31:8];

			if(vif.slv_drv_cb.WSTRB==12)
				mem[xtn.addr[i]]=vif.slv_drv_cb.WDATA[31:16];

			if(vif.slv_drv_cb.WSTRB==3)
				mem[xtn.addr[i]]=vif.slv_drv_cb.WDATA[15:0];

		$display("value inside mem is: %p",mem[xtn.addr[i]]);
		vif.slv_drv_cb.WREADY<=0;
		repeat($urandom_range(1,5))
		count=1;
end
$display("memory is %p",mem);
$display("end of read_data");
endtask



///////////////////////////////////////////
task drive_wresp(axi_xtn xtn);
	$display("start of driver_wresp");
	vif.slv_drv_cb.BVALID<=1;
	vif.slv_drv_cb.BRESP<=0;
	vif.slv_drv_cb.BID<=xtn.AWID;
	$display("BID sent is %d",xtn.AWID);

	@(vif.slv_drv_cb);
	wait(vif.slv_drv_cb.BREADY)
	vif.slv_drv_cb.BVALID<=0;
	vif.slv_drv_cb.BRESP<='hx;

	repeat($urandom_range(1,5))
	@(vif.slv_drv_cb);
	$display("end of drive_wresp");
endtask

	
///////////////////////////////////////////
task slave_raddr();
$display("start of slave_addr");
xtn1=axi_xtn::type_id::create("xtn");

	@(vif.slv_drv_cb);
	vif.slv_drv_cb.ARREADY<=1;
	wait(vif.slv_drv_cb.ARVALID)

		xtn1.ARID=vif.slv_drv_cb.ARID;
		xtn1.ARLEN=vif.slv_drv_cb.ARLEN;
		xtn1.ARSIZE=vif.slv_drv_cb.ARSIZE;
		xtn1.ARBURST=vif.slv_drv_cb.ARBURST;

	q3.push_back(xtn1);
	repeat($urandom_range(1,5))
	@(vif.slv_drv_cb);
	vif.slv_drv_cb.ARREADY<=0;
$display("end of slave_addr");
endtask


///////////////////////////////////////////
task slave_rdata(axi_xtn xtn1);
int length=xtn1.ARLEN;
$display("start of slave_rdata");

	for(int i=0;i<length+1;i++)
	begin
		vif.slv_drv_cb.RDATA<=$urandom;
		vif.slv_drv_cb.RVALID<=1;
		vif.slv_drv_cb.RID<=xtn1.ARID;
		vif.slv_drv_cb.RRESP<=0;
	
		if(i==(length))
			vif.slv_drv_cb.RLAST<=1;
		else
			vif.slv_drv_cb.RLAST<=0;

		@(vif.slv_drv_cb);
		wait(vif.slv_drv_cb.RREADY)
		vif.slv_drv_cb.RVALID<=0;
		vif.slv_drv_cb.RLAST<=0;
		vif.slv_drv_cb.RRESP<='hz;

		repeat($urandom_range(1,5))
		@(vif.slv_drv_cb);
		count=1;
	end
$display("end of slave_rdata");
endtask


endclass
