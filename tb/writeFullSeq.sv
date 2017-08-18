class writeFullSeq extends uvm_sequence #(sequence_item);
	`uvm_object_utils(writeFullSeq)	

	sequence_item command;
	int fifo_depth;

	int totalWrites;
	function new (string name="writeFullSeq");
		super.new(name);
		this.totalWrites = 0;
		if(!uvm_config_db#(int)::get(null, "*", "DEPTH",fifo_depth ))
			`uvm_error("writeFullSeq","FAIL TO GET DEPTH");
	endfunction : new

	task body();
		int writeCount = 0;
		command = sequence_item::type_id::create("command");


		start_item(command);
		command.op = RESET;
		finish_item(command);
		this.totalWrites = fifo_depth+1;
		repeat(totalWrites) begin

			start_item(command);
			//void' (command.randomize());
			assert(command.randomize());
			command.op = WRITE;
			command.winc = 1;
			finish_item(command);
			writeCount++;
		end

	endtask : body
endclass