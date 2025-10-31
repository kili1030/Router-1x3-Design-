module top(clk,rst,din,rd_en0,rd_en1,rd_en2,pkt_vld,vld_out0,vld_out1,vld_out2,dout0,dout1,dout2,busy,err);
input clk,rst,rd_en0,rd_en1,rd_en2,pkt_vld;
input [7:0] din;
output vld_out0,vld_out1,vld_out2,busy,err;
output [7:0]dout0,dout1,dout2;
wire [2:0]write_enb;
wire [7:0]dout;
wire empty0,empty1,empty2,full0,full1,full2,sft_rst0,sft_rst1,sft_rst2,lfd_state,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,low_pkt_vld,parity_done,fifo_full;
rfsm FSM(clk,rst,parity_done,pkt_vld,sft_rst0,sft_rst1,sft_rst2,fifo_full,low_pkt_vld,empty0,empty1,empty2,din[1:0],busy,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state);
rsynch SYN(detect_add,din[1:0],write_enb_reg,clk,rst,rd_en0,rd_en1,rd_en2,empty0,empty1,empty2,full0,full1,full2,sft_rst0,sft_rst1,sft_rst2,vld_out0,vld_out1,vld_out2,fifo_full,write_enb);
router_reg REG(clk,rst,pkt_vld,din,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,parity_done,low_pkt_vld,err,dout);

router_fifo FIFO_0(clk,rst,rd_en0,write_enb[0],dout,dout0,full0,empty0,sft_rst0,lfd_state);
router_fifo FIFO_1(clk,rst,rd_en1,write_enb[1],dout,dout1,full1,empty1,sft_rst1,lfd_state);
router_fifo FIFO_2(clk,rst,rd_en2,write_enb[2],dout,dout2,full2,empty2,sft_rst2,lfd_state);
//rfsm FSM(clk,rst,parity_done,pkt_vld,sft_rst0,sft_rst1,sft_rst2,fifo_full,low_pkt_vld,empty0,empty1,empty2,din[1:0],busy,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state);
//rsynch SYN(detect_add,din[1:0],wrt_enb_reg,clk,rst,rd_en0,rd_en1,rd_en2,empty0,empty1,empty2,full0,full1,full2,sft_rst0,sft_rst1,sft_rst2,vld_out0,vld_out1,vld_out2,fifo_full,write_enb);
//router_reg REG(clk,rst,pkt_vld,din,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,parity_done,low_pkt_vld,err,dout);
endmodule





/*module top(input clk,rst,re_0,re_1,re_2,pkt_vld,input [7:0]din, output [7:0]dout_0,dout_1,dout_2 ,output vld_out_0,vld_out_1,vld_out_2,err,busy);

wire [7:0]dout;
wire sfrst_0,full_0,empty_0,sfrst_1,full_1,empty_1,sfrst_2,full_2,empty_2,detect_add,fifo_full,ld_state_laf_state,parity_done,low_pkt_vld,lfd_state,rst_int_reg,full_state,we_reg;
wire [2:0]we;

router_fifo FIFO_0(clk,rst,we[0],re_0,sfrst_0,lfd_state,dout,empty_0,full_0,dout_0);
router_fifo FIFO_1(clk,rst,we[1],re_1,sfrst_1,lfd_state,dout,empty_1,full_1,dout_1);
router_fifo FIFO_2(clk,rst,we[2],re_2,sfrst_2,lfd_state,dout,empty_2,full_2,dout_2);

router_syn SYN(clk,rst,detect_add,we_reg,empty_0,empty_1,empty_2,re_0,re_1,re_2,full_0,full_1,full_2,din[1:0],sfrst_0,sfrst_1,sfrst_2,vld_out_0,vld_out_1,vld_out_2,fifo_full,we);

router_fsm FSM(clk,rst,pkt_vld,parity_done,fifo_full,low_pkt_vld,din[1:0],sfrst_0,sfrst_1,sfrst_2,empty_0,empty_1,empty_2,detect_add,ld_state,laf_state,lfd_state,we_reg,full_state,rst_int_reg,busy);

router_reg REG(clk,rst,pkt_vld,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,din, parity_done,low_pkt_vld,err,dout);
endmodule*/



