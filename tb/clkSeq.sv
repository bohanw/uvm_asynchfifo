
	`include "uvm_macros.svh"
	import uvm_pkg::*;

class clkSeqItem extends uvm_sequence_item;
	`uvm_object_utils(clkSeqItem);

	rand int wperiod;
	rand int rperiod;
	
	constraint period {
		wperiod dist {
			4:=1,
			6:=1,
			8:=1
		};
		rperiod dist {
			4:=1,
			6:=1,
			8:=1

		};
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
