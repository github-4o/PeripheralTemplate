vcom ../src/pkg/platform.vhd
vcom ../src/register.vhd

vlog -sv ../src/bus_package.sv +define+sample_bus
vlog -sv ../src/bus_adapter.sv
vcom ../src/counter_core.vhd
vlog -sv ../src/counter_register_block.sv
vlog -sv ../src/counter.sv
