interface regiser_block_io #(parameter addr_w);
    logic wr;
    logic rd;
    logic [addr_w:0] addr;
    logic [31:0] data_i;
    logic [31:0] data_o;

    modport in (
        input wr,
        input rd,
        input addr,
        input data_i,
        output data_o
    );

    modport out (
        output wr,
        output rd,
        output addr,
        output data_i,
        input data_o
    );
endinterface

module bus_adapter (
    input logic clk,
    input logic reset,

    bus_slave.in bus,

    regiser_block_io.out reg_block_io
);

`ifdef sample_bus

    assign reg_block_io.wr = bus.wr;
    assign reg_block_io.rd = bus.rd;
    assign reg_block_io.addr = bus.addr [reg_block_io.addr_w-1:0];
    assign reg_block_io.data_i = bus.data_i;
    assign reg_block_io.data_o = bus.data_o;

`else
// valid way for fail goes here
    assert (false) else $error ("not implemented");
`endif

endmodule
