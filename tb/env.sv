	`include "uvm_macros.svh"
	import uvm_pkg::*;
class env extends uvm_env;
	`uvm_component_utils(env)

	agent agent_h;
	scoreboard scoreboard_h;

	function new (string name, uvm_component parent);
 		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		agent_h = agent::type_id::create("agent_h",this);
		scoreboard_h = scoreboard::type_id::create("scoreboard_h",this);
	endfunction : build_phase

	function void connect_phase(uvm_phase phase);
		agent_h.wr_monitor_h.wr_ap.connect(scoreboard_h.port_write);
		agent_h.rd_monitor_h.rd_ap.connect(scoreboard_h.port_read);
	endfunction : connect_phase
endclass : env