	`include "uvm_macros.svh"
	import uvm_pkg::*;
	
`uvm_analysis_imp_decl(_read)
`uvm_analysis_imp_decl(_write)
class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	uvm_analysis_imp_read #(sequence_item,scoreboard) port_read;
	uvm_analysis_imp_write #(sequence_item,scoreboard) port_write;

	uvm_tlm_fifo #(sequence_item) wrDataFifo;

	int fifo_depth;
	int fifoWrCount;
	sequence_item wrTr;


	function new(string name="scoreboard",uvm_component parent);
		super.new(name,parent);
		this.fifoWrCount = 0;
		if(!uvm_config_db#(int)::get(null, "*", "DEPTH",fifo_depth ))
			`uvm_error("scoreboard","FAIL TO GET DEPTH");
	endfunction : new

	function void build_phase(uvm_phase phase);
		port_read = new("port_read",this);
		port_write = new("port_write",this);
		//if(!uvm_config_db#(int)::get(null, "*", "DEPTH",fifo_depth ))
		//	`uvm_error("scoreboard","fail to get depth");
		wrDataFifo = new("wrDataFifo",this, fifo_depth);
	endfunction : build_phase


	function void write_write(sequence_item t);
		this.fifoWrCount++;
		`uvm_info("scoreboard", $sformatf("Perform write # of writes = %d data = %h",fifoWrCount,t.wdata),UVM_LOW);

		if(this.fifoWrCount >= this.fifo_depth) begin
			`uvm_info("scoreboard",$sformatf("FIFO full checking wfull = %h",t.wfull),UVM_LOW);

			if(!t.wfull) begin
				`uvm_error("scoreboard",$sformatf("FIFO expect full but wfull = %h",t.wfull));
			end
			else begin 
				`uvm_info("scoreboard",$sformatf("***PASS**** FIFO wfull signal functions"),UVM_LOW);
			end
		end
		else begin
			`uvm_info("scoreboard",$sformatf("FIFO write status: write performed = %d, fifo size = %d",this.fifoWrCount,this.fifo_depth),UVM_LOW);

		end
		if(wrDataFifo.can_put())begin
			sequence_item tr_cp;
			tr_cp = sequence_item::type_id::create("tr_cp",this);
			tr_cp.do_copy(t);
			$display("scoreboard: Transaction copied: tr_cp.wdata=%h, tr.wdata=%h", tr_cp.wdata, t.wdata);
			void' (wrDataFifo.try_put(tr_cp));

		end
		else begin
			`uvm_warning("SB", "Could not put transaction in wroteDataFifo" );
		end
	endfunction : write_write


// This function is being triggered when the output monitor reads the data from FIFO
function void write_read(sequence_item t);
	`uvm_info("scoreboard",$sformatf("Perform Read : # of writes = %d, data= %h",this.fifoWrCount,t.rdata),UVM_LOW);
	if(this.fifoWrCount >= 1) begin
		this.fifoWrCount--;
	end
	else begin
		`uvm_info("scoreboard","****check FIFO rempty flag",UVM_LOW);
		if(t.rempty) begin
			`uvm_info("scoreboard","***PASS: rempty functions",UVM_LOW);
		end
		else begin 
			`uvm_error("scoreboard","***FAIL****:rempty incorrect");
		end
	end

	wrTr = sequence_item::type_id::create("wrTr",this);

	if(wrDataFifo.can_get()) begin
		if(wrDataFifo.try_get(wrTr)) begin
			if(wrTr.wdata == t.rdata) begin
				`uvm_info("scoreboard",$sformatf("wdata = %h read data = %h",wrTr.wdata, t.rdata),UVM_LOW);	
			end
			else begin
				`uvm_error("scoreboard","read data not matched with write data");
			end

		end
		else begin
			`uvm_error("scoreboard",$sformatf("Wrong data reading from tlm fifo %h",wrTr.wdata));
		end
	end
	
endfunction

endclass : scoreboard