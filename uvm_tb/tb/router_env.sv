class router_env extends uvm_env;
`uvm_component_utils(router_env)

src_agent_top src_agt_top;
dst_agent_top dst_agt_top;
virtual_sequencer virtual_seqrh;
router_score sb;
env_config e_cfg;


extern function new(string name = "router_env", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);

endclass
function router_env::new(string name = "router_env", uvm_component parent);
		super.new(name,parent);
	endfunction

function void router_env::build_phase(uvm_phase phase);
super.build_phase(phase);
if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
`uvm_fatal("GETTING","getting_failed")

virtual_seqrh=virtual_sequencer::type_id::create("virtual_seqrh",this);
src_agt_top=src_agent_top::type_id::create("src_agt_top",this);
dst_agt_top=dst_agent_top::type_id::create("dst_agt_top",this);
sb=router_score::type_id::create("sb",this);
endfunction

function void router_env::connect_phase(uvm_phase phase);


/////////-----------virtual_sequencer_connection----------///////////

for(int i=0;i<e_cfg.no_of_src_agt;i++)
virtual_seqrh.src_seqrh[i]=src_agt_top.src_agt[i].src_seqrh;

for(int i=0;i<e_cfg.no_of_dst_agt;i++)
virtual_seqrh.dst_seqrh[i]=dst_agt_top.dst_agt[i].dst_seqrh;


/////////-----------analysis_fifo_connection----------///////////


foreach(src_agt_top.src_agt[i])
	src_agt_top.src_agt[i].src_monh.mon_port.connect(sb.src_fifo[i].analysis_export);

foreach(dst_agt_top.dst_agt[i])
	dst_agt_top.dst_agt[i].dst_monh.mon_port.connect(sb.dst_fifo[i].analysis_export);
endfunction








 
