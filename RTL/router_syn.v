
/*module router_syn(input clk,rst,detect_add,we_reg,                                                                                
	input empty_0,empty_1,empty_2,re_0,re_1,re_2,full_0,full_1,full_2, input [1:0]din, output reg sfrst_0,sfrst_1,sfrst_2, output vld_out_0,vld_out_1,vld_out_2, output reg fifo_full, output reg [2:0]we);

reg [1:0]fifo_add;
reg [4:0]count_0_sfrst,count_1_sfrst,count_2_sfrst;

//capturing address
always@(posedge clk)
begin
	if(!rst)
		fifo_add<=1'b0;
	else if(detect_add)
		fifo_add<=din;
end

//enable logic
always@(*)
begin
	if(we_reg)
	begin
		case(fifo_add)
			2'b00:we=3'b001;
			2'b01:we=3'b010;
			2'b10:we=3'b100;
			2'b11:we=3'b000;
		endcase
	end
	else
		we=3'b00;
end

assign vld_out_0=!empty_0;
assign vld_out_1=!empty_1;
assign vld_out_2=!empty_2;


//fifo full logic
always@(*)
begin
	case(fifo_add)
		2'b00:fifo_full=full_0;
		2'b01:fifo_full=full_1;
      2'b10:fifo_full=full_2;
		2'b11:fifo_full=1'b0;
	endcase 
end

//soft reset logic
always@(posedge clk)
begin
	if (!rst)
	begin
		sfrst_0<=1'b0;
		count_0_sfrst<=5'b1;
	end
	else if(!vld_out_0) 
	begin
		sfrst_0<=5'b0;
	        count_0_sfrst<=5'b1;
	end
	else if(re_0)
	begin
		sfrst_0<=5'b0;
		count_0_sfrst<=5'b1;
	end
	else if (count_0_sfrst<=5'd29)
	begin
		sfrst_0<=1'b1;
		count_0_sfrst<=5'b1;
	end
	else
	begin
		sfrst_0<=1'b0;
		count_0_sfrst<=count_0_sfrst+5'h1;
	end
end

always@(posedge clk)
begin
	if (!rst)
	begin
		sfrst_1<=1'b0;
		count_1_sfrst<=5'b1;
	end
	else if(!vld_out_1) 
	begin
		sfrst_1<=5'b0;
	        count_1_sfrst<=5'b1;
	end
	else if(re_1)
	begin
		sfrst_1<=5'b0;
		count_1_sfrst<=5'b1;
	end
	else if (count_1_sfrst<=5'd29)
	begin
		sfrst_1<=1'b1;
		count_1_sfrst<=5'b1;
	end
	else
	begin
		sfrst_1<=1'b0;
		count_1_sfrst<=count_1_sfrst+5'h1;
	end
end		

always@(posedge clk)
begin
	if (!rst)
	begin
		sfrst_2<=1'b0;
		count_2_sfrst<=5'b1;
	end
	else if(!vld_out_2) 
	begin
		sfrst_2<=5'b0;
	        count_2_sfrst<=5'b1;
	end
	else if(re_2)
	begin
		sfrst_2<=5'b0;
		count_2_sfrst<=5'b1;
	end
	else if (count_2_sfrst<=5'd29)
	begin
		sfrst_2<=1'b1;
		count_2_sfrst<=5'b1;
	end
	else
	begin
		sfrst_2<=1'b0;
		count_2_sfrst<=count_2_sfrst+5'h1;
	end
end	
endmodule*/


module rsynch(detect_add,data_in,wrt_enb_reg,clk,rst,rd_en0,rd_en1,rd_en2,empty_0,empty_1,empty_2,full0,full1,full2,sft_rst0,sft_rst1,sft_rst2,vld_out0,vld_out1,vld_out2,fifo_full,wrt_enb);
input detect_add,wrt_enb_reg,clk,rst,rd_en0,rd_en1,rd_en2,empty_0,empty_1,empty_2,full0,full1,full2;
input [1:0] data_in;
output reg sft_rst0,sft_rst1,sft_rst2,fifo_full;
output vld_out0,vld_out1,vld_out2;
output reg [2:0]wrt_enb;
reg [1:0]fifo_add;
reg [4:0] count_sft_rst0,count_sft_rst1,count_sft_rst2;
wire w0,w1,w2;
always @(posedge clk)
begin
	if(!rst)
		fifo_add<=2'd0;
	else if(detect_add)
		fifo_add<=data_in;
end
always@(*)
begin
	if(wrt_enb_reg)
	begin
		case (fifo_add)
			2'b00:wrt_enb=3'b001;
			2'b01:wrt_enb=3'b010;
			2'b10:wrt_enb=3'b100;
			2'b11:wrt_enb=3'b000;
		endcase
	end
	else
		wrt_enb=3'b000;
end
always@(*)
begin
	case(fifo_add)
		2'b00:fifo_full=full0;
		2'b01:fifo_full=full1;
		2'b10:fifo_full=full2;
		2'b11:fifo_full=1'b0;
	endcase
end
assign vld_out0=!empty_0;
assign vld_out1=!empty_1;
assign vld_out2=!empty_2;



always @(posedge clk)
begin
	if(!rst)
	begin
	count_sft_rst0<=1;
	sft_rst0<=0;
        end
	else if(!vld_out0)
	begin
		count_sft_rst0<=1;
		sft_rst0<=0;
	end
	else if(rd_en0)
	begin
		count_sft_rst0<=1;
		sft_rst0<=0;
	end
        else if(w0)
	begin
		count_sft_rst0<=1;
		sft_rst0<=1;
	end
        else
	begin
		count_sft_rst0<=count_sft_rst0+1;
		sft_rst0<=0;
	end
end

always @(posedge clk)
begin
	if(!rst)
	begin
	count_sft_rst1<=1;
	sft_rst1<=0;
        end
	else if(!vld_out1)
	begin
		count_sft_rst1<=1;
		sft_rst1<=0;
	end
	else if(rd_en1)
	begin
		count_sft_rst1<=1;
		sft_rst1<=0;
	end
        else if(w1)
	begin
		count_sft_rst1<=1;
		sft_rst1<=1;
	end
        else
	begin
		count_sft_rst1<=count_sft_rst1+1;
		sft_rst1<=0;
	end
end

always @(posedge clk)
begin
	if(!rst)
	begin
	count_sft_rst2<=1;
	sft_rst2<=0;
        end
	else if(!vld_out2)
	begin
		count_sft_rst2<=1;
		sft_rst2<=0;
	end
	else if(rd_en2)
	begin
		count_sft_rst2<=1;
	sft_rst2<=0;
	end
        else if(w2)
	begin
		count_sft_rst2<=5'b1;
		sft_rst2<=1'b1;
	end
        else
	begin
		count_sft_rst2<=count_sft_rst2+1;
		sft_rst2<=1'b0;
	end
end
assign w0=(count_sft_rst0==5'd30)? 1'b1:1'b0;
assign w1=(count_sft_rst1==5'd30)? 1'b1:1'b0;
assign w2=(count_sft_rst2==5'd30)? 1'b1:1'b0;
endmodule
	











		





