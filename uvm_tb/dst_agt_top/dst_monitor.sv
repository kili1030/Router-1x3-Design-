class dst_monitor extends uvm_component;
`uvm_component_utils(dst_monitor)
virtual router_if.DST_MON_MP vif;
dst_config d_cfg;
dst_xtn xtn;
uvm_analysis_port #(dst_xtn) mon_port;

extern function new(string name="dst_monitor",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();

endclass

function dst_monitor::new(string name="dst_monitor",uvm_component parent);
super.new(name,parent);
endfunction

function void dst_monitor::build_phase(uvm_phase phase);
if(!uvm_config_db #(dst_config)::get(this,"","dst_config",d_cfg))
`uvm_fatal("build_phase","getting failed")
mon_port=new("mon_port",this);	
	
endfunction

function void dst_monitor::connect_phase(uvm_phase phase);
vif=d_cfg.vif;
endfunction


task dst_monitor::run_phase(uvm_phase phase);
forever

collect_data();

endtask

task dst_monitor::collect_data();
xtn=dst_xtn::type_id::create("xtn");
while(vif.dst_mon_cb.renb!==1)
@(vif.dst_mon_cb);

@(vif.dst_mon_cb);
xtn.header=vif.dst_mon_cb.dout;
xtn.payload=new[xtn.header[7:2]];
@(vif.dst_mon_cb);

foreach(xtn.payload[i])
begin
xtn.payload[i]=vif.dst_mon_cb.dout;
@(vif.dst_mon_cb);
end

xtn.parity=vif.dst_mon_cb.dout;
@(vif.dst_mon_cb);
`uvm_info("ROUTER_rd_mon",$sformatf("printing from dest monitor \n %s",xtn.sprint()),UVM_LOW) 

//@(vif.dst_mon_cb);
//@(vif.dst_mon_cb);


//xtn.print();
mon_port.write(xtn);
endtask
