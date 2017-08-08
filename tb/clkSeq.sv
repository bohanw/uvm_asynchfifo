
	`include "uvm_macros.svh"
	import uvm_pkg::*;

class clkSeqItem extends uvm_sequence_item;
	`uvm_object_utils(clkSeqItem);

	int wperiod  = 8;
	int rperiod = 5 ;

	
	constraint period {
		wperiod > 0;
		wperiod < 10;
		rperiod > 0;
		rperiod > 10;
	}; 

		function new (string name="clkSeqItem");
			super.new(name);
		endfunction : new	

endclass


class clkSeq extends uvm_sequence #(clkSeqItem);
	`uvm_object_utils(clkSeq)

	function new (string name="clkSeq");
		super.new(name);
	endfunction

	task body;
		clkSeqItem req;
		req = clkSeqItem::type_id::create("clkSeq");

		start_item(req);
		void' (req.randomize());
		$display("wperiod %d rperiod %d",req.wperiod,req.rperiod);
		finish_item(req);

	endtask

endclass
