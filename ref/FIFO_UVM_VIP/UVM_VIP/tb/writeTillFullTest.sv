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

class writeTillFullTest extends uvm_test ;
`uvm_component_utils (writeTillFullTest)

env env_inst;


function new (string name, uvm_component parent);
	super.new(name, parent);
endfunction

function void build_phase (uvm_phase phase);
	env_inst = env::type_id::create("env_inst", this);
endfunction

task run_phase (uvm_phase phase);
		clkSequence clkSeq;
		writeTillFullSeq wDataFullSeq;
		

	phase.raise_objection(this);
	
	clkSeq = clkSequence::type_id::create("clkSeq",this);
	wDataFullSeq = writeTillFullSeq::type_id::create("wDataFullSeq",this);
	
	`uvm_info("Test"," >>>>>>>>>>>> Starting the clock sequence - clkSequence  >>>>>>>>>>>> ",UVM_MEDIUM );
		clkSeq.start(this.env_inst.agent_inst.sequencer_inst);
	
	`uvm_info("Test"," >>>>>>>>>>>> Starting Write Data Till Full Sequence - writeTillFullSeq >>>>>>>>>>>> ",UVM_MEDIUM );
		//wDataFullSeq.numberOfWrites=5;
		wDataFullSeq.start(this.env_inst.agent_inst.sequencer_inst);
	
	phase.drop_objection(this);

endtask
 
endclass

