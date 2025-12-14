library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity multiplier is
    generic(size: INTEGER := 32);
    port (
        operator1 : in  std_logic_vector(size-1 downto 0);
        operator2 : in  std_logic_vector(size-1 downto 0);
        product   : out std_logic_vector(2*size-1 downto 0)
    );
end entity multiplier;

architecture arch_multiplier of multiplier is

    signal shiftNumb : std_logic_vector(4 downto 0);
    signal shift1l, shift2l, shift4l, shift8l, shift16l : std_logic_vector(31 downto 0);
    signal partial : std_logic_vector(63 downto 0);

begin

    process(operator1, operator2)
        variable op1   : unsigned(31 downto 0);
        variable op2   : unsigned(31 downto 0);
        variable result_var : unsigned(63 downto 0);
        variable temp_shift : unsigned(63 downto 0);
    begin
        op1 := unsigned(operator1);
        op2 := unsigned(operator2);
        result_var := (others => '0');

        -- Loop over each bit of operator2
        for i in 0 to 31 loop
            if op2(i) = '1' then
                temp_shift := shift_left(resize(op1, 64), i);
                result_var := result_var + temp_shift;
            end if;
        end loop;

        product <= std_logic_vector(result_var);
    end process;

end architecture arch_multiplier;