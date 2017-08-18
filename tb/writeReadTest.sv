class writeReadTest extends uvm_test;
	`uvm_component_utils(writeReadTest)

	env env_h;

	function new (string name, uvm_component parent);
		super.new(name, parent);
	endfunction : new

	function void build_phase (uvm_phase phase);
		env_h = env::type_id::create("env_h", this);
	endfunction

	task run_phase(uvm_phase phase);
		clkSeq clk;
		writeSeq wr;
		readSeq rd;
		phase.raise_objection(this);
		clk = clkSeq::type_id::create("clk",this);
		wr = writeSeq::type_id::create("wr");
		rd = readSeq::type_id::create("rd");

		repeat (3) begin
			clk.start(this.env_h.agent_h.sequencer_h);
			wr.constraint_mode(0);
			wr.writeCount = 10;
			wr.start(this.env_h.agent_h.sequencer_h);
			rd.constraint_mode(0);
			rd.totalReads = wr.writeCount;
			rd.start(this.env_h.agent_h.sequencer_h);
		end

		phase.drop_objection(this);

	endtask : run_phase

endclass