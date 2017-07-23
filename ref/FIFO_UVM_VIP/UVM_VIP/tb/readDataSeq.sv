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

class readDataSeq extends uvm_sequence #(seqItem);
`uvm_object_utils(readDataSeq)

rand int numberOfReads;
constraint readNmbCnstr {numberOfReads > 1;
					    	numberOfReads < 10;};

function new (string name = "readDataSeq");
	super.new(name);
endfunction

task body();

req = seqItem::type_id::create("seqreq");
$display("%t: ++++++++++++ readDataSeq: Number of reads= %d", $time, numberOfReads);
 
  repeat (numberOfReads)
   begin
	start_item(req);
		req.randomize();		
		req.rinc = 1'b1;
		req.op = READ;
	finish_item(req);
  end
	
endtask

endclass

