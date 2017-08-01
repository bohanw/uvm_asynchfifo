	`include "uvm_macros.svh"
	import uvm_pkg::*;
class agent extends uvm_agent;
	`uvm_component_utils(agent)

	driver driver_h;
	sequencer sequencer_h;
	wr_monitor wr_monitor_h;
	rd_monitor rd_monitor_h;

	//analysis port connect to monitor ap
	//uvm_analysis_port #(sequence_item) wr_agent_ap;
	//uvm_analysis_port #(sequence_item) rd_agent_ap;

	function new (string name, uvm_component parent);
		super.new(name,parent);

	endfunction : new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		driver_h = driver::type_id::create("driver_h",this);
		sequencer_h = sequencer::type_id::create("sequencer_h",this);
		wr_monitor_h = wr_monitor::type_id::create("wr_monitor_h",this);
		rd_monitor_h = rd_monitor::type_id::create("rd_monitor_h",this);
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		driver_h.seq_item_port.connect(sequencer_h.seq_item_export);

		//wr_monitor_h.wr_ap.connect(wr_agent_ap);
		//rd_monitor_h.rd_ap.connect(rd_agent_ap);
	endfunction


endclass : agent