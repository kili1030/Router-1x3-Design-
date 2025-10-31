class src_driver extends uvm_driver #(src_xtn);

`uvm_component_utils(src_driver)

virtual router_if.SRC_DRV_MP vif;
src_config s_cfg;

extern function new(string name ="src_driver",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut(src_xtn req);

endclass

function src_driver::new(string name ="src_driver",uvm_component parent);
super.new(name,parent);
endfunction

function void src_driver::build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db #(src_config)::get(this,"","src_config",s_cfg))
`uvm_fatal("build_phase","getting failed")	
endfunction

function void src_driver::connect_phase(uvm_phase phase);
vif=s_cfg.vif;
endfunction

task src_driver::run_phase(uvm_phase phase);
super.run_phase(phase);

@(vif.src_drv_cb);
vif.src_drv_cb.rst<=1'b0;
@(vif.src_drv_cb);
vif.src_drv_cb.rst<=1'b1;

forever
begin
seq_item_port.get_next_item(req);
send_to_dut(req);
seq_item_port.item_done(); 
end
endtask

/////////-----------send_to_dut----------///////////


task src_driver::send_to_dut(src_xtn req);
while(vif.src_drv_cb.busy!==0)
@(vif.src_drv_cb);
vif.src_drv_cb.pkt_vld<=1'b1;
vif.src_drv_cb.din<=req.header;
@(vif.src_drv_cb);

foreach(req.payload[i])
begin
//@(vif.src_drv_cb);
while(vif.src_drv_cb.busy!==0)
@(vif.src_drv_cb);
vif.src_drv_cb.din<=req.payload[i];
@(vif.src_drv_cb);
end

vif.src_drv_cb.pkt_vld<=1'b0;
vif.src_drv_cb.din<=req.parity;
req.print();


repeat(2)
@(vif.src_drv_cb);
req.err=vif.src_drv_cb.err;
@(vif.src_drv_cb);
endtask





