///////////////////////////////////////////////////////////////////////////////////
//																			     //
//  Copyright 2015-2016 by YanSolutions											 //
//                                                                               //
//  All rights reserved. The source code contained herein is publicly released   //
//  under the terms and conditions of the YanSolutions License. No part of       //
//  this source code may be reproduced or transmitted in any form or by any      //
//  means, electronic or mechanical, including photocopying, recording, or any   //
//  information storage and retrieval system in violation of the license under   //
//  which the source code is released.                                           //
//                                                                               //
//  The source code contained herein is free; it may be studied, copied,         //
// compiled and executed only for academic, non-commercial research purposes,    //
//  subject to the restrictions in YanSolutions License.                         //
//                                                                               //
//  You may not Re-distribute this VIP in any form for any purposes. Examples    //
//  of purposes would be running business operations, licensing,                 //
//  leasing, or selling the FreeVIP, distributing the FreeVIP for use            //
//  with commercial or non-commercial products, using the FreeVIP in             //
//  the creation or use of commercial or non-commercial products.                //
//                                                                               //
// THIS CODE IS PROVIDED ''AS IS'' AND WITHOUT ANY                               //
// EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED                     //
// TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A               //
// PARTICULAR PURPOSE. IN NO EVENT SHALL YS NOR ANY CONTRIBUTOR TO               //
// THE FREEVIP WILL BE LIABLE FOR ANY DAMAGES RELATED TO THE FREEVIP OR          //
// THIS LICENSE, INCLUDING DIRECT, INDIRECT, SPECIAL, CONSEQUENTIAL OR           //
// INCIDENTAL DAMAGES, TO THE MAXIMUM EXTENT THE LAW PERMITS, NO MATTER WHAT     //
// LEGAL THEORY IT IS BASED ON. ALSO, YOU MUST PASS THIS LIMITATION OF           //
// LIABILITY ON WHENEVER YOU DISTRIBUTE THE FREEVIP OR DERIVATIVE WORKS.         //
//                                                                               //
//  YanSolutions, Inc.                                                           //
//  Yerevan, Davidashen 4, 21/2                                                  //
//  Armenia, www.yansolutions.com                                                //
//                                                                               //
/////////////////////////////////////////////////////////////////////////////////// 

class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)

    virtual fifoPorts itf;
    seqItem wtrans, rtrans;
	uvm_analysis_port #(seqItem) readDataSend_port;
	uvm_analysis_port #(seqItem) writeDataSend_port;
	
	// This parameter controls the number of rclk cycles, after which the read data appear to FIFO output
	int readDataReady = 1;
	int writeDataReady = 1;
	
	int fifo_DEPTH; // This variable contains FIFO depth, neede to check if fifo is full or empty
	int numbOfWritesInFifo;	
	
	function new (string name="monitor", uvm_component parent);
		super.new(name, parent);
		this.numbOfWritesInFifo = 0;
	endfunction

	function void build_phase (uvm_phase phase);
	    uvm_config_db #(virtual fifoPorts)::get(this, "*","itf", itf);
		readDataSend_port = new("readDataSend_port",this);
		writeDataSend_port = new ("writeDataSend_port", this);
		wtrans = seqItem::type_id::create("wtrans", this);
		rtrans = seqItem::type_id::create("rtrans", this);
		uvm_config_db #(int)::get(null, "*","DEPTH", fifo_DEPTH);
	endfunction
	
	
	task run_phase (uvm_phase phase);
	
	$display ("%t: monitor: Starting DUT ouptut data collection", $time);
	fork
	// write data monitor
	 forever
		begin
			 //@(posedge itf.wclk) <- when writing posedge output monitor takes as a value of wfull 0
			 @(posedge itf.wclk)
			 	if (itf.winc == 1'b1 && itf.wrst_n == 1'b1)
				begin
					this.numbOfWritesInFifo++;
					$display("%t: monitor: write data appeared on DUT out, making transaction and sending: wfull=%b", $time, itf.wfull);
					if (this.numbOfWritesInFifo == this.fifo_DEPTH)
						begin
							$display("%t: ouptuMonitor: number of FIFO writes equal to FIFO width, waiting for wfull value ", $time);
							wtrans.wdata = itf.wdata;				
							@(negedge itf.wclk);		
							$display ("%t: ouptuMonitor: wful = %b", $time, itf.wfull);
						end
					wtrans.wdata = itf.wdata;					
					wtrans.wfull = itf.wfull;				
					writeDataSend_port.write(wtrans);			
				end	
					else
					begin
						$display("%t:monitor: FIFO is not in WRITE mode", $time );
						@(posedge itf.winc or posedge itf.wrst_n);
					end				
		end
		
	// read data monitor
		forever
		begin
			if (itf.rinc && itf.rrst_n)	
			begin
			repeat(readDataReady) // wait until read data appear to DUT output
			@ (posedge itf.rclk)
				if (itf.rinc && itf.rrst_n)	
				begin
					this.numbOfWritesInFifo--;
					// Make transaction and send
					$display("%t: monitor: read data appeared on DUT out, making transaction and sending : rdata=%h, rempty=%h, numbOfWritesInFifo=%d", $time, itf.rdata, itf.rempty,this.numbOfWritesInFifo);
					rtrans.rdata = itf.rdata;
					rtrans.rempty = itf.rempty;
					readDataSend_port.write(rtrans);			
			  end
			end 
			else
			begin
				$display("%t:monitor: FIFO is not in READ mode", $time );				
				@(posedge itf.rinc or posedge itf.rrst_n);
			end
		end		
		
	join
	
	endtask
	
	
endclass