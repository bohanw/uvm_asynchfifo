module top();
	import uvm_pkg::*;
	`include "uvm_macros.svh";
	import fifo_pkg::*;


	

	fifo_interface itf();

	fifo dut(.rinc  (itf.rinc),
			.winc  (itf.winc),
			.rclk  (itf.rclk),.rrst_n(itf.rrst_n),
			.wclk  (itf.wclk),.wrst_n(itf.wrst_n),
			.wdata (itf.wdata),.rdata (itf.rdata),
			.wfull (itf.wfull),.rempty(itf.rempty));

	initial begin
		uvm_config_db#(virtual fifo_interface)::set(null, "*", "itf", itf);
		uvm_config_db#(int)::set(null, "*", "DEPTH",fifo_pkg::DEPTH);
		//run_test("");
		run_test();
	end



endmodule // top