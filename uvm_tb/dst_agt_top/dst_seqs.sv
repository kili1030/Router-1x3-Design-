class dst_seqs extends uvm_sequence #(dst_xtn);

`uvm_object_utils(dst_seqs)

extern function new(string name="dst_seqs");
endclass

function dst_seqs::new(string name="dst_seqs");
super.new(name);
endfunction

class normal_seq extends dst_seqs;
`uvm_object_utils(normal_seq)

extern function new (string name="normal_seq");
extern task body();
endclass

function normal_seq::new(string name="normal_seq");
super.new(name);
endfunction

task normal_seq::body();
req=dst_xtn::type_id::create("req");
start_item(req);
assert(req.randomize() with {delay < 30 ;});
finish_item(req);
endtask

class soft_seq extends dst_seqs;
`uvm_object_utils(soft_seq);


extern function new (string name="soft_seq");
extern task body();
endclass

function  soft_seq::new(string name="soft_seq");
super.new(name);
endfunction

task soft_seq::body();
req=dst_xtn::type_id::create("req");
start_item(req);
assert(req.randomize() with {delay >30 ;});
finish_item(req);
endtask



