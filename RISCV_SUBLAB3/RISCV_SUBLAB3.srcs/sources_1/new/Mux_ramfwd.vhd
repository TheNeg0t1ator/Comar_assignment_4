----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/10/2025 05:27:47 PM
-- Design Name: 
-- Module Name: Mux_ramfwd - Behavioral
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

entity Mux_ramfwd is
Port (
  SourceReg:   in  std_logic_vector (31 downto 0);
  MEM_LOAD_WORD:   in  std_logic_vector (31 downto 0);
  Output:   out std_logic_vector (31 downto 0);
  selector: in  std_logic_vector (1 downto 0)
  
  );



end Mux_ramfwd;

architecture Behavioral of Mux_ramfwd is

signal MEM_LB:    std_logic_vector (31 downto 0);
signal MEM_signo: std_logic;

begin

with selector select
    Output <= SourceReg when "00",
              MEM_LOAD_WORD when "01",
              MEM_LB when "10",
              (others => '0') when others;

MEM_signo   <= MEM_LOAD_WORD(7);
MEM_LB      <= (MEM_LOAD_WORD or X"FFFFFF00") when MEM_signo = '1' else (MEM_LOAD_WORD and X"000000FF");  

end Behavioral;
