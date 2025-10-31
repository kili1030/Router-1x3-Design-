class router_base_test extends uvm_test;
 `uvm_component_utils(router_base_test)

env_config e_cfg;
router_env envh;
src_config s_cfg[];
dst_config d_cfg[];

int no_of_src_agt=1;
int no_of_dst_agt=3;

extern function new(string name="router_base_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern function void end_of_elaboration_phase(uvm_phase phase);
endclass

function router_base_test::new(string name="router_base_test", uvm_component parent);
super.new(name,parent);
endfunction

function void router_base_test::build_phase(uvm_phase phase);
super.build_phase(phase);


e_cfg=env_config::type_id::create("e_cfg",this);

e_cfg.s_cfg=new[no_of_src_agt];
e_cfg.d_cfg=new[no_of_dst_agt];

s_cfg=new[no_of_src_agt];

foreach(s_cfg[i])
begin
s_cfg[i]=src_config::type_id::create($sformatf("s_cfg[%0d]",i),this);

if(!uvm_config_db #(virtual router_if)::get(this,"","in",s_cfg[i].vif))
`uvm_fatal("GETTING_SRC","getting_failed");
s_cfg[i].is_active=UVM_ACTIVE;
e_cfg.s_cfg=s_cfg;
end

d_cfg=new[no_of_dst_agt];
foreach(d_cfg[i])
begin
d_cfg[i]=dst_config::type_id::create($sformatf("d_cfg[%0d]",i),this);

if(!uvm_config_db #(virtual router_if)::get(this,"",$sformatf("in%0d",i),d_cfg[i].vif))
`uvm_fatal("GETTING_DST","getting_failed")

d_cfg[i].is_active=UVM_ACTIVE;
e_cfg.d_cfg=d_cfg;

end

//e_cfg.s_cfg=s_cfg;
//e_cfg.d_cfg=d_cfg;

e_cfg.no_of_src_agt=no_of_src_agt;
e_cfg.no_of_dst_agt=no_of_dst_agt;

uvm_config_db #(env_config)::set(this,"*","env_config",e_cfg);
envh=router_env::type_id::create("envh",this);

endfunction

function void router_base_test::end_of_elaboration_phase(uvm_phase phase);
uvm_top.print_topology();
endfunction

//\/\/\/\/\/\/\/\/\/\/\/SMALL_TEST/\/\/\/\/\/\/\/\/\/


class small_test extends router_base_test;
`uvm_component_utils(small_test);
//small_pkt s_seq;
//normal_seq n_seq;
//soft_seq sftq;
small_vseq low_vh;
med_vseq medh;
big_vseq bigh;
err_vseq errh;

bit [1:0]addr;
extern function new(string name="small_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

function small_test::new(string name="small_test", uvm_component parent);
super.new(name,parent);
endfunction

function void small_test::build_phase(uvm_phase phase);
super.build_phase(phase);

endfunction

task small_test::run_phase(uvm_phase phase);
super.run_phase(phase);
low_vh=small_vseq::type_id::create("low_vh");

phase.raise_objection(this);
repeat(25)
begin
addr={$urandom}%3;
uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

low_vh.start(envh.virtual_seqrh);
end
#100
phase.drop_objection(this);

endtask

//\/\/\/\/\/\/\/\/\/\/\/MEDIUM_TEST/\/\/\/\/\/\/\/\/\/


class med_test extends router_base_test;
`uvm_component_utils(med_test)
//normal_seq n_seq;
med_pkt m_seq;
soft_seq sftq;
med_vseq medh;
bit [1:0]addr;

extern function new(string name="med_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

function med_test::new(string name="med_test", uvm_component parent);
super.new(name,parent);
endfunction

function void med_test::build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction


task med_test::run_phase(uvm_phase phase);
super.run_phase(phase);
medh=med_vseq::type_id::create("medh");

phase.raise_objection(this);
repeat(25)
begin
addr={$urandom}%3;
uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);
medh.start(envh.virtual_seqrh);
end
#50;
phase.drop_objection(this);
endtask

//\/\/\/\/\/\/\/\/\/\/\/BIG_TEST/\/\/\/\/\/\/\/\/\/


class big_test extends router_base_test;
`uvm_component_utils(big_test)

//big_pkt b_seq;
bit [1:0]addr;
big_pkt b_seq;
//normal_seq n_seq;
soft_seq softq;
big_vseq bigh;
extern function new(string name="big_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
//extern task body();
endclass

function big_test::new(string name="big_test", uvm_component parent);
super.new(name,parent);
endfunction

function void big_test::build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction


task big_test::run_phase(uvm_phase phase);
super.run_phase(phase);
bigh=big_vseq::type_id::create("bigh");

phase.raise_objection(this);
repeat(25)
begin
addr={$urandom}%3;
uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);
bigh.start(envh.virtual_seqrh);
end
#50;
phase.drop_objection(this);
endtask

//\/\/\/\/\/\/\/\/\/\/\/ERROR_TEST/\/\/\/\/\/\/\/\/\/


class err_test extends router_base_test;
`uvm_component_utils(err_test)

err_pkt e_seq;
bit [1:0]addr;
normal_seq n_seq;
src_xtn req;
err_vseq errh;
extern function new(string name="err_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

function err_test::new(string name="err_test", uvm_component parent);
super.new(name,parent);
endfunction

function void err_test::build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction


task err_test::run_phase(uvm_phase phase);
super.run_phase(phase);
//req=src_xtn::type_id::create("req");
errh=err_vseq::type_id::create("errh");
phase.raise_objection(this);
repeat(25)
begin
addr={$urandom}%3;
uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

errh.start(envh.virtual_seqrh);
//req.parity=8'b11111110;

phase.drop_objection(this);
end
#50;
endtask

///////-----------soft--------////////



class sbad_test extends router_base_test;
`uvm_component_utils(sbad_test);
soft_seq sftq;
small_bseq sbadh;

bit [1:0]addr;
extern function new(string name="sbad_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

function sbad_test::new(string name="sbad_test", uvm_component parent);
super.new(name,parent);
endfunction

function void sbad_test::build_phase(uvm_phase phase);
super.build_phase(phase);

endfunction

task sbad_test::run_phase(uvm_phase phase);
super.run_phase(phase);
sbadh=small_bseq::type_id::create("sbadh");


phase.raise_objection(this);
repeat(25)
begin
addr={$urandom}%3;
uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

sbadh.start(envh.virtual_seqrh);
end
#100
phase.drop_objection(this);

endtask

//\/\/\/\/\/\/\/\/\/\/\/MEDIUM_TEST/\/\/\/\/\/\/\/\/\/


class mbad_test extends router_base_test;
`uvm_component_utils(mbad_test)
soft_seq sftq;
med_bseq mbadh;
bit [1:0]addr;

extern function new(string name="mbad_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

function mbad_test::new(string name="mbad_test", uvm_component parent);
super.new(name,parent);
endfunction

function void mbad_test::build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction


task mbad_test::run_phase(uvm_phase phase);
super.run_phase(phase);
mbadh=med_bseq::type_id::create("mbadh");
phase.raise_objection(this);
repeat(25)
begin
addr={$urandom}%3;
uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

mbadh.start(envh.virtual_seqrh);
end
#50;
phase.drop_objection(this);
endtask

//\/\/\/\/\/\/\/\/\/\/\/BIG_TEST/\/\/\/\/\/\/\/\/\/


class bbad_test extends router_base_test;
`uvm_component_utils(bbad_test)

//big_pkt b_seq;
bit [1:0]addr;
soft_seq softq;
big_bseq bbadh;
extern function new(string name="bbad_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
//extern task body();
endclass

function bbad_test::new(string name="bbad_test", uvm_component parent);
super.new(name,parent);
endfunction

function void bbad_test::build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction


task bbad_test::run_phase(uvm_phase phase);
super.run_phase(phase);
bbadh=big_bseq::type_id::create("bbadh");
phase.raise_objection(this);
repeat(25)
begin
addr={$urandom}%3;
uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);
bbadh.start(envh.virtual_seqrh);
end
#50;
phase.drop_objection(this);
endtask

//\/\/\/\/\/\/\/\/\/\/\/ERROR_TEST/\/\/\/\/\/\/\/\/\/


class ebad_test extends router_base_test;
`uvm_component_utils(ebad_test)
src_xtn req;
bit [1:0]addr;

err_bseq ebadh;
extern function new(string name="ebad_test", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

function ebad_test::new(string name="ebad_test", uvm_component parent);
super.new(name,parent);
endfunction

function void ebad_test::build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction


task ebad_test::run_phase(uvm_phase phase);
super.run_phase(phase);
ebadh=err_bseq::type_id::create("ebadh");
//req=src_xtn::type_id::create("req");
phase.raise_objection(this);
repeat(25)
begin
addr={$urandom}%3;
uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

ebadh.start(envh.virtual_seqrh);
//req.parity=8'b11111110;
end
#50;
phase.drop_objection(this);
endtask


//-------------------code_coverage_test---------------------//


/*class small_cov extends router_base_test;
`uvm_component_utils(small_cov)
//err_vseq errh;
bit [1:0]addr;

small_bseq sbadh;
med_vseq medh;
big_bseq bbadh;
err_vseq errh;

small_vseq low_vh;
med_bseq mbadh;
big_vseq bigh;
err_bseq ebadh;

extern function new(string name="small_cov", uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

function small_cov::new(string name="small_cov", uvm_component parent);
super.new(name,parent);
endfunction

function void small_cov::build_phase(uvm_phase phase);
super.build_phase(phase);
endfunction


task small_cov::run_phase(uvm_phase phase);
super.run_phase(phase);

sbadh=small_bseq::type_id::create("sbadh");
medh=med_vseq::type_id::create("medh");
bbadh=big_bseq::type_id::create("bbadh");
errh=err_vseq::type_id::create("errh");

low_vh=small_vseq::type_id::create("low_vh");
mbadh=med_bseq::type_id::create("mbadh");
bigh=big_vseq::type_id::create("bigh");
ebadh=err_bseq::type_id::create("ebadh");


phase.raise_objection(this);
repeat(10)
begin
addr={$urandom}%3;
uvm_config_db #(bit[1:0])::set(this,"*","addr",addr);

sbadh.start(envh.virtual_seqrh);
low_vh.start(envh.virtual_seqrh);

medh.start(envh.virtual_seqrh);
mbadh.start(envh.virtual_seqrh);

bbadh.start(envh.virtual_seqrh);
bigh.start(envh.virtual_seqrh);

errh.start(envh.virtual_seqrh);
ebadh.start(envh.virtual_seqrh);
end

phase.drop_objection(this);
endtask*/














