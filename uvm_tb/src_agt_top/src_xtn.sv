class src_xtn extends uvm_sequence_item;
`uvm_object_utils(src_xtn)

rand bit [7:0]header;
rand bit [7:0]payload[];
bit [7:0] parity;
bit err,busy,pkt_vld;


constraint c1{header[1:0]!=2'b11;}
constraint c2{payload.size==header[7:2];}
constraint c3{header[7:2] inside {[1:63]};}




extern function new(string name="src_xtn");
extern function void do_print(uvm_printer printer);
extern function void post_randomize();

endclass

function src_xtn::new(string name="src_xtn");
super.new(name);
endfunction

function void src_xtn::do_print(uvm_printer printer);
super.do_print(printer);
printer.print_field("header",this.header,8,UVM_DEC);
foreach(payload[i])
begin
printer.print_field($sformatf("payload[%0d]",i),this.payload[i],8,UVM_DEC);
end
printer.print_field("parity",this.parity,1,UVM_DEC);
printer.print_field("pkt_vld",this.pkt_vld,1,UVM_DEC);
printer.print_field("err",this.err,1,UVM_DEC);
printer.print_field("busy",this.busy,1,UVM_DEC);
endfunction

function void src_xtn::post_randomize();
parity=header;
foreach(payload[i])
parity=parity^payload[i];
//parity=8'd21;
endfunction


