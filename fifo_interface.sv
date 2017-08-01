interface fifo_interface #(parameter DATASIZE = 8);
	   import uvm_pkg::*;
	`include "uvm_macros.svh"

	logic winc,rinc,wclk,rclk,wrst_n,rrst_n;

	logic wfull,rempty;
	logic [DATASIZE-1:0] rdata, wdata;
	

	int wperiod = 4;
	int rperiod = 5;
	initial begin
		wclk = 0;
		forever begin
			#wperiod;
			wclk = ~wclk;
			
		end
		

	end

	initial begin
		rclk = 0;
		forever begin
			#rperiod;
			rclk = ~rclk;
			
		end
	

	end

endinterface
