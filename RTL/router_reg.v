module router_reg(clk,rst,pkt_vld,din,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state,parity_done,low_pkt_vld,err,dout);
input clk,rst,pkt_vld,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state;
input [7:0]din;
output reg parity_done,low_pkt_vld,err;
output reg [7:0]dout;
reg [7:0] packet_parity,header,internal_parity,fifo_full_state;
always@(posedge clk)
begin
	if(!rst)
	
		dout<=0;
		
	
	else if(lfd_state)
	
		dout<=header;
	else if(pkt_vld&&ld_state&&!fifo_full)
		dout<=din;
	else if(ld_state&&fifo_full)
	begin
	  fifo_full_state<=din;
	    if(laf_state)
			dout<=fifo_full_state;
			end
		else if(~pkt_vld)
	dout<=din;
	else
		dout<=dout;
end
always@(posedge clk)
begin
	if(!rst)
		header<=0;
	else if(detect_add && pkt_vld&&din[1:0]!=2'b11)
		header<=din;
	else
		header<=header;
end
always@(posedge clk)
begin
	if(!rst)
		low_pkt_vld<=0;
	else if(rst_int_reg)
		low_pkt_vld<=0;
	else if(ld_state && !pkt_vld)
		low_pkt_vld<=1;
	else
		low_pkt_vld<=low_pkt_vld;
end
always@(posedge clk)
begin
	if(!rst)
		packet_parity<=8'd0;
	else if(detect_add)
		packet_parity<=8'd0;
	else if((ld_state&&!pkt_vld&&!fifo_full)||(laf_state&&!parity_done&&low_pkt_vld))
		packet_parity<=din;
		else
		packet_parity<=packet_parity;
end
always@(posedge clk)
begin
	if(!rst)
		internal_parity<=8'd0;
	else if(detect_add)
		internal_parity<=8'd0;
	else if(lfd_state&&pkt_vld)
		internal_parity<=internal_parity^header;
	else if(ld_state && pkt_vld&&!full_state)
		internal_parity<=internal_parity^din;
        else
	 internal_parity<=internal_parity;
 end

always@(posedge clk)
begin
	if(!rst)
		parity_done<=1'b0;
	else if(detect_add)
		parity_done<=1'b0;
	else if((ld_state&&!pkt_vld&&!fifo_full)||(laf_state&&!parity_done&&low_pkt_vld))
		parity_done<=1'b1;
		else
		parity_done<=parity_done;
end
always@(posedge clk)
begin
	if(!rst)
		err<=0;
	else if(parity_done)
	begin
		if(internal_parity==packet_parity)
			err<=1'b0;
		else
			err<=1'b1;
	end
	else
		err<=0;
end
endmodule





/*module router_reg(input clk,rst,pkt_vld,fifo_full,rst_int_reg,detect_add,ld_state,laf_state,full_state,lfd_state, input [7:0]din, output reg parity_done,low_pkt_vld,err, output reg [7:0]dout);
reg [7:0]header_byte,fifo_full_state,int_parity,ext_parity;

always@(posedge clk) //dout logic
begin
	if(!rst)
	begin
		dout<=0;
		header_byte<=0;
		fifo_full_state<=0;
	end
		
	else if (lfd_state)
		dout<=header_byte;
	else if (ld_state && !fifo_full)
		dout<=din;
	else if (ld_state && fifo_full)
		fifo_full_state<=din;
	else if (laf_state)
		dout<=fifo_full_state;
	else if (detect_add && pkt_vld && din[1:0]!=2'b11)
		header_byte<=din;
end

always@(posedge clk) //low_pkt_vld logic
begin
	if(!rst)
		low_pkt_vld<=0;
	else if (rst_int_reg)
		low_pkt_vld<=0;
	else if (ld_state && !pkt_vld)
		low_pkt_vld<=1'b1;
end

always@(posedge clk)
begin
	if(!rst)
		parity_done<=0;
	else if(detect_add)
		parity_done<=0;
	else if((ld_state && !fifo_full && !pkt_vld) || (laf_state && low_pkt_vld && !parity_done))
		parity_done<=1'b1;
end

always@(posedge clk)
begin
	if(!rst)
		int_parity<=0;
	else if (detect_add)
		int_parity<=0;
	else if(lfd_state && pkt_vld)
		int_parity<=int_parity^header_byte;
	else if(ld_state && pkt_vld && !full_state)
		int_parity<=int_parity^din;
	else
		int_parity<=int_parity;
end

always@(posedge clk)
begin
	if(!rst)
		err<=0;
	else if(parity_done)
	begin
		if(int_parity==ext_parity)
			err<=0;
		else
			err<=1'b1;
	end
	else 
		err<=0;
end

always@(negedge clk)
begin
	if(!rst)
		ext_parity<=0;
	else if(detect_add)
		ext_parity<=0;
	else if((ld_state && !fifo_full && !pkt_vld) || (laf_state && !parity_done && low_pkt_vld))
	ext_parity<=din;
end
endmodule*/
		









