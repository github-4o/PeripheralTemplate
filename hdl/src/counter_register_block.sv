`define RESET_ACTIVE_LEVEL_HIGH
`define SYNC_RESET

`ifdef RESET_ACTIVE_LEVEL_HIGH
    `define RESET_ACTIVE_LEVEL 1
`endif

`ifdef RESET_ACTIVE_LEVEL_LOW
    `define RESET_ACTIVE_LEVEL 0
`endif

interface counter_regiser_block_io;
    logic wr;
    logic rd;
    logic [1:0] addr;
    logic [31:0] data_i;
    logic [31:0] data_o;

    modport in (
        input wr,
        input rd,
        input addr,
        input data_i,
        output data_o
    );

endinterface

module counter_register_block (
    input logic clk,
    input logic reset,

    // bus adapter iface
    counter_regiser_block_io.in io,

    // counter iface
    // config
    output logic auto_restart,
    output logic enable,
    output logic [31:0] cap,

    //actions
    output logic load,
    output logic [31:0] load_val,

    input logic overflow
);
    logic [2:0] registers_wr [31:0];
    logic [2:0] registers_rd [31:0];
    logic load_comb;

    always_ff @(posedge clk) begin
        io.data_o <= registers_rd [io.address];
    end

    // control register
    assign auto_restart = registers_wr [0] [0];
    assign enable = registers_wr [0] [1];

    // process option one: hardcode
    always_ff @(posedge clk) begin
        if (reset) begin
            registers_wr [0] <= 32'b0;
        end else begin
            if (io.wr) begin
                if (io.address == 0) begin
                    registers_wr [0] <= io.data_i;
                end
            end
        end
    end

    assign registers_rd [0] = {29'b0, overflow, enable, auto_restart};

    // cap register
    assign cap = registers_wr [1];

    // option two: parameterized active level
    always_ff @(posedge clk) begin
        if (reset == `RESET_ACTIVE_LEVEL) begin
            registers_wr [1] <= 32'b0;
        end else begin
            if (io.wr) begin
                if (io.address == 1) begin
                    registers_wr [1] <= io.data_i;
                end
            end
        end
    end

    assign registers_rd [1] = registers_wr [1];

    // load register
    assign load_val = registers_wr [2];

    // option two: cc for sync/async reset
    `ifdef SYNC_RESET
        always_ff @(posedge clk)
    `endif
    `ifdef ASYNC_RESET
        `ifdef RESET_ACTIVE_LEVEL_HIGH
            always_ff @(posedge clk, posedge reset)
        `endif
        `ifdef RESET_ACTIVE_LEVEL_LOW
            always_ff @(posedge clk, negedge reset)
        `endif
    `endif
        begin
            if (reset == `RESET_ACTIVE_LEVEL) begin
                registers_wr [2] <= 32'b0;
            end else begin
                if (io.wr) begin
                    if (io.address == 2) begin
                        registers_wr [2] <= io.data_i;
                    end
                end
            end
        end

    // option three: explicit register block
    always_comb
    begin
        if (io.wr) begin
            if (io.address == 2) begin
                load_comb <= 1'b1;
            end else begin
                load_comb <= 1'b0;
            end
        end else begin
            load_comb <= 1'b0;
        end
    end

    register register (
        .clk (clk),
        .reset (reset),

        .data_i ({load_comb}),
        .data_o ({load})
    );

    assign registers_rd [2] = registers_wr [2];

endmodule
