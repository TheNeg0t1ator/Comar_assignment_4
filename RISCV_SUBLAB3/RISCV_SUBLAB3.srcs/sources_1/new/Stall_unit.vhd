library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity mul_stall_ctrl is
    generic (
        MUL_LATENCY : integer := 5;
        PC_WIDTH    : integer := 32
    );
    port (
        clk           : in  std_logic;
        rst           : in  std_logic;

        PC_EX         : in  std_logic_vector(PC_WIDTH-1 downto 0);
        Vecmul_enable : in  std_logic;
        mul_enable    : in  std_logic_vector(2 downto 0);

        stall         : out std_logic;  -- '1' = ENABLED, '0' = STALLED
        mul_ready     : out std_logic   -- HIGH one cycle before stall ends
    );
end entity;

architecture rtl of mul_stall_ctrl is

    signal pc_ex_prev  : std_logic_vector(PC_WIDTH-1 downto 0);
    signal mul_busy    : std_logic;
    signal counter     : unsigned(5 downto 0);

    signal is_mul      : std_logic;
    signal is_vecmul   : std_logic;
    signal new_instr   : std_logic;

begin

    --------------------------------------------------------------------
    -- Instruction decode
    --------------------------------------------------------------------
    is_mul <= '1' when mul_enable = "111" or mul_enable = "110"
              else '0';

    is_vecmul <= Vecmul_enable;

    --------------------------------------------------------------------
    -- New instruction detection (EX stage)
    --------------------------------------------------------------------
    new_instr <= '1' when PC_EX /= pc_ex_prev else '0';

    --------------------------------------------------------------------
    -- Stall / counter logic
    --------------------------------------------------------------------
    process(clk, rst)
    begin
        if rst = '0' then
            pc_ex_prev <= (others => '0');
            mul_busy   <= '0';
            counter    <= (others => '0');

        elsif rising_edge(clk) then
            pc_ex_prev <= PC_EX;

            -- Start MUL / VECMUL
            if (new_instr = '1') and (mul_busy = '0') and
               (is_mul = '1' or is_vecmul = '1') then

                mul_busy <= '1';
                counter  <= to_unsigned(MUL_LATENCY-1, counter'length);

            -- MUL in progress
            elsif mul_busy = '1' then
                if counter = 0 then
                    mul_busy <= '0';
                else
                    counter <= counter - 1;
                end if;
            end if;
        end if;
    end process;

    --------------------------------------------------------------------
    -- Outputs
    --------------------------------------------------------------------
    stall <= not mul_busy;

    -- Asserted in the LAST stall cycle
    mul_ready <= '1' when (mul_busy = '1' and counter = 0)
                 else '0';

end architecture;