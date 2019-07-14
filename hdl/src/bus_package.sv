`ifdef sample_bus

    interface bus_slave;
        logic wr;
        logic rd;
        logic [31:0] addr;
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

`else
// valid way for fail goes here
    assert (false) else $error ("not implemented");
`endif
