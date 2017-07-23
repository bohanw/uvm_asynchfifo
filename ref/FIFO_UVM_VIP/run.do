if [file exists "work"] {vdel -all}
vlib work

vlog -f dut.f
vlog -f tb.f

vopt top -o top_optimized  +acc +cover=sbfec+fifo1(rtl)
vsim top_optimized -coverage +UVM_TESTNAME=writeTest
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
coverage attribute -name TESTNAME -value writeTest
coverage save w.ucdb

vsim top_optimized -coverage +UVM_TESTNAME=writeResetTest
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
coverage attribute -name TESTNAME -value writeResetTest
coverage save wrst.ucdb

quit
