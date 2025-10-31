/*module router_fifo(input clk,rst,we,re,sfrst,lfd_state, input [7:0]din, output empty,full, output reg [7:0]dout);
reg [8:0]mem[15:0];
reg lfd_state_s;
reg [4:0]r_pntr,w_pntr;
reg [7:0]count;
integer i,j;

always@(posedge clk) //delaying lfd by one clk cycle
begin
	if(!rst)
		lfd_state_s<=0;
	else
		lfd_state_s<=lfd_state;
end

always@(posedge clk) //downcounting logic
begin
	if(!rst)
		count<=7'h0;
	else if(sfrst)
		count<=7'h0;
	else if(re && ~empty)
	begin
		if(mem[r_pntr[3:0]][8] == 1'b1)
			count<=mem[r_pntr[3:0]][7:2] + 1'b1;
		else if(count !=0)
			count<=count-1'b1;
	end
end

always@(posedge clk) //read logic
begin
	if(!rst)
	begin
		dout<=8'h0;
//		r_pntr<=5'h0;
		end
	else if (sfrst)
	begin
		dout<=8'h0;
//		r_pntr<=5'h0;
		end
	else if(re && ~empty)
	begin
		dout<=mem[r_pntr[3:0]];
	//	r_pntr<=	r_pntr+1'b1;
		end
		else
		dout<=dout;

		//else if(count==0)
		//dout<=8'hz;
end

always@(posedge clk) //write logic
   begin
	if(!rst)
	begin
	for(j=0;j<16;j=j+1)
	mem[j]<=0;
//	w_pntr<=5'b0;
	end
	else if (sfrst)
	begin
	for(j=0;j<16;j=j+1)
	mem[j]<=0;
//	w_pntr<=5'b0;
	end
	else if(we && ~full)
	begin
	mem[w_pntr]<={lfd_state_s,din};
		end
end
	

always@(posedge clk) //pointer generation block
begin
	if(!rst)
	w_pntr<=5'b0;
	else if (sfrst)
	w_pntr<=5'b0;
	else if(we && ~full)
		w_pntr<=w_pntr+1'b1;
end

always@(posedge clk) // read address
begin
	if(!rst)
		r_pntr<=5'h0;
		else if (sfrst)
		r_pntr<=5'h0;
	else if(re && ~empty)
		r_pntr<=r_pntr+1'b1;
end 


assign full=(w_pntr==15 && r_pntr==0) ? 1'b1:1'b0;//({~r_pntr[4],r_pntr[3:0]})) ? 1'b1:1'b0;
assign empty=(r_pntr==w_pntr) ? 1'b1:1'b0;
endmodule*/


module router_fifo(clk,rst,rd_en,we,din,dout,full,empty,sft_rst,lfd_state);
input clk,rst,rd_en,we,sft_rst,lfd_state;
input [7:0]din;
output reg [7:0]dout;
output full,empty;
reg [8:0]mem[15:0];
reg [4:0]wrp,rdp;
reg [6:0]count;
reg lfd_state_t;

always@(posedge clk)
begin
	if(!rst)
		lfd_state_t<=0;
	else
		lfd_state_t<=lfd_state;
end

always@(posedge clk)
begin
	if(!rst)
		count<=7'h0;
	else if(sft_rst)
		count<=7'h0;
	else if(rd_en && !empty)
		begin
			if(mem[rdp[3:0]][8]==1)
				count<=mem[rdp[3:0]][7:2]+1'b1;
		else if(count!=0)
		count<=count-1'b1;
end
end
always@(posedge clk)
begin
	if(!rst)
		dout<=8'h0;
	else if(sft_rst)
		dout<=8'hz;
	//else if (count==0&&re)
		//dout<=8'hz;
	else if(rd_en&&!empty)
		dout<=mem[rdp[3:0]][7:0];
		else 
		dout<=8'hz;
end
always@(posedge clk)
begin
	if(!rst)
	
		mem[wrp[3:0]][8:0]<=9'h0;
	else if(sft_rst)
		mem[wrp[3:0]][8:0]<=9'h0;
	else if(we&&!full)
	begin
	if(lfd_state_t)
	begin
	mem[wrp[3:0]][8]<=1;
	mem[wrp[3:0]][7:0]<=din;
	end
	else
	begin
	mem[wrp[3:0]][8]<=0;
	mem[wrp[3:0]][7:0]<=din;
	end
	end
	
	
	
end
always@(posedge clk)
begin
	if(!rst)
		wrp<=5'h0;
	else if(sft_rst)
		wrp<=5'h0;
	else if(we &&!full)
		wrp<=wrp+1'b1;
end
always@(posedge clk)
begin
	if(!rst)
		rdp<=5'h0;
	else if(sft_rst)
		rdp<=5'h0;
	else if (rd_en && !empty)
		rdp<=rdp+1'b1;
end
assign full=((wrp=={~rdp[4],rdp[3:0]})&&(rdp==0))? 1'b1:1'b0;
assign empty =(wrp==rdp)||(sft_rst==1)? 1'b1:1'b0;
endmodule










