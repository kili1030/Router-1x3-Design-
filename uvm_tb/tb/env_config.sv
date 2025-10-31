class env_config extends uvm_object;

src_config s_cfg[];
dst_config d_cfg[];

`uvm_object_utils(env_config)

int no_of_src_agt;
int no_of_dst_agt;

extern function new(string name="env_config");
endclass

function env_config::new(string name="env_config");
super.new(name);
endfunction

