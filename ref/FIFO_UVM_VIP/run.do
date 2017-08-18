if [file exists "work"] {vdel -all}
vlib work

vlog -f dut.f
vlog -f tb.f

vopt top -o top_optimized  +acc +cover=sbfec+fifo1(rtl)
vsim top_optimized -coverage +UVM_TESTNAME=writeTillFullTest
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
coverage attribute -name TESTNAME -value writeTillFullTest
coverage save w.ucdb

vcover report w.ucdb -cvg -details


quit
