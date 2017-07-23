module top();
	import uvm_pkg::*;
	import fifo_pkg::*;


	`include "uvm_macros.svh";

	fifo_interface itf();

	fifo dut(.rinc  (itf.rinc),
			.winc  (itf.winc),
			.rclk  (itf.rclk),.rrst_n(itf.rrst_n),
			.wclk  (itf.wclk),.wrst_n(itf.wrst_n),
			.wdata (itf.wdata),.rdata (itf.rdata),
			.wfull (itf.wfull),.rempty(itf.rempty));

	initial begin
		uvm_config_db#()::set(null, "*", "itf", itf);
		//run_test("");
	end



endmodule // top