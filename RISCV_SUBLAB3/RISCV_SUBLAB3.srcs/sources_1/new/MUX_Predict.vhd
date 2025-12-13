library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity Mux_Predict is
    port (
        PC_Current : in  std_logic_vector(31 downto 0);
        PC_Old     : in  std_logic_vector(31 downto 0);
        PC_New     : in  std_logic_vector(31 downto 0);
        selector   : in  std_logic;
        Predictor  : in  std_logic;
        muxOut     : out std_logic_vector(31 downto 0);
        RST        : out std_logic
    );
end entity Mux_Predict;

architecture Behavioral of Mux_Predict is
begin
    process(PC_Current, PC_Old, PC_New, selector, Predictor)
    begin
        if selector = '0' then
            if Predictor = '0' then
                muxOut <= PC_Current;  -- 00
                RST <= '1';
            else
                muxOut <= std_logic_vector(unsigned(PC_Old) + 4); -- 10  PC_Old + 4
                RST <= '0';
            end if;
        else
            if Predictor = '0' then
                muxOut <= PC_New;      -- 01
                RST <= '0';
            else
                muxOut <= PC_Current;  -- 11
                RST <= '1';
            end if;
        end if;
    end process;
end architecture Behavioral;