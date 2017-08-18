package fifo_pkg;
	`include "uvm_macros.svh"
	import uvm_pkg::*;

	parameter DATASIZE = 8;
	parameter ADDRSIZE = 4;

	int DEPTH = 1<<ADDRSIZE;

	typedef enum {WRITE, READ,WRITEREAD,RESET} operation_t;

	typedef enum{WRST,RRST,WRRST} reset_t;

	//typedef uvm_sequencer#(sequence_item) sequencer;	


	`include "sequence_item.sv"
//	`include "clkSeqItem.sv"
	`include "clkSeq.sv"
	`include "resetSeq.sv"
	`include "writeSeq.sv"
	`include "writeFullSeq.sv"
	`include "sequencer.sv"
	`include "driver.sv"
	`include "wr_monitor.sv"
	`include "rd_monitor.sv"

	`include "agent.sv"
	`include "scoreboard.sv"
	`include "env.sv"
	`include "writeTest.sv"
	`include "writeFullTest.sv"
endpackage
