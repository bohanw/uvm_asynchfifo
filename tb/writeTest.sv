	`include "uvm_macros.svh"
	import uvm_pkg::*;
class writeTest extends uvm_test;
	`uvm_component_utils(writeTest)

	env env_h;

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase (uvm_phase phase);
		env_h = env::type_id::create("env_h", this);
	endfunction

	task run_phase(uvm_phase phase);
		clkSeq clkSeq_h;
		writeSeq writeSeq_h;

		phase.raise_objection(this);

		clkSeq_h = clkSeq::type_id::create("clkSeq_h",this);
		writeSeq_h = writeSeq::type_id::create("writeSeq_h",this);

		clkSeq_h.start(this.env_h.agent_h.sequencer_h);
		writeSeq_h.start(this.env_h.agent_h.sequencer_h);
		//clkSeq.start(this.env_inst.agent_inst.sequencer_inst);
		phase.drop_objection(this);
	endtask : run_phase
endclass
