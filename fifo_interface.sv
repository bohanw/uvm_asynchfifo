interface fifo_interface #(parameter DATASIZE = 8);
	logic winc,rinc,wclk,rclk,wrst_n,rrst_n;

	logic wfull,rempty;
	logic [DATASIZE-1:0] rdata, wdata;
	

	int wperiod = 4;
	int rperiod = 5;
	initial begin
		wclk = 0;
		fork
		forever begin
			#wperiod;
			wclk = ~wclk;
			
		end
		join_none

	end

	initial begin
		rclk = 0;
		fork
		forever begin
			#rperiod;
			rclk = ~rclk;
			
		end
		join_none

	end



endinterface
