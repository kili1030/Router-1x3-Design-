class src_seqs extends uvm_sequence #(src_xtn);

`uvm_object_utils(src_seqs)


extern function new(string name="src_seqs");
endclass

function src_seqs::new(string name="src_seqs");
super.new(name);
endfunction

//\/\/\/\/\/\/\/\/\/\/\/SMALL_PACKET/\/\/\/\/\/\/\/\/\/

class small_pkt extends src_seqs;
`uvm_object_utils(small_pkt);

bit [1:0]addr;

extern function new(string name="small_pkt");
extern task body();
endclass

function small_pkt::new(string name="small_pkt");
super.new(name);
endfunction

task small_pkt::body();
if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
`uvm_fatal("GETTING","getting_failed")
//super.body();
req=src_xtn::type_id::create("req");


start_item(req);

assert(req.randomize() with {header[7:2]inside{[1:20]};header[1:0]==addr;})

finish_item(req);

endtask

//\/\/\/\/\/\/\/\/\/\/\/MEDIUM_PACKET/\/\/\/\/\/\/\/\/\/

class med_pkt extends src_seqs;
`uvm_object_utils(med_pkt);

bit [1:0]addr;

extern function new(string name="med_pkt");
extern task body();
endclass
function med_pkt::new(string name="med_pkt");
super.new(name);
endfunction

task med_pkt::body();

if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
`uvm_fatal("GETTING","getting_failed")
//super.body();
req=src_xtn::type_id::create("req");

start_item(req);
assert(req.randomize() with {header[7:2]inside{[21:40]};header[1:0]==addr;});
finish_item(req);
endtask

//\/\/\/\/\/\/\/\/\/\/\/BIG_PACKET/\/\/\/\/\/\/\/\/\/

class big_pkt extends src_seqs;
`uvm_object_utils(big_pkt);

bit [1:0]addr;

extern function new(string name="big_pkt");
extern task body();
endclass
function big_pkt::new(string name="big_pkt");
super.new(name);
endfunction

task big_pkt::body();

if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
`uvm_fatal("GETTING","getting_failed")
//super.body();
req=src_xtn::type_id::create("req");

start_item(req);
assert(req.randomize() with {header[7:2]inside{[41:63]};header[1:0]==addr;});
finish_item(req);
endtask


//\/\/\/\/\/\/\/\/\/\/\/ERROR_PACKET/\/\/\/\/\/\/\/\/\/

class err_pkt extends src_seqs;
`uvm_object_utils(err_pkt);
bit [1:0]addr;

extern function new(string name="err_pkt");
extern task body();
endclass
function err_pkt::new(string name="err_pkt");
super.new(name);
endfunction

task err_pkt::body();

if(!uvm_config_db #(bit[1:0])::get(null,get_full_name(),"addr",addr))
`uvm_fatal("GETTING","getting_failed")
//super.body();
req=src_xtn::type_id::create("req");
start_item(req);
assert(req.randomize() with {header[7:2]inside{[21:40]};header[1:0]==addr;});
req.parity=8'b11111110;
finish_item(req);
endtask






