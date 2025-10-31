class src_monitor extends uvm_monitor;

`uvm_component_utils(src_monitor)

src_config s_cfg;
virtual router_if.SRC_MON_MP vif;
uvm_analysis_port #(src_xtn) mon_port;
src_xtn xtn;

extern function new(string name = "src_monitor", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task collect_data();

endclass


function src_monitor::new(string name = "src_monitor", uvm_component parent);
super.new(name,parent);
endfunction

function void src_monitor::build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db #(src_config)::get(this,"","src_config",s_cfg))
`uvm_fatal("build_phase","getting failed")
mon_port=new("mon_port",this);	
endfunction

function void src_monitor::connect_phase(uvm_phase phase);
vif=s_cfg.vif;
endfunction

task src_monitor::run_phase(uvm_phase phase);
forever
collect_data();
endtask

task src_monitor::collect_data();
xtn=src_xtn::type_id::create("xtn");
//@(vif.src_mon_cb);


while(vif.src_mon_cb.pkt_vld!==1)
@(vif.src_mon_cb);

while(vif.src_mon_cb.busy!==0)
@(vif.src_mon_cb);
xtn.header=vif.src_mon_cb.din;
xtn.payload=new[xtn.header[7:2]];
@(vif.src_mon_cb);

for(int i=0;i<xtn.header[7:2];i++)
//foreach(xtn.payload[i])
begin
while(vif.src_mon_cb.busy!==0)
@(vif.src_mon_cb);
xtn.payload[i]=vif.src_mon_cb.din;
//xtn.print();
@(vif.src_mon_cb);
end

xtn.parity=vif.src_mon_cb.din;
//xtn.print();

repeat(4)
@(vif.src_mon_cb);
xtn.err=vif.src_mon_cb.err;
//xtn.print();
`uvm_info("ROUTER_rd_mon",$sformatf("printing from source monitor \n %s",xtn.sprint()),UVM_LOW) 

mon_port.write(xtn);

//$display("FROM MONITOR");

endtask







