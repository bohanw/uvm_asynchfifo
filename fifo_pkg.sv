package fifo_pkg;
	import uvm_pkg::*;

	parameter DATASIZE = 8;
	parameter ADDRSIZE = 4;

	int depth = 1<<ADDRSIZE;

	typedef enum {WRITE, READ,WRITEREAD,RESET} operation_t;

	typedef enum{WRST,RRST,WRRST} reset_t;

	typedef uvm_sequencer#(sequence_item) sequencer;	


endpackage
