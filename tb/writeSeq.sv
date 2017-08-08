
class writeSeq extends uvm_sequence #(sequence_item);
	`uvm_object_utils(writeSeq)

	rand int writeCount;
	sequence_item command;

	constraint writeCountCnstr {
		writeCount > 1;
		writeCount < 8;
	}; // How to pass the writeCount
												 //upperboundary as DATASIZE
												 //param

	function new (string name="");
		super.new(name);

	endfunction

	task body();
		command = sequence_item::type_id::create("command");
		//$display("%t: ++++++++++++ writeDataSeq: Number of writes= %d",
		//$time,writeCount);
		`uvm_info("WRITESEQ",$sformatf("%t, write sequence : Number of writes = %d",$time, writeCount),UVM_MEDIUM);
		start_item(command);
		command.op = RESET;
		finish_item(command);
		repeat(10) begin
			start_item(command);
			void' (command.randomize());
			command.op = WRITE;
			command.winc = 1;
			finish_item(command);

		end
		$display("Last Data");
		start_item(command);
		command.winc = 0;
		finish_item(command);
	endtask


endclass
