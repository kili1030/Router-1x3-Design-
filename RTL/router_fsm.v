module rfsm(clk,rst,parity_done,pkt_vld,sft_rst0,sft_rst1,sft_rst2,fifo_full,low_pkt_vld,fifo_empty0,fifo_empty1,fifo_empty2,din,busy,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state);
input clk,rst,parity_done,pkt_vld,sft_rst0,sft_rst1,sft_rst2,fifo_full,low_pkt_vld,fifo_empty0,fifo_empty1,fifo_empty2;
input [1:0]din;
output busy,detect_add,ld_state,laf_state,full_state,write_enb_reg,rst_int_reg,lfd_state;
parameter DECODE_ADDRESS = 3'b000,
	  WAIT_TILL_EMPTY=3'b001,
	  LOAD_FIRST_DATA = 3'b010,
	  LOAD_DATA = 3'b011,
	  LOAD_PARITY=3'b100,
	  FIFO_FULL_STATE=3'b101,
	  LOAD_AFTER_FULL=3'b110,
	  CHECK_PARITY_ERROR=3'b111;
reg [1:0] addr;
reg [2:0] state,next;

always @(posedge clk)
begin
	if(!rst)
		addr<=0;
	else
		addr<=din;
end
always@(posedge clk)
begin
	if(!rst)
		state<=DECODE_ADDRESS;
		else if(sft_rst0||sft_rst1||sft_rst2)
		state<=DECODE_ADDRESS;
	else
		state<=next;
end

always@(*)
begin
next=DECODE_ADDRESS;
	case(state)
		DECODE_ADDRESS:
		begin
			if((pkt_vld & din[1:0]==0 & fifo_empty0)|(pkt_vld & din[1:0]==1 & fifo_empty1)|(pkt_vld & din[1:0]==2 & fifo_empty2))
				next=LOAD_FIRST_DATA;
			else if((pkt_vld & din[1:0]==0 & fifo_empty0)|(pkt_vld & din[1:0]==1 & fifo_empty1)|(pkt_vld & din[1:0]==2 & fifo_empty2))
				next=WAIT_TILL_EMPTY;
			else
				next=DECODE_ADDRESS;
				end

		WAIT_TILL_EMPTY:
		begin
			if(fifo_empty0 &&(addr==2'd0)||fifo_empty1&&(addr==2'd1)||fifo_empty2&&(addr==2'd2))
				next=LOAD_FIRST_DATA;
			else
				next=WAIT_TILL_EMPTY;
				end
		LOAD_FIRST_DATA:
			next=LOAD_DATA;
		
		LOAD_DATA:
		begin
			if(!fifo_full && !pkt_vld)
				next=LOAD_PARITY;
			else if(fifo_full)
				next=FIFO_FULL_STATE;
			else
				next=LOAD_DATA;
				end
		LOAD_PARITY:
			next=CHECK_PARITY_ERROR;
		FIFO_FULL_STATE:
		begin
			if(fifo_full)
				next=FIFO_FULL_STATE;
			else 
				next=LOAD_AFTER_FULL;
				end
		LOAD_AFTER_FULL:
			begin
		   if(!parity_done && low_pkt_vld)
				next=LOAD_PARITY;
			else if(!parity_done && !low_pkt_vld)
				next=LOAD_DATA;
	   		else if(parity_done)
				next=DECODE_ADDRESS;
				end
		CHECK_PARITY_ERROR:
		begin
			if(fifo_full)
				next=FIFO_FULL_STATE;
			else if(!fifo_full)
				next=DECODE_ADDRESS;
				end
				
				
	endcase
	
end
assign lfd_state=(state==LOAD_FIRST_DATA)? 1'b1:1'b0;
assign detect_add=(state==DECODE_ADDRESS)? 1'b1:1'b0;
assign ld_state=(state==LOAD_DATA)? 1'b1:1'b0;
assign full_state=(state==FIFO_FULL_STATE)? 1'b1:1'b0;
assign laf_state=(state==LOAD_AFTER_FULL)? 1'b1:1'b0;
assign write_enb_reg=((state==LOAD_DATA)||(state==LOAD_PARITY)||(state==LOAD_AFTER_FULL))? 1'b1:1'b0;
assign rst_int_reg=(state==CHECK_PARITY_ERROR)? 1'b1:1'b0;
assign busy=((state==DECODE_ADDRESS)||(state==LOAD_DATA))? 1'b0:1'b1;
endmodule




/*module router_fsm(input clk,rst,pkt_vld,parity_done,fifo_full,low_pkt_vld, input [1:0]din, input sfrst_0,sfrst_1,sfrst_2,empty_0,empty_1,empty_2, output detect_add,ld_state,laf_state,lfd_state,we_reg,full_state,rst_int_reg,busy);
 
parameter DECODE_ADD=3'b000,
	LFD=3'b001,
	WAIT_TILL_EMPTY=3'b010,
	LDA=3'b011,
	FIFO_FULL_STATE=3'b100,
	LOAD_PARITY=3'b101,
	LOAD_AFTER_FULL=3'b110,
	CHECK_PARITY_ERROR=3'b111;
//reg [1:0]addr;
reg [2:0]present,next;

//always@(posedge clk)
//begin
//if(!rst)
//addr=2'b0;
//else if (detect_add)
//addr=din;
//end

//presesnt state logic
always@(posedge clk)
begin
	if(!rst)
		present<=DECODE_ADD;
 else if((din ==2'b00 && sfrst_0)||(din ==2'b01 && sfrst_1)||(din ==2'b10 && sfrst_2))

		present<=DECODE_ADD;
	else
		present<=next;
end

always@(*)
begin
	case(present)
		DECODE_ADD: if((pkt_vld && (din[1:0]==0) && empty_0)||
				(pkt_vld && (din[1:0]==1) && empty_1)||
				(pkt_vld && (din[1:0]==2) && empty_2))
				
				next=LFD;
				
				else if((pkt_vld && (din[1:0]==0) && !empty_0)||
				(pkt_vld && (din[1:0]==1) && !empty_1)||
				(pkt_vld && (din[1:0]==2) && !empty_2))

				next=WAIT_TILL_EMPTY;

				else
					next=DECODE_ADD;
WAIT_TILL_EMPTY: if((empty_0 && (din[1:0]==0)) || (empty_1 && (din[1:0]==1)) || (empty_2 && (din[1:0]==2)))
					next=LFD;
				else
					next=WAIT_TILL_EMPTY;

		LFD:next=LDA;


		LDA: if(fifo_full)
			next=FIFO_FULL_STATE;
			else if(!fifo_full && !pkt_vld)
				next=LOAD_PARITY;
			else
				next=LDA;
			 
		FIFO_FULL_STATE: if(!fifo_full)
	       				next=LOAD_AFTER_FULL;
			else 
				next=FIFO_FULL_STATE;

 		LOAD_PARITY: next=CHECK_PARITY_ERROR;

		LOAD_AFTER_FULL: if(!parity_done && low_pkt_vld)
					next=LOAD_PARITY;
			else if(!parity_done && !low_pkt_vld)
			next=LDA;
			else if(parity_done)
			next=DECODE_ADD;

		CHECK_PARITY_ERROR: if(!fifo_full)
					next=DECODE_ADD;
				else 
					next=FIFO_FULL_STATE;
					
				


			endcase
		end

assign detect_add=(present==DECODE_ADD); //? 1'b1:1'b0;
assign ld_state= (present==LDA); //? 1'b1:1'b0;
assign laf_state= (present==LOAD_AFTER_FULL);// ? 1'b1:1'b0;
assign full_state= (present==FIFO_FULL_STATE);// ? 1'b1:1'b0;
assign we_reg= (present==LDA || present==LOAD_PARITY || present==LOAD_AFTER_FULL);//? 1'b1:1'b0;
//assign busy= (present==LFD) || (present==LOAD_PARITY) || (present==FIFO_FULL_STATE) || (present==LOAD_AFTER_FULL) || (present==WAIT_TILL_EMPTY) || (present==CHECK_PARITY_ERROR);// ? 1'b1:1'b0;
assign rst_int_reg= (present==CHECK_PARITY_ERROR);// ? 1'b1:1'b0;
assign lfd_state= (present==LFD);// ? 1'b1:1'b0;
assign busy =(present==DECODE_ADD)||(present==LDA)? 1'b0:1'b1;


endmodule*/



				


