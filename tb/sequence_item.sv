	`include "uvm_macros.svh"
	import uvm_pkg::*;
class sequence_item extends uvm_sequence_item;
	`uvm_object_utils(sequence_item)

	rand logic [7:0] wdata;
	logic wfull,rempty;
	logic [7:0] rdata;

	logic winc,rinc,wrst_n,rrst_n;

	constraint data { 
		wdata dist {
			8'h00:=1,
			[8'h01:8'hFE]:=1,
			8'hFF:=1
		};
	};


	fifo_pkg::operation_t  op;

	function new (string name="sequence_item");
		super.new(name);
	endfunction

	function void do_copy(uvm_object rhs);
		sequence_item RHS;
		assert (rhs != null) else
			$fatal(1,"");
		super.do_copy(rhs);
		assert($cast(RHS, rhs)) else
			$fatal(1,"FAIL TO COPY");
		wdata = RHS.wdata;
		rdata = RHS.rdata;
		wfull = RHS.wfull;
		rempty = RHS.rempty;
		winc = RHS.winc;
		rinc = RHS.rinc;
		wrst_n = RHS.wrst_n;
		rrst_n = RHS.rrst_n;
	endfunction

	function bit do_compare(uvm_object rhs, uvm_comparer comparer);
		sequence_item test;
		bit same;

		if(rhs == null) `uvm_fatal(get_type_name(),"Tried to cmp to null");

		if(!$cast(test,rhs))
			same = 0;
		else
			same = super.do_compare(rhs,comparer) && (test.wdata == wdata) && 
			(test.rdata == rdata) && 
			(test.wfull == wfull) && 
			(test.rempty == rempty) &&
			(test.winc == winc)&&
			(test.rinc == rinc) && 
			(test.rrst_n == rrst_n) &&
			(test.wrst_n == wrst_n);
		return same;
	endfunction
	
	function string convert2String();
		string s;
		s = $sformatf("wdata : %2h wfull : %h rdata:%2h",wdata,wfull,rdata);
		return s;
	endfunction
endclass

