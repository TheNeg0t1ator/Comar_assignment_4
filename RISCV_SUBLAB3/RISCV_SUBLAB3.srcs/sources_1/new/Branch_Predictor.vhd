----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/13/2025 07:17:33 PM
-- Design Name: 
-- Module Name: Branch_Predictor - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Branch_Predictor is
    Port ( 
        Prediction_in   : in  std_logic;
        IF_in           : in  std_logic_vector(31 downto 0);
        Current_PC      : in  std_logic_vector(31 downto 0);
        New_PC          : out std_logic_vector(31 downto 0);
        Prediction_out  : out std_logic
    );
end Branch_Predictor;

architecture Behavioral of Branch_Predictor is

    signal is_branch : std_logic;
    signal imm       : signed(31 downto 0);

begin

    -- Detect RISC-V branch instruction (opcode = 1100011)
    is_branch <= '1' when IF_in(6 downto 0) = "1100011" else '0';

    -- Extract and sign-extend B-type immediate
    imm <= resize(
              signed(
                  IF_in(31) &
                  IF_in(7)  &
                  IF_in(30 downto 25) &
                  IF_in(11 downto 8) &
                  '0'
              ), 32);

    process(is_branch, Prediction_in, Current_PC, imm)
    begin
        if is_branch = '1' then
            Prediction_out <= Prediction_in;

            if Prediction_in = '1' then
                -- Take branch
                New_PC <= std_logic_vector(signed(Current_PC) + imm);
            else
                -- Not taken
                New_PC <= std_logic_vector(unsigned(Current_PC) + 4);
            end if;

        else
            -- Not a branch instruction
            Prediction_out <= '0';
            New_PC <= std_logic_vector(unsigned(Current_PC) + 4);
        end if;
    end process;
end Behavioral;
