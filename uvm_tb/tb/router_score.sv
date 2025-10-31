class router_score extends uvm_scoreboard;

`uvm_component_utils(router_score);

src_xtn src;
dst_xtn dst;
env_config e_cfg;
uvm_tlm_analysis_fifo #(src_xtn) src_fifo[];
uvm_tlm_analysis_fifo #(dst_xtn) dst_fifo[];
bit [1:0]addr;

covergroup src_cg;

ADDR: coverpoint src.header[1:0]{
	bins firstt={2'b00};
	bins second={2'b01};
	bins third={2'b10};}

PAYLOAD_SIZE: coverpoint src.header[7:2]{
	bins small_pkt={[1:20]};
	bins med_pkt={[21:40]};
	bins big_pkt={[41:63]};}

ERROR: coverpoint src.err{
	bins no_error={0};
	bins err={1};}

cross ADDR,PAYLOAD_SIZE,ERROR;
endgroup


/////////-----------covergroups----------///////////


covergroup dst_cg;

ADDR: coverpoint dst.header[1:0]{
	bins firstt={2'b00};
	bins second={2'b01};
	bins third={2'b10};}

PAYLOAD_SIZE: coverpoint dst.header[7:2]{
	bins small_pkt={[1:20]};
	bins med_pkt={[21:40]};
	bins big_pkt={[41:63]};}

cross ADDR,PAYLOAD_SIZE;


//cross ADDR,PAYLOAD_SIZE;
endgroup

extern function new(string name,uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
extern task comparing(src_xtn src,dst_xtn dst);
endclass

function router_score::new(string name,uvm_component parent);
super.new(name,parent);
src_cg=new();
dst_cg=new();
endfunction

function void router_score::build_phase(uvm_phase phase);

super.build_phase(phase);

if(!uvm_config_db #(env_config)::get(this,"","env_config",e_cfg))
`uvm_fatal("getting","getting_failed")
 

src_fifo=new[e_cfg.no_of_src_agt];
dst_fifo=new[e_cfg.no_of_dst_agt];

foreach(src_fifo[i])
	src_fifo[i]=new($sformatf("src_fifo[%0d]",i),this);
foreach(dst_fifo[i])
	dst_fifo[i]=new($sformatf("dst_fifo[%0d]",i),this);


endfunction


task router_score::run_phase(uvm_phase phase);
forever
begin
fork:A
begin:source
src_fifo[0].get(src);
//src.print;
`uvm_info("scoreboard",$sformatf("printing from source scoreboard \n %s", src.sprint()),UVM_LOW) 

src_cg.sample;
end

begin:dest
if(!uvm_config_db #(bit [1:0])::get(this,"","addr",addr))
`uvm_fatal("getting","getting_failed")

dst_fifo[addr].get(dst);
//dst.print;
`uvm_info("scoreboard",$sformatf("printing from dest scoreboard \n %s", dst.sprint()),UVM_LOW) 

dst_cg.sample;
end
join
comparing(src,dst);
#10;
end
endtask


task router_score::comparing(src_xtn src,dst_xtn dst);

if(src.header==dst.header)
$display("header_matching");
else
$display("header_not_matched");

if(src.payload==dst.payload)
$display("Payload_matching");
else 
$display("payload_mismatch");

if(src.parity==dst.parity )
$display("parity_matching");
else
$display("parity_not_matcehd");


endtask




















