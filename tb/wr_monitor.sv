	`include "uvm_macros.svh"
	import uvm_pkg::*;
class wr_monitor extends uvm_monitor;
	`uvm_component_utils(wr_monitor)

	//virtual interface
	virtual fifo_interface itf;
	//sequence itme handle
	sequence_item wrSeqItem;

	//uvm analysis port declaration
	uvm_analysis_port#(sequence_item) wr_ap;

	int fifo_depth;
	function new (string name="wr_monitor",uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
	    void' (uvm_config_db #(virtual fifo_interface)::get(this, "*","itf", itf));
	    void' (uvm_config_db#(int)::get(null, "*", "DEPTH", fifo_depth ));
	    wrSeqItem = sequence_item::type_id::create("wrSeqItem",this);	  
	    wr_ap = new("wr_ap",this);
	endfunction : build_phase

	task run_phase (uvm_phase phase);
		int writeCount = 0;

		forever begin
			@(posedge itf.wclk);
			if(itf.winc && itf.wrst_n) begin
				writeCount++;
				if(writeCount == this.fifo_depth) begin
					$display("%t FIFO is full, write count == DEPTH = %d", $time, this.fifo_depth);
					wrSeqItem.wdata = itf.wdata;
					@(negedge itf.wclk);
					$display("%t wfull = %h", $time, itf.wfull);
				end
				wrSeqItem.wdata = itf.wdata;
				wrSeqItem.wfull = itf.wfull;
				wr_ap.write(wrSeqItem);
			end
			else begin
				$display("%t:monitor FIFO not writing", $time);
				@(posedge itf.winc or posedge itf.wrst_n);
			end

		end

	endtask : run_phase



endclass

