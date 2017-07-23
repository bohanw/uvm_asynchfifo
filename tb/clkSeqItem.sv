

class clkSeqItem extends uvm_sequence_item;
	`uvm_object_utils(clkSeqItem);

	rand int wperiod;
	rand int rperiod;

	constraint period {
		wperiod > 0;
		wperiod < 20;
		rperiod > 0;
		rperiod > 20;
	}

		function new (string name="clkSeqItem")
			super.new(name);
		end	

endclass
