module fifo #(parameter DATASIZE = 8, parameter ADDRSIZE = 4)
	(input rinc, rclk, rrst_n,
	input winc,wclk,wrst_n,
	input [DATASIZE-1:0] wdata,
	output logic [DATASIZE-1:0] rdata,
	output logic wfull, rempty);

	//internal wires

	logic [ADDRSIZE-1:0] waddr, raddr;
	logic [ADDRSIZE:0] wptr, rptr,wq2_rptr,rq2_wptr;

	logic wclken;
	assign wclken = winc & ~wfull;
	sync_r2w #(.DATASIZE(DATASIZE),.ADDRSIZE(ADDRSIZE))ssync_r2w(.wclk    (wclk),
						.wrst_n  (wrst_n),
						.rptr    (rptr),
						.wq2_rptr(wq2_rptr));

	sync_w2r #(.ADDRSIZE(ADDRSIZE))sync_w2r(.rclk    (rclk),
					.rrst_n  (rrst_n),
					.wptr    (wptr),
					.rq2_wptr(rq2_wptr));

	wptr_full #(.ADDRSIZE(ADDRSIZE))wptr_full(.winc    (winc),
		.wclk    (wclk),
		.wrst_n  (wrst_n),
		.wq2_rptr(wq2_rptr),
		.wptr    (wptr),
		.waddr   (waddr),
		.wfull   (wfull));

	rptr_empty #(.ADDRSIZE(ADDRSIZE))rptr_empty(.rrst_n  (rrst_n),
		.rclk    (rclk),
		.rinc    (rinc),
		.rq2_wptr(rq2_wptr),
		.raddr   (raddr),
		.rptr    (rptr),.rempty  (rempty));

	fifomem #(.DATASIZE(DATASIZE))fifomem(.rdata (rdata),
		.wdata (wdata),
		.waddr (waddr),
		.raddr (raddr),
		.wclken(wclken),
		.wfull (wfull),
		.wclk  (wclk));

	
	
endmodule
