force inp 2#11110000
force CLK 0
force ARESETN 1
run 100 ns
force loadEnable 1
run 100 ns
force CLK 1
run 100 ns