module bindModule;

	bind fifo checkDut i0(.wclk(wclk),.rclk(rclk),.wrst_n(wrst_n),.wptr(wptr),
							 .rrst_n(rrst_n),.wfull(wfull), .rempty(rempty), .rptr(rptr) );

endmodule


module checkDut(input logic  wclk,rclk,wrst_n,wptr,
					 rrst_n,wfull,rempty, rptr);
   import uvm_pkg::*;
`include "uvm_macros.svh"

	property wrstFullProp;
		@(posedge wclk) !(wrst_n) |-> (wfull == 0);
	endproperty
	assert property (wrstFullProp)
	else `uvm_fatal("Assert","wfull not reset");

	property rrstProp;
		@(posedge rclk) !(rrst_n) |-> (rempty == 0);
	endproperty
	assert property (rrstProp)
	else `uvm_fatal("Assert","rempty not reset");
endmodule
