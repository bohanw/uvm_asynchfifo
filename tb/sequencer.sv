	`include "uvm_macros.svh"
	import uvm_pkg::*;
	
class sequencer extends uvm_sequencer #(uvm_sequence_item);
	`uvm_component_utils(sequencer)

	function new (string name="", uvm_component parent);
		super.new(name, parent);
	endfunction

endclass
