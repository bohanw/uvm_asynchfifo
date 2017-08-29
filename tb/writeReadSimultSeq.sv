class writeReadSimultSeq extends uvm_sequence #(sequence_item);
	`uvm_object_utils(writeReadSimultSeq)

	sequence_item command;

	int fifo_depth;		

	function new (string name="writeReadSimultSeq");
		super.new(name);
		if(!uvm_config_db#(int)::get(null, "*", "DEPTH",fifo_depth ))
			`uvm_error("writeReadSimultSeq","FAIL TO GET DEPTH");
	endfunction

	task body();
		command = sequence_item::type_id::create("command");
		start_item(command);
		command.op = RESET;
		command.winc = 0;
		command.rinc = 0;
		finish_item(command);
		repeat (17) begin
			start_item(command);
			command.op = WRITEREAD;
			void' (command.randomize());
			command.winc = 1;
			command.rinc = 1;
			finish_item(command);
		end
		start_item(command);
		command.winc = 0;
		command.rinc = 0;
		finish_item(command);
	endtask : body
endclass