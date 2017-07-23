module sync_r2w #(parameter DATASIZE = 8,ADDRSIZE = 4)(
	input wclk,wrst_n,
	input [ADDRSIZE:0] rptr,
	output logic [ADDRSIZE:0] wq2_rptr
	);

	logic [ADDRSIZE:0] wq1_rptr;

	always_ff@(posedge wclk or negedge wrst_n) begin
		if(~wrst_n) begin
			wq1_rptr <= 0;
			wq2_rptr <= 0;
		end
		else begin
			wq1_rptr <= rptr;
			wq2_rptr <= wq1_rptr;
		end
	end
endmodule
