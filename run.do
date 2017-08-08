if [file exists "work"] {vdel -all}
vlib work

vlog -f dut.f
vlog -f tb.f

vopt top -o top_optimized +acc +cover=sbfec+fifo(rtl).
vsim top_optimized -coverage +UVM_TESTNAME=writeTest 
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
#coverage save fifo.ucdb
#vcover report fifo.ucdb
quit
