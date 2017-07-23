module rptr_empty # ( parameter ADDRSIZE = 4 )
	(input rrst_n, rclk,
	input rinc,
	input [ADDRSIZE:0] rq2_wptr,
	output logic [ADDRSIZE-1:0] raddr,
	output logic [ADDRSIZE:0] rptr,
	output logic rempty);

	logic  [ADDRSIZE:0] rbin, rgraynext,rbinnext;

	logic rempty_val;
	always_ff @(posedge rclk or negedge rrst_n) begin
		if(!rrst_n) begin
			rbin <= #1 0;
			rptr <= #1 0;
		end
		else begin
			rbin <= #1 rbinnext;
			rptr <= #1 rgraynext;
		end

	end
    
	assign rbinnext = rbin + (rinc & ~rempty);
	assign raddr = rbin[ADDRSIZE-1:0];
	bin2gray #(.SIZE(ADDRSIZE)) b0(.bin(rbinnext),.gray(rgraynext));
	
	//FIFO empty condition
	assign rempty_val = (rgraynext == rq2_wptr);

	always_ff @(posedge rclk or negedge rrst_n) begin
		if(!rrst_n) rempty <= #1 0;
		else		rempty <= #1 rempty_val;
	end

endmodule

module bin2gray #(parameter SIZE = 4)
	(input [SIZE:0] bin,
	output logic [SIZE:0] gray);
	
	assign gray[SIZE:0] = bin[SIZE:0] ^ {1'b0,bin[SIZE:1]};

endmodule
