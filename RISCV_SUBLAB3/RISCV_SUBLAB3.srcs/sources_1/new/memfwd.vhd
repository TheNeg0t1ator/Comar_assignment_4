----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/10/2025 08:04:05 PM
-- Design Name: 
-- Module Name: memfwd - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity memfwd is
  Port (
    selector1: out  std_logic_vector (1 downto 0);
    selector2: out  std_logic_vector (1 downto 0);
    ex_source_reg1: in  std_logic_vector (4 downto 0);
    ex_source_reg2: in  std_logic_vector (4 downto 0);
    mem_rd: in  std_logic_vector (4 downto 0);
    mux_sellwb: in  std_logic_vector (2 downto 0)



   );
end memfwd;

architecture Behavioral of memfwd is

begin

process(ex_source_reg1, ex_source_reg2, mem_rd, mux_sellwb)
begin
    -- lb is 000
    --

end process;

end Behavioral;
