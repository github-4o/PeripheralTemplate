library ieee;
use ieee.std_logic_1164.all;
library work;
use work.platform.all;


entity reg is
    generic (
        gReset_value: std_logic_vector := "0"
    );
    port (
        clk: in std_logic;
        reset: in std_logic;

        data_i: in std_logic_vector;
        data_o: out std_logic_vector
    );
end entity;

architecture v1 of reg is

    function define_reset_val (val: std_logic_vector) return std_logic_vector is
    begin
        if val'length /= data_i'length then
            return (data_i'range => '0');
        else
            return val;
        end if;
    end function;

    constant cReset_value: std_logic_vector := define_reset_val (gReset_value);

begin

    sync_reset: if cAsync_reset = false generate

        process (clk)
        begin
            if clk'event and clk = '1' then
                if reset = cReset_active_level then
                    data_o <= cReset_value;
                else
                    data_o <= data_i;
                end if;
            end if;
        end process;

    end generate;

    async_reset: if cAsync_reset = true generate

        process (clk, reset)
        begin
            if reset = cReset_active_level then
                data_o <= cReset_value;
            else
                if clk'event and clk = '1' then
                    data_o <= data_i;
                end if;
            end if;
        end process;

    end generate;

end v1;
