library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mul_stall_ctrl is
    generic (
        MUL_LATENCY : integer := 5
    );
    port (
        clk        : in  std_logic;
        rst        : in  std_logic;

        start_mul  : in  std_logic;  -- 1-cycle pulse from ID/EX
        stall      : out std_logic;
        mul_ready  : out std_logic
    );
end entity;

architecture rtl of mul_stall_ctrl is
    signal busy    : std_logic;
    signal counter : unsigned(3 downto 0);
begin

    process(clk, rst)
    begin
        if rst = '0' then
            busy    <= '0';
            counter <= (others => '0');

        elsif rising_edge(clk) then
            if busy = '0' then
                if start_mul = '1' then
                    busy    <= '1';
                    counter <= to_unsigned(MUL_LATENCY-1, counter'length);
                end if;
            else
                if counter = 0 then
                    busy <= '0';
                else
                    counter <= counter - 1;
                end if;
            end if;
        end if;
    end process;

    stall     <= not busy;
    mul_ready <= '1' when (busy = '1' and counter = 0) else '0';

end architecture;
