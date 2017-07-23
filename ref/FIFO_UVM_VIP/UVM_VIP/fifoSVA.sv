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
module bindModule;

bind  fifo1 checkDut  bndInst1 (.wclk(wclk),.rclk(rclk),.wrst_n(wrst_n),.wptr(wptr),
							 .rrst_n(rrst_n),.wfull(wfull), .rempty(rempty), .rptr(rptr) );


endmodule

module checkDut (input logic  wclk,rclk,wrst_n,wptr,
					 rrst_n,wfull,rempty, rptr);

   import uvm_pkg::*;
`include "uvm_macros.svh"

// 1.	Check that on reset all pointers and full/empty signals are going to their low states
property wrstProp;
	@(posedge wclk) !(wrst_n) |-> (wfull==0); 
endproperty
asrtWrst: assert property (wrstProp) else 
		`uvm_fatal("Assrt","wfull is not 0, when reseting"); 
cvrWrst: cover property (wrstProp);

property wptrProp;
	@(posedge wclk) !(wrst_n) |-> (wptr==0); 
endproperty
asrtWptr: assert property (wptrProp) else 
		`uvm_fatal("Assrt","wptr is not 0, when reseting"); 
cvrWptr: cover property (wptrProp);

property rrstProp;
	@(posedge rclk) !(rrst_n) |-> (rempty==1);
endproperty
asrtRrst: assert property (rrstProp) else 
	`uvm_fatal("Assrt","rempty is not 1, when reseting");
cvrRrst: cover property (rrstProp);

property rptrProp;
	@(posedge rclk) (!(rrst_n)) |-> (rptr==0);
endproperty
asrtRptr: assert property (rptrProp) else 
	`uvm_fatal("Assrt","rptr is not 0, when reseting");
cvrRptr: cover property (rptrProp);


task disp (input logic item);
	$display("%t: <><><><><>>>>>> display from prop: item=%b", $time, item);
endtask


// always @(posedge rclk)
	// $display("%t: -- rrst_n=%b, rempty=%b", $time, rrst_n, rempty);


endmodule: checkDut


