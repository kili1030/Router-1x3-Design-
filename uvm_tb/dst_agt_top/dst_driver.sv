class dst_driver extends uvm_driver #(dst_xtn);

`uvm_component_utils(dst_driver)

virtual router_if.DST_DRV_MP vif;
dst_config d_cfg;

extern function new(string name ="dst_driver",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task send_to_dut(dst_xtn req);

endclass

function dst_driver::new(string name ="dst_driver",uvm_component parent);
super.new(name,parent);
endfunction

function void dst_driver::build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db #(dst_config)::get(this,"","dst_config",d_cfg))
`uvm_fatal("build_phase","getting failed")	
endfunction

function void dst_driver::connect_phase(uvm_phase phase);
vif=d_cfg.vif;
endfunction

task dst_driver::run_phase(uvm_phase phase);
super.run_phase(phase);
forever
begin
seq_item_port.get_next_item(req);
send_to_dut(req);
//`uvm_info("ROUTER_rd_DRIVER",$sformatf("printing from driver \n %s", req.sprint()),UVM_LOW) 

seq_item_port.item_done(req);
end
endtask

task dst_driver::send_to_dut(dst_xtn req);
while (vif.dst_drv_cb.vld_out!==1)
@(vif.dst_drv_cb);

repeat(req.delay)

@(vif.dst_drv_cb);
vif.dst_drv_cb.renb<=1'b1;
@(vif.dst_drv_cb);
//req.print();

while(vif.dst_drv_cb.vld_out!==0)
@(vif.dst_drv_cb);
req.print();

@(vif.dst_drv_cb);
vif.dst_drv_cb.renb<=1'b0;
//@(vif.dst_drv_cb);

//$display("destination driver");
//`uvm_info("ROUTER_rd_DRIVER",$sformatf("printing from driver \n %s", req.sprint()),UVM_LOW) 
endtask




