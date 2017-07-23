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

class driver extends uvm_driver #(uvm_sequence_item);
`uvm_component_utils(driver)

virtual fifoPorts itf;
clkSeqItem clkItem;
seqItem dataItem;

int numberOfWrites=0,numberOfReads=0;

function new (string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void build_phase (uvm_phase phase);
	uvm_config_db #(virtual fifoPorts)::get(this, "*","itf", itf);
endfunction

task reset (uvm_phase phase);

$display ("%t : Driver Running Reset... ", $time);
itf.wrst_n = 1'b0;
itf.rrst_n = 1'b0;

	//$display ("%t:Driver-reset: wrst_n=%b-rrst_n=%b", $time,itf.wrst_n, itf.rrst_n);
repeat (2) begin
	@ (posedge itf.wclk);
	@ (posedge itf.rclk);
end

itf.wrst_n <= 1'b1;
itf.rrst_n <= 1'b1;

$display ("%t : Driver Finish Running Reset...", $time);

endtask

task run_phase (uvm_phase phase);

clkItem = clkSeqItem::type_id::create("clkItem");
dataItem =seqItem::type_id::create("dataItem");

//reset (phase);

forever 
begin
	seq_item_port.get_next_item(req);
		
		if ($cast(clkItem, req) ) begin
			itf.wperiod = clkItem.wperiod;	
			itf.rperiod = clkItem.rperiod;	
			 `uvm_info("Drv",$sformatf("wperiod=%d : rperiod=%d",clkItem.wperiod, clkItem.rperiod),UVM_LOW );
			 reset (phase);			 //<- May be it is better to move the reset here
		end 
		else 
		begin
			if (! $cast(dataItem, req) )  `uvm_error("Drv", "Unknow Transaction was passed to driver");
				sendDataInFifo(dataItem, phase);
			
		end
			
		//repeat (4)
		//@(posedge itf.wclk);
	
		$display ("%t: Driver: F I N I S H Transaction --------------------------------------------------- ", $time);
	seq_item_port.item_done ();
end
endtask

 task sendDataInFifo (seqItem dataItem, uvm_phase phase);
  //   $display("%t: Driver: sendDataInFifo: op=%d", $time, dataItem.op);
   
     case (dataItem.op)
     RESET :  begin
      $display("%t:Driver:Got Reset Command, Resetting the DUT", $time);
      reset_phase(phase);
   end
      WRITE:  begin
	  this.numberOfWrites ++;
	  `uvm_info("Drv",$sformatf("%d : Set up FIFO inputs and waiting for wclk posedge... : data=%h",this.numberOfWrites, dataItem.wdata), UVM_LOW);
		itf.wdata <= dataItem.wdata;
        itf.winc <= dataItem.winc;
		itf.rinc <= 1'b0;
        @(posedge itf.wclk);
      end
      READ: begin
	  `uvm_info("Drv",$sformatf("%d : Reading data from FIFO...",$time), UVM_LOW);
		itf.rinc <= dataItem.rinc;		
        @ (posedge itf.rclk);
      end
      WRITEREAD: begin
      end
      default:
          `uvm_error("Drv",$sformatf("Unknown operation was passed: op=%d",dataItem.op))
  endcase

 endtask
	
endclass

