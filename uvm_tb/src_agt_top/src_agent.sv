class src_agent extends uvm_agent;

`uvm_component_utils(src_agent)

src_driver src_drvh;
src_sequencer src_seqrh;
src_monitor src_monh;
src_config s_cfg;

extern function new(string name = "src_agent", uvm_component parent = null);
extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase);
endclass

function src_agent::new(string name = "src_agent", uvm_component parent = null);
super.new(name,parent);
endfunction

function void src_agent::build_phase(uvm_phase phase);
if(!uvm_config_db #(src_config)::get(this,"","src_config",s_cfg))
`uvm_fatal("GETTING","getting_failed");
src_monh=src_monitor::type_id::create("src_monh",this);

if(s_cfg.is_active==UVM_ACTIVE)
begin
src_drvh=src_driver::type_id::create("src_drvh",this);
src_seqrh=src_sequencer::type_id::create("src_seqrh",this);
end
endfunction

function void src_agent::connect_phase(uvm_phase phase);
if(s_cfg.is_active==UVM_ACTIVE)
src_drvh.seq_item_port.connect(src_seqrh.seq_item_export);
endfunction
 









