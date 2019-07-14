library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity counter_core is
    port (
        clk: in std_logic;

        auto_restart: in std_logic;
        enable: in std_logic;
        cap: in std_logic_vector (31 downto 0);

        load: in std_logic;
        load_val: in std_logic_vector (31 downto 0);

        overflow: out std_logic
    );
end entity;

architecture v1 of counter_core is

    signal sCnt: unsigned (31 downto 0);

begin

    process (clk)
    begin
        if clk'event and clk = '1' then
            if enable = '0' then
                sCnt <= (sCnt'range => '0');
            else
                if sCnt = unsigned (cap) then
                    if auto_restart = '1' then
                        sCnt <= (others => '0');
                    end if;
                else
                    if load = '1' then
                        sCnt <= unsigned (load_val);
                    else
                        sCnt <= sCnt + 1;
                    end if;
                end if;
            end if;
        end if;
    end process;

    process (clk)
    begin
        if clk'event and clk = '1' then
            if enable = '0' then
                overflow <= '0';
            else
                if sCnt = unsigned (cap) then
                    overflow <= '1';
                else
                    overflow <= '0';
                end if;
            end if;
        end if;
    end process;

end v1;
