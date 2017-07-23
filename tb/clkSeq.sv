class clkSeq extends uvm_sequence #(clkSeqItem);
	`uvm_object_utils(clkSeq)

	clkSeqItem req;
	function new (string name="clkSeq");

		super.new(name);

	endfunction

	task body;
		req = clkSeqItem::type_id::create("clkSeq");

		start_item(req);
		req.randomize();
		$display("wperiod %d rperiod %d",req.wperiod,req.rperiod);
		finish_item(req);

	endtask

endclass
