class virtual_seqs extends uvm_sequence #(uvm_sequence_item);
`uvm_object_utils(virtual_seqs)
  
bit [1:0]addr;

src_sequencer src_seqrh[];
dst_sequencer dst_seqrh[];
virtual_sequencer v_seqrh;

small_pkt lowh;
med_pkt medh;
big_pkt bigh;
err_pkt errh;

normal_seq normh;
soft_seq softh;

env_config e_cfg;

 
extern function new(string name="virtual_seqs");
extern task body();
endclass

function virtual_seqs::new(string name="virtual_seqs");
super.new(name);
endfunction

task virtual_seqs::body();

if(!uvm_config_db #(env_config)::get(null,get_full_name(),"env_config",e_cfg))
	`uvm_fatal("virtual_seqs","getting failed")

src_seqrh=new[e_cfg.no_of_src_agt];
dst_seqrh=new[e_cfg.no_of_dst_agt];

assert($cast(v_seqrh,m_sequencer)) else begin
    `uvm_error("BODY", "Error in $cast of virtual sequencer")
  end

foreach(src_seqrh[i])
	src_seqrh[i]=v_seqrh.src_seqrh[i];
foreach(dst_seqrh[i])
	dst_seqrh[i]=v_seqrh.dst_seqrh[i];
 
endtask: body

//\/\/\/\/\/\/\/\/\/\/\/SMALL_VSEQ/\/\/\/\/\/\/\/\/\/


class small_vseq extends virtual_seqs;
`uvm_object_utils(small_vseq)
normal_seq normh;
small_pkt lowh;
bit [1:0]addr;
	extern function new(string name = "small_vseq");
	extern task body();
endclass

function small_vseq::new(string name="small_vseq");
super.new(name);
endfunction

task small_vseq::body();
                 super.body();

if(!uvm_config_db #(bit [1:0])::get(null,get_full_name(),"addr",addr))
`uvm_fatal("getting","getting_failed") 

lowh=small_pkt::type_id::create("lowh");
//medh=med_pkt::type_id::create("medh");
//bigh=big_pkt::type_id::create("bigh");
normh=normal_seq::type_id::create("normh");
//softh=soft_seq::type_id::create("softh");
fork
lowh.start(src_seqrh[0]);
//medh.start(v_seqrh.src_seqrh[0]);
//bigh.start(v_seqrh.src_seqrh[0]);
normh.start(dst_seqrh[addr]);
//softh.start(v_seqrh.dst_seqrh[addr]);

join

endtask

//\/\/\/\/\/\/\/\/\/\/\/MEDIUM_VSEQ/\/\/\/\/\/\/\/\/\/


class med_vseq extends virtual_seqs;
`uvm_object_utils(med_vseq)
bit [1:0]addr;
	extern function new(string name = "med_vseq");
	extern task body();
endclass

function med_vseq::new(string name="med_vseq");
super.new(name);
endfunction

task med_vseq::body();
                 super.body();

if(!uvm_config_db #(bit [1:0])::get(null,get_full_name(),"addr",addr))
`uvm_fatal("getting","getting_failed") 

normh=normal_seq::type_id::create("normh");
//softh=soft_seq::type_id::create("softh");
medh=med_pkt::type_id::create("medh");
fork
medh.start(src_seqrh[0]);

normh.start(dst_seqrh[addr]);
//softh.start(v_seqrh.dst_seqrh[addr]);

join

endtask


//\/\/\\/\\/\/\/\/\/\/\/\/BIG_VSEQ/\/\/\/\/\/\/\/\/\/\/\/\/\/


class big_vseq extends virtual_seqs;
`uvm_object_utils(big_vseq)
bit [1:0]addr;
	extern function new(string name = "big_vseq");
	extern task body();
endclass

function big_vseq::new(string name="big_vseq");
super.new(name);
endfunction

task big_vseq::body();
                 super.body();

if(!uvm_config_db #(bit [1:0])::get(null,get_full_name(),"addr",addr))
`uvm_fatal("getting","getting_failed") 

normh=normal_seq::type_id::create("normh");
//softh=soft_seq::type_id::create("softh");
bigh=big_pkt::type_id::create("bigh");
fork
bigh.start(src_seqrh[0]);

normh.start(dst_seqrh[addr]);
//softh.start(v_seqrh.dst_seqrh[addr]);

join

endtask


//\/\/\/\/\/\/\/\/\/\/\/\ERROR_VSEQ/\/\\/\/\/\/\/\/\/\/\/\/\/


class err_vseq extends virtual_seqs;
`uvm_object_utils(err_vseq)
bit [1:0]addr;
	extern function new(string name = "err_vseq");
	extern task body();
endclass

function err_vseq::new(string name="err_vseq");
super.new(name);
endfunction

task err_vseq::body();
                 super.body();

if(!uvm_config_db #(bit [1:0])::get(null,get_full_name(),"addr",addr))
`uvm_fatal("getting","getting_failed") 

normh=normal_seq::type_id::create("normh");
//softh=soft_seq::type_id::create("softh");
errh=err_pkt::type_id::create("errh");
fork
errh.start(src_seqrh[0]);
normh.start(dst_seqrh[addr]);
//softh.start(v_seqrh.dst_seqrh[addr]);

join

endtask


/////------------------soft------------------///////




class small_bseq extends virtual_seqs;
`uvm_object_utils(small_bseq)

soft_seq softh;
small_pkt lowh;
bit [1:0]addr;
	extern function new(string name = "small_bseq");
	extern task body();
endclass

function small_bseq::new(string name="small_bseq");
super.new(name);
endfunction

task small_bseq::body();
                 super.body();

if(!uvm_config_db #(bit [1:0])::get(null,get_full_name(),"addr",addr))
`uvm_fatal("getting","getting_failed") 

lowh=small_pkt::type_id::create("lowh");
softh=soft_seq::type_id::create("softh");
fork
lowh.start(src_seqrh[0]);
softh.start(v_seqrh.dst_seqrh[addr]);
join

endtask

//\/\/\/\/\/\/\/\/\/\/\/MEDIUM_VSEQ/\/\/\/\/\/\/\/\/\/


class med_bseq extends virtual_seqs;
`uvm_object_utils(med_bseq)
bit [1:0]addr;
	extern function new(string name = "med_bseq");
	extern task body();
endclass

function med_bseq::new(string name="med_bseq");
super.new(name);
endfunction

task med_bseq::body();
                 super.body();

if(!uvm_config_db #(bit [1:0])::get(null,get_full_name(),"addr",addr))
`uvm_fatal("getting","getting_failed") 

softh=soft_seq::type_id::create("softh");
medh=med_pkt::type_id::create("medh");
fork
medh.start(src_seqrh[0]);

softh.start(v_seqrh.dst_seqrh[addr]);

join

endtask


//\/\/\\/\\/\/\/\/\/\/\/\/BIG_VSEQ/\/\/\/\/\/\/\/\/\/\/\/\/\/


class big_bseq extends virtual_seqs;
`uvm_object_utils(big_bseq)
bit [1:0]addr;
	extern function new(string name = "big_bseq");
	extern task body();
endclass

function big_bseq::new(string name="big_bseq");
super.new(name);
endfunction

task big_bseq::body();
                 super.body();

if(!uvm_config_db #(bit [1:0])::get(null,get_full_name(),"addr",addr))
`uvm_fatal("getting","getting_failed") 

softh=soft_seq::type_id::create("softh");
bigh=big_pkt::type_id::create("bigh");
fork
bigh.start(src_seqrh[0]);

softh.start(v_seqrh.dst_seqrh[addr]);

join

endtask


//\/\/\/\/\/\/\/\/\/\/\/\ERROR_VSEQ/\/\\/\/\/\/\/\/\/\/\/\/\/


class err_bseq extends virtual_seqs;
`uvm_object_utils(err_bseq)
bit [1:0]addr;
	extern function new(string name = "err_bseq");
	extern task body();
endclass

function err_bseq::new(string name="err_bseq");
super.new(name);
endfunction

task err_bseq::body();
                 super.body();

if(!uvm_config_db #(bit [1:0])::get(null,get_full_name(),"addr",addr))
`uvm_fatal("getting","getting_failed") 

softh=soft_seq::type_id::create("softh");
errh=err_pkt::type_id::create("errh");
fork
errh.start(src_seqrh[0]);
softh.start(v_seqrh.dst_seqrh[addr]);

join

endtask














