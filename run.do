if [file exists "work"] {vdel -all}
vlib work

vlog -f dut.f
vlog ./tb/tb.sv

vopt tb -o top_optimized +acc +cover=sbfec+fifo(rtl).
vsim top_optimized -coverage
set NoQuitOnFinish 1
onbreak {resume}
log /* -r
run -all
coverage save fifo.ucdb
vcover report fifo.ucdb
quit
