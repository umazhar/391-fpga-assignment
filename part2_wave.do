onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /filter_tb/CLOCK_50
add wave -noupdate -radix decimal /filter_tb/in
add wave -noupdate -radix decimal /filter_tb/out
add wave -noupdate -radix decimal /filter_tb/read_ready
add wave -noupdate -radix decimal /filter_tb/DUT/buff0
add wave -noupdate -radix decimal /filter_tb/DUT/buff1
add wave -noupdate -radix decimal /filter_tb/DUT/buff2
add wave -noupdate -radix decimal /filter_tb/DUT/buff3
add wave -noupdate -radix decimal /filter_tb/DUT/buff4
add wave -noupdate -radix decimal /filter_tb/DUT/buff5
add wave -noupdate -radix decimal /filter_tb/DUT/buff6
add wave -noupdate -radix decimal /filter_tb/DUT/buff7
add wave -noupdate -radix decimal /filter_tb/DUT/sum
add wave -noupdate /filter_tb/DUT/noise
add wave -noupdate /filter_tb/DUT/enable
add wave -noupdate /filter_tb/DUT/CLOCK50
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {85 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {315 ps}
