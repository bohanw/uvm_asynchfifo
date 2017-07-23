class driver extends uvm_driver #(uvm_sequence_item);
	`uvm_component_utils(driver)

	virtual fifo_interface itf;

	clkSeqItem clkItem;
	sequence_item seqItem;

	int writeCount;
	int readCount;
	function new (string name, uvm_coponent parent);

		super.new(name,parent);
	endfunction

	function void build_phase(uvm_phase phase);
		if(!uvm_config_db #(virtual fifoPorts)::get(this, "*","itf", itf))
			`uvm_fatal("DRIVER","fail to set interface");
	endfunction

	//reset phase of the RUN PHASE
	task reset (uvm_phase phase);
		//phase.raise_objection(this);

		itf.wrst_n = 1'b0;
		itf.rrst_n = 1'b0;

		@(negedge itf.wclk);
		@(negedge itf.rclk);
		@(negedge itf.wclk);
		@(negedge itf.rclk);
		itf.wrst_n = 1;
		itf.rrst_n = 1;
		//phase.drop_objection(this);
	endtask

	task run_phase(uvm_phase phase);

		reset(phase);
		forever begin 
			seq_item_port.get_next_item(req);
			if($cast(clkItem,req)) begin
				itf.wperiod = clkItem.wperiod;
				itf.rperiod = clkItem.rperiod;
				`uvm_info("Driver",$sformatf("wperiod = %d, rperiod= %d",clkItem.wperiod,clkItem.rperiod));

			end
			else begin
				if(!$cast(seqItem,req))
					`uvm_error("Driver","unknown trasaction");
				sendData(seqItem,phase);
			end
		end
	endtask : run_phase


	task sendData(sequence_item seqItem, uvm_phase phase);
		case(seqItem.op)
			RESET: begin
				$display("RESET in effect......");
				reset(phase);
			end
			WRITE: begin
				this.writeCount++;
				`uvm_info("Driver",$sformatf("%d Prepare FIFO for writing", $time));
				itf.wdata = seqItem.wdata;
				itf.winc = seqItem.winc;
				itf.rinc = 0;
				@(posedge itf.wclk);	
			end
			READ:begin
				this.readCount++;
				`uvm_info("Driver",$sformatf("%d Prepare FIFO for Reading", $time));
				itf.winc = 0;
				itf.rinc = seqItem.rinc;
				@(posedge itf.rclk);

			end
			WRITEREAD: begin
				this.writeCount++;
				this.readCount++;
				itf.wdata = seqItem.wdata;
				itf.winc = seqItem.winc;
				itf.rinc = seqItem.rinc;
			end
			default: begin

			end
		endcase // seqItem.op
	endtask : sendData


endclass : driver