module sync_w2r #(parameter ADDRSIZE = 4)(
	input rclk,rrst_n,
	input [ADDRSIZE:0] wptr,
	output logic [ADDRSIZE:0] rq2_wptr
);
	logic [ADDRSIZE:0] rq1_wptr;

	always_ff @(posedge rclk or negedge rrst_n) begin
		if(~rrst_n) begin
			rq2_wptr <= 0;
			rq1_wptr <= 0;
		end

		else begin
			rq2_wptr <= rq1_wptr;
			rq1_wptr <= wptr;
		end
	end

endmodule
