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

module top();

   import uvm_pkg::*;
`include "uvm_macros.svh"
   import fifoVerif_pkg::*;
//`include "fifoVerif_pkg.sv"
	import ownMessaging::*;	
	import fifoCovrg_pkg::*;
	
fifoPorts itf();

fifo1  inst ( .rdata(itf.rdata),
			  .wfull(itf.wfull),
			  .rempty(itf.rempty),
			  .wdata(itf.wdata),
			  .winc(itf.winc), .wclk(itf.wclk), .wrst_n(itf.wrst_n),
			  .rinc(itf.rinc), .rclk(itf.rclk), .rrst_n(itf.rrst_n) );

objectSpecific_catcher catcher = new();
initial
	uvm_report_cb::add(null, catcher);

 // Coverage blocks instantiation
write_cvr w_cvr;
read_cvr r_cvr;
 initial
begin
	w_cvr=new(itf);
	r_cvr=new(itf);
end


// Checker blocks instantiation
//checkDut  dut_sva (itf.wclk,itf.rclk,itf.wrst_n,itf.rrst_n,itf.wfull, itf.rempty);
bindModule svaBindModule();

	
initial 
begin
	uvm_config_db #(virtual fifoPorts)::set(null, "*","itf", itf);
	uvm_config_db #(int)::set(null, "*","DEPTH", fifoVerif_pkg::DEPTH);
	//run_test("writeResetTest");	
	run_test("write_readTest");	
	
end
	

 

// To control the randomization seed, in the modelsim simulation configuratin dialog
// in Oters-> Other Vsim Options section write
// -sv_seed random
			  
			  
endmodule