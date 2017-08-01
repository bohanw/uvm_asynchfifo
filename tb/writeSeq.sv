	`include "uvm_macros.svh"
	import uvm_pkg::*;
class writeSeq extends uvm_sequence #(sequence_item);
	`uvm_object_utils(writeSeq)

	rand int writeCount;
	sequence_item command;

	constraint writeCountCnstr {
		writeCount > 0;
		writeCount < 8;
	}; // How to pass the writeCount
												 //upperboundary as DATASIZE
												 //param

	function new (string name="");
		super.new(name);

	endfunction

	task body();
		command = sequence_item::type_id::create("command");
		$display("%t: ++++++++++++ writeDataSeq: Number of writes= %d",
		$time,writeCount);
		
		repeat(writeCount) begin
			start_item(command);
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
