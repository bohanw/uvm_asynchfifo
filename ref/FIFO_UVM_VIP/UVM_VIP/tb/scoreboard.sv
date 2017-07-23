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

`uvm_analysis_imp_decl (_read)
`uvm_analysis_imp_decl (_write)
class scoreboard extends uvm_scoreboard;
 `uvm_component_utils(scoreboard)


// Transactions comming from output monitor
uvm_analysis_imp_read #(seqItem, scoreboard) port_read;
uvm_analysis_imp_write #(seqItem, scoreboard) port_write;

uvm_tlm_fifo #(seqItem) wroteDataFifo; // this fifo is needed for keeping the write transactions after getting them from wroteData_f
									  // and than comparing that transactions with read transactions
 
 int fifo_DEPTH; // This variable contains FIFO depth, neede to check if fifo is full or empty
 int numbOfWritesInFifo;
 	seqItem wrtTr;


function new (string name="scoreboard", uvm_component parent);
  super.new(name, parent);
  this.numbOfWritesInFifo = 0;
  uvm_config_db #(int)::get(null, "*","DEPTH", fifo_DEPTH);
endfunction

function void build_phase (uvm_phase phase);
  port_read = new("port_read", this);
  port_write = new ("port_write", this);  
  uvm_config_db #(int)::get(null, "*","DEPTH", fifo_DEPTH);
  wroteDataFifo = new("wroteDataFifo", this, fifo_DEPTH);

endfunction


function void write_write (seqItem tr); // write function for port_write
	
	this.numbOfWritesInFifo++;
	`uvm_info("SB", $sformatf(" Write Operation is performed: number of Writes = %d, data=%h",this.numbOfWritesInFifo, tr.wdata), UVM_LOW); 	
	
	if (this.numbOfWritesInFifo >= this.fifo_DEPTH)
	begin
		`uvm_info("SB", $sformatf(" --------> FIFO must be F U L L <-------- checking -wfull- ..."), UVM_LOW); 
		if (tr.wfull != 1'b1)
			begin
			`uvm_error("SB", $sformatf("************ E R R O R: FIFO -wfull- signal is LOW, but expected HIGH - wfull=%b ************",tr.wfull));
			$display( " ");
			end
		else
		begin
			`uvm_info("SB", $sformatf(" ******* P A S S **** FIFO -wfull- signal is High"), UVM_LOW);
			$display(" ");
		end
	end	
		
	if (wroteDataFifo.can_put()) 
		begin
			seqItem tr_cp;
			tr_cp = seqItem::type_id::create("tr_cp", this);
			tr_cp.do_copy(tr); // making copy of the received transaction, to keep it in uvm_tlm_fifo
			$display("scorebaord: Transaction copied: tr_cp.wdata=%h, tr.wdata=%h", tr_cp.wdata, tr.wdata);
			wroteDataFifo.try_put(tr_cp); 
		end
	else
		`uvm_warning("SB", "Could not put transaction in wroteDataFifo" );
		
endfunction

function checkFifoEmpty (seqItem tr);

	if (tr.rempty == 1'b1)
	begin
		`uvm_info("SB", $sformatf(" ******* P A S S **** FIFO empty is High"), UVM_LOW);
		 $display("  ");	// UVM or may be simulator does not allow to have only `uvm_info statement alone, gives error.
	end
	else
	begin
		`uvm_info("SB", $sformatf(" ******* F A I L **** FIFO empty is LOW"), UVM_LOW);
		 $display("  ");	// UVM or may be simulator does not allow to have only `uvm_info statement alone, gives error.
	end	

endfunction

// This function is being triggered when the output monitor reads the data from FIFO
function void write_read (seqItem tr); // write function for port_read

	`uvm_info("SB", $sformatf(" Read Operation is performed: number of Writes = %d, read data=%h",this.numbOfWritesInFifo, tr.rdata), UVM_LOW); 	
	if (this.numbOfWritesInFifo >= 1)
		this.numbOfWritesInFifo --;
	else // numbOfWritesInFifo=0
		begin
		`uvm_info("SB", "<><><><><> FIFO is Empty, checking -rempty- signal", UVM_LOW); 	
		 checkFifoEmpty (tr);
		end
		
	wrtTr = seqItem::type_id::create("wrtTr", this);
	
	//$display ("%t:scoreboard: ===>>> Size of the uvm_tlm_fifo=%d,used=%d",$time,wroteDataFifo.size(), wroteDataFifo.used());
	// 1; read previous write transaction from the uvm_tlm_fifo
		if (wroteDataFifo.can_get()) 
			 if (wroteDataFifo.try_get(wrtTr)) 
			 begin
	// 2; compare that write transaction data with read data
				//$display ("%t:scoreboard:******* Write trans data=%b -- Read trans data=%b  <<***********", $time,wrtTr.wdata, tr.rdata );	
				if (wrtTr.wdata == tr.rdata)
				begin
					`uvm_info("SB", $sformatf(" ******* P A S S **** Write_tr=%h -- Read_tr=%h",wrtTr.wdata, tr.rdata ), UVM_LOW);
					$display("  ");	// UVM or may be simulator does not allow to have only `uvm_info statement alone, gives error. So adding display			
				end	
				else
				begin
					`uvm_info("SB", $sformatf(" ******* F A I L **** Write_tr=%h -- Read_tr=%h",wrtTr.wdata, tr.rdata ), UVM_LOW); 	
					$display("  ");				
				end
				 
			end
			else
				`uvm_warning("SBWrng", $sformatf("WRONG data Reading from internal tlm fifo: %b",wrtTr.wdata )); 			
				
endfunction


endclass