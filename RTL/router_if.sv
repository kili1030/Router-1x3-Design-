interface router_if(input bit clk);
logic pkt_vld,err,busy,vld_out,renb,rst;
logic [7:0]din;
logic [7:0]dout;

clocking src_drv_cb @(posedge clk);
default input #1 output #1;
output pkt_vld,din,rst;
input busy,err;
endclocking

clocking src_mon_cb @(posedge clk);
default input #1 output #1;
input pkt_vld,err,busy,din,rst;
endclocking

clocking dst_drv_cb @(posedge clk);
default input #1 output #1;
input vld_out;
output renb;
endclocking

clocking dst_mon_cb @(posedge clk);
default input #1 output #1;
input dout,renb;
endclocking

modport SRC_DRV_MP(import src_drv_cb);
modport SRC_MON_MP(import src_mon_cb);
modport DST_DRV_MP(import dst_drv_cb);
modport DST_MON_MP(import dst_mon_cb);

endinterface

