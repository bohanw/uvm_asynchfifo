class writeReadSimultTest extends uvm_test;
	`uvm_component_utils(writeReadSimultTest)
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


		repeat(1) begin
			clk.start(this.env_h.agent_h.sequencer_h);
			wr.writeCount=8;
			rd.totalReads = 8;
			rd.constraint_mode(0);
			fork
				wr.start(this.env_h.agent_h.sequencer_h);
				rd.start(this.env_h.agent_h.sequencer_h);
			join

		end
		phase.drop_objection(this);
	endtask : run_phase
	
	/*
	task run_phase(uvm_phase phase);
		clkSeq clk;
		writeReadSimultSeq wr_rd;
		phase.raise_objection(this);
		clk = clkSeq::type_id::create("clk",this);
		wr_rd = writeReadSimultSeq::type_id::create("wr-rd");
		repeat(1)	 begin
			clk.start(this.env_h.agent_h.sequencer_h);
			wr_rd.start(this.env_h.agent_h.sequencer_h);
		end
		phase.drop_objection(this);

	endtask : run_phase
	*/
endclass : writeReadSimultTest