module tb;
	logic rinc, rclk, rrst_n,winc,wclk,wrst_n,wfull,rempty;

	parameter DATASIZE = 8;
	parameter ADDRSIZE = 4;

	logic [DATASIZE-1:0] rdata,wdata;


	
	fifo dut (.rinc(rinc),.rclk(rclk),.rrst_n(rrst_n),
			.winc(winc),.wclk(wclk),.wrst_n(wrst_n),
			.wdata(wdata),.rdata(rdata),.wfull(wfull),.rempty(rempty));
	

	//internal logic
	logic [ADDRSIZE-1:0] waddr,raddr;
	assign waddr = dut.waddr;
	assign raddr = dut.raddr;

	

	always begin
		#8 wclk = ~wclk;
		#5 rclk = ~rclk;
	end
	
	
	initial begin
		wclk = 1;
		rclk = 1;
		wrst_n = 0;
		rrst_n = 0;
		winc = 0;
		rinc = 0;
		wdata = '0;
		@(negedge wclk);
		wrst_n = 1;
		rrst_n = 1;
		repeat(5) begin
			@(negedge wclk);
			winc = 1;
			wdata = $random;
			@(negedge rclk);
			rinc = 1;

			
		end
		#100;
		$finish;
	end

	
	initial begin
		forever @(posedge rclk) begin
			$display("wdata : %h waddr: %h raddr %h rdata %h",wdata,waddr,raddr,rdata);
		end
	end

endmodule
