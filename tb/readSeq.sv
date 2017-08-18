class readSeq extends uvm_sequence #(sequence_item);
	`uvm_object_utils(readSeq)

	sequence_item command;
	int fifo_depth;
	int totalReads;
	function new (string name="writeFullSeq");
		super.new(name);
		if(!uvm_config_db#(int)::get(null, "*", "DEPTH",fifo_depth ))
			`uvm_error("readSeq","FAIL TO GET DEPTH");
	endfunction : new

	task body();
		command = sequence_item::type_id::create("command");

		start_item(command);
		command.op=RESET;
		finish_item(command);
		repeat(totalReads) begin
			if(command.rempty)
				break;
			start_item(command);
			command.op = READ;
			command.rinc = 1;
			finish_item(command);
		end
		start_item(command);
		command.rinc = 0;
		finish_item(command);

	endtask : body
endclass