	`include "uvm_macros.svh"
	import uvm_pkg::*;
class rd_monitor extends uvm_monitor;
	`uvm_component_utils(rd_monitor)

	virtual fifo_interface itf;

	sequence_item rdSeqItem;
	uvm_analysis_port #(sequence_item) rd_ap;

	function new(string name="rd_monitor",uvm_component parent);
		super.new(name,parent);
	endfunction : new

	function void build_phase(uvm_phase phase);
	    if(!uvm_config_db #(virtual fifo_interface)::get(this, "*","itf", itf))
	    	`uvm_error("RD_MONITOR","*****");
	    //uvm_config_db#(int)::get(null, "*", "DEPTH", fifo_depth );
	    rdSeqItem = sequence_item::type_id::create("rdSeqItem",this);	  
	    rd_ap = new("rd_ap",this);		
	endfunction : build_phase


	task run_phase(uvm_phase phase);
		forever begin
			@(posedge itf.rclk);
			if(itf.rinc && itf.rrst_n) begin 
				$display("$t: reading data, transactions and sending: rdata = %h, rempty = %b",$time,itf.rdata,itf.rempty);
				rdSeqItem.rdata = itf.rdata;
				rdSeqItem.rempty = itf.rempty;
				rd_ap.write(rdSeqItem);
			end

			else begin
				$display("$t FIFO not reading", $time);
				@(posedge itf.rinc or posedge itf.rrst_n);
			end
		end
	endtask : run_phase

endclass : rd_monitor