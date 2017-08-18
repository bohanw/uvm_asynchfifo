
class writeSeq extends uvm_sequence #(sequence_item);
	`uvm_object_utils(writeSeq)


	sequence_item command;
											 //upperboundary as DATASIZE
		int fifo_depth;											 //param

	rand int wrCnt;
	constraint numWr
	 	{
	 	wrCnt <  15;
	 };
	int writeCount;

	function new (string name="writeSeq");
		super.new(name);
		this.writeCount =0;
		if(!uvm_config_db#(int)::get(null, "*", "DEPTH",fifo_depth ))
			`uvm_error("writeseq","FAIL TO GET DEPTH");
	endfunction

	task body();
		command = sequence_item::type_id::create("command");
		//$display("%t: ++++++++++++ writeDataSeq: Number of writes= %d",
		//$time,writeCount);
		writeCount = 10;
		`uvm_info("WRITESEQ",$sformatf("%t, write sequence : Number of writes = %d",$time, writeCount),UVM_MEDIUM);
		start_item(command);
		command.op = RESET;

		finish_item(command);
		repeat (writeCount) begin
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
