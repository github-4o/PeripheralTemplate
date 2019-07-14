module counter (
    input logic clk,
    input logic reset,

    bus_slave.in bus
);

    regiser_block_io #(.addr_w(2)) register_block_signals();
    logic auto_restart;
    logic enable;
    logic [31:0] cap;
    logic load;
    logic [31:0] load_val;
    logic overflow;

    bus_adapter bus_adapter (
        .clk (clk),
        .reset (reset),

        .bus (bus),

        .reg_block_io (register_block_signals)
    );

    counter_register_block reg_block (
        .clk (clk),
        .reset (reset),

        // bus adapter iface
        .io (register_block_signals),

        // counter iface
        // config
        .auto_restart (auto_restart),
        .enable (enable),
        .cap (cap),

        //actions
        .load (load),
        .load_val (load_val),

        .overflow (overflow)
    );

    // counter_core core (
    //     .clk (clk),
    //     .reset (reset),

    //     .auto_restart (auto_restart),
    //     .enable (enable),
    //     .cap (cap),

    //     //actions
    //     .load (load),
    //     .load_val (load_val),

    //     .overflow (overflow)
    // );

endmodule
