	`include "uvm_macros.svh"
	import uvm_pkg::*;
class driver extends uvm_driver #(uvm_sequence_item);
	`uvm_component_utils(driver)

	virtual fifo_interface itf;

	clkSeqItem clkItem;
	sequence_item seqItem;

	//How to 
	int writeCount;
	int readCount;

	function new (string name, uvm_component parent);
		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(virtual fifo_interface)::get(null, "*","itf", itf))
			`uvm_fatal("DRIVER","fail to set interface");
	endfunction

	//reset phase of the RUN PHASE
	task reset (uvm_phase phase);
		//phase.raise_objection(this);
		$display ("%t : Driver Running Reset... ", $time);
		itf.wrst_n = 1'b0;
		itf.rrst_n = 1'b0;

		@(negedge itf.wclk);
		@(negedge itf.rclk);
		@(negedge itf.wclk);
		@(negedge itf.rclk);
		itf.wrst_n = 1;
		itf.rrst_n = 1;
		//phase.drop_objection(this);
		$display ("%t : Driver Finish Running Reset...", $time);
	endtask

	task run_phase(uvm_phase phase);

		//clkItem = clkSeqItem::type_id::create("clkItem");
		//seqItem = sequence_item::type_id::create("seqItem");
		
		forever begin 
			seq_item_port.get_next_item(req);
			if($cast(clkItem,req)) begin
				itf.wperiod = clkItem.wperiod;
				itf.rperiod = clkItem.rperiod;
				`uvm_info("Driver",$sformatf("wperiod = %d, rperiod= %d",clkItem.wperiod,clkItem.rperiod),UVM_LOW);
				reset(phase);
			end
			else begin
				if(!$cast(seqItem,req))
					`uvm_error("Driver","unknown trasaction");
				sendData(seqItem,phase);
			end
			seq_item_port.item_done();
			$display("%t Finish trasaction.....",$time);
		end
	endtask : run_phase


	task sendData(sequence_item seqItem, uvm_phase phase);
		case(seqItem.op)
			RESET: begin
				$display("RESET in effect......");
				reset(phase);
			end
			WRITE: begin

				//@(negedge itf.wclk);
				this.writeCount++;
				itf.wdata <= seqItem.wdata;
				itf.winc <= seqItem.winc;
				itf.rinc <= 0;
				@ (posedge itf.wclk);
				`uvm_info("Driver",$sformatf("%d Prepare FIFO for writing", seqItem.wdata),UVM_LOW);

	
			end
			READ:begin
				//@(negedge itf.rclk);
				this.readCount++;
				itf.rinc <= seqItem.rinc;
				@(posedge itf.rclk);
				`uvm_info("Driver",$sformatf("%d Prepare FIFO for Reading", seqItem.rdata),UVM_LOW);


			end
			WRITEREAD: begin
				@(negedge itf.wclk);
				itf.winc <= seqItem.winc;
				this.writeCount++;
				//`uvm_info("Driver",$sformatf("%d FIFO Reading %h Writing %h", $time, seqItem.rdata,seqItem.wdata),UVM_LOW);
				itf.wdata <= seqItem.wdata;
				
				//@(negedge itf.rclk);
				itf.rinc <= seqItem.rinc;
				this.readCount++;

				@(posedge itf.rclk);
				`uvm_info("Driver",$sformatf("%d Prepare FIFO for writing", seqItem.wdata),UVM_LOW);
				@(posedge itf.rclk);
				`uvm_info("Driver",$sformatf("%d Prepare FIFO for Reading", seqItem.rdata),UVM_LOW);

			end
			default: begin

			end
		endcase // seqItem.op
	endtask : sendData


endclass : driver