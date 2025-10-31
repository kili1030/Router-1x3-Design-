module router_top;

  import uvm_pkg::*;

  
import router_pkg::*;

//`include "uvm_macros.svh"

bit clk;

always 

#5 clk=~clk;


router_if in(clk);
router_if in0(clk);
router_if in1(clk);
router_if in2(clk);

top DUV(.clk(clk), .pkt_vld(in.pkt_vld), .rst(in.rst), .err(in.err), .busy(in.busy), .din(in.din), .vld_out0(in0.vld_out), .vld_out1(in1.vld_out), .vld_out2(in2.vld_out), .rd_en0(in0.renb), .rd_en1(in1.renb), .rd_en2(in2.renb), .dout0(in0.dout), .dout1(in1.dout), .dout2(in2.dout));


initial 
begin
`ifdef VCS
         		$fsdbDumpvars(0,router_top);
        		`endif


uvm_config_db #(virtual router_if)::set(null,"*","in",in);
uvm_config_db #(virtual router_if)::set(null,"*","in0",in0);
uvm_config_db #(virtual router_if)::set(null,"*","in1",in1);
uvm_config_db #(virtual router_if)::set(null,"*","in2",in2);

run_test();
end 


//////////-------------assertions--------------////////////


property stable_data;
@(posedge clk) in.busy |=> $stable(in.din);
endproperty

property busy_check;
@(posedge clk) $rose(in.pkt_vld) |=> in.busy;
endproperty

property valid_signal;
@(posedge clk) $rose(in.pkt_vld) |-> ##3(in0.vld_out | in1.vld_out | in2.vld_out);
endproperty

property rd_enb0;
@(posedge clk) in0.vld_out |-> ##[1:29] in0.renb;
endproperty


property rd_enb1;
@(posedge clk) in1.vld_out |-> ##[1:29] in1.renb;
endproperty


property rd_enb2;
@(posedge clk) in2.vld_out |-> ##[1:29] in2.renb;
endproperty

property rd_enb0_low;
@(posedge clk) $fell(in0.vld_out) |=> ##1$fell(in0.renb);
endproperty

property rd_enb1_low;
@(posedge clk) $fell(in1.vld_out) |=> ##1$fell(in1.renb);
endproperty

property rd_enb2_low;
@(posedge clk) $fell(in2.vld_out) |=> ##1$fell(in2.renb);
endproperty


C1: assert property(stable_data)
	$display("Passed for stable_data");
	else 
	$display("Failed for stable_data");

C2: assert property(busy_check)
	$display("Passed for busy_check");
	else 
	$display("Failed for busy_check");

C3: assert property(valid_signal)
	$display("Passed for valid_signal");
	else
	$display("failed for valid_signal");

C4: assert property(rd_enb0)
	$display("Passed for rd_enb0");
	else
	$display("failed for rd_enb0");

C5: assert property(rd_enb1)
	$display("Passed for rd_enb1");
	else
	$display("failed for rd_enb1");

C6: assert property(rd_enb2)
	$display("Passed for rd_enb2");
	else
	$display("failed for rd_enb2");

C7: assert property(rd_enb0_low)
	$display("Passed for rd_enb0_low");
	else
	$display("failed for rd_enb0_low");

C8: assert property(rd_enb1_low)
	$display("Passed for rd_enb1_low");
	else
	$display("failed for rd_enb1_low");

C9: assert property(rd_enb2_low)
	$display("Passed for rd_enb2_low");
	else
	$display("failed for rd_enb2_low");


/////////-----------cover_property----------///////////


C10: cover property(stable_data);
C11: cover property(busy_check);
C12: cover property(valid_signal);

C13: cover property(rd_enb0);
C14: cover property(rd_enb1);
C15: cover property(rd_enb2);

C16: cover property(rd_enb0_low);
C17: cover property(rd_enb1_low);
C18: cover property(rd_enb2_low);



 
endmodule
