class src_config extends uvm_object;

`uvm_object_utils(src_config)
virtual router_if vif;

uvm_active_passive_enum is_active = UVM_ACTIVE;



extern function new(string name = "src_config");

endclass

function src_config::new(string name="src_config");
super.new(name);
endfunction



