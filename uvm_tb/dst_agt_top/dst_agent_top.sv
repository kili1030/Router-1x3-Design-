class dst_agent_top extends uvm_env;
 
`uvm_component_utils(dst_agent_top)
dst_agent dst_agt[];
env_config e_cfg;

extern function new(string name = "dst_agent_top" , uvm_component parent);
extern function void build_phase(uvm_phase phase);
//extern task run_phase(uvm_phase phase);
endclass

function dst_agent_top::new(string name = "dst_agent_top" , uvm_component parent);
super.new(name,parent);
endfunction

function void dst_agent_top::build_phase(uvm_phase phase);
super.build_phase(phase);

if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
`uvm_fatal("GETTING","getting_failed");

dst_agt=new[e_cfg.no_of_dst_agt];

foreach(dst_agt[i])
begin
dst_agt[i]=dst_agent::type_id::create($sformatf("dst_agt[%0d]",i),this);

uvm_config_db #(dst_config)::set(this,$sformatf("dst_agt[%0d]*",i),"dst_config",e_cfg.d_cfg[i]);
end
endfunction

//task dst_agent_top::run_phase(uvm_phase phase);
//endtask



