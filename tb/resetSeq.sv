class resetSeq extends uvm_sequence #(sequence_item);
	`uvm_object_utils(resetSeq)

	sequence_item command;

	function new (string name="writeTillFullSeq");
		super.new(name);
	endfunction

	task body();
		command = sequence_item::type_id::create("resetSeq");

		start_item(command);
		command.op = RESET;
		
		finish_item(command);

	endtask : body
endclass