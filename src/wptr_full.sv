module wptr_full #(parameter ADDRSIZE = 4)
	(input winc, wclk, wrst_n,
	input [ADDRSIZE:0] wq2_rptr,
	output logic [ADDRSIZE:0] wptr,
	output logic [ADDRSIZE-1:0] waddr,
	output logic wfull);
	
	//graycode pointer

	logic [ADDRSIZE:0] wbin,wgraynext,wbinnext;
	logic wfull_val;
	always_ff @(posedge wclk or negedge wrst_n) begin
		if(!wrst_n) begin
			wbin <= #1 0;
			wptr <= #1 0;
		end

		else begin
			wbin <= #1 wbinnext;
			wptr <= #1 wgraynext;
		end

	end

	assign waddr = wbin[ADDRSIZE-1:0];
	assign wbinnext = wbin + (winc & ~wfull);

	bin2gray #(.SIZE(ADDRSIZE)) b0(.bin(wbinnext),.gray(wgraynext));

	//fifo write full condition

	assign wfull_val = (wgraynext[ADDRSIZE] != wq2_rptr[ADDRSIZE]) && 
						(wgraynext[ADDRSIZE-1] != wq2_rptr[ADDRSIZE-1]) &&
						(wgraynext[ADDRSIZE-2:0] == wq2_rptr[ADDRSIZE-2:0]);



	always_ff @(posedge wclk or negedge wrst_n) begin
		if(!wrst_n) begin
			wfull <= #1 0;
		end

		else begin
			wfull <= #1 wfull_val;
		end

	end
endmodule 
