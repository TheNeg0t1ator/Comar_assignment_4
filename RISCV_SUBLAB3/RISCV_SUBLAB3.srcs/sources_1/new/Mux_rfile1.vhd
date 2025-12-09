----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.11.2025 11:38:26
-- Design Name: 
-- Module Name: Mux_rfile1 - Behavioral
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

entity Mux_rfile1 is
  Port ( 
    rdata_regfile   : in  std_logic_vector(31 downto 0);
    EX_ALU_RESULT   : in  std_logic_vector(31 downto 0);
    EX_MUL_RESULT   : in  std_logic_vector(31 downto 0);
    EX_MULH_RESULT  : in  std_logic_vector(31 downto 0);
    MEM_ALU_RESULT  : in  std_logic_vector(31 downto 0);
    MEM_MUL_RESULT  : in  std_logic_vector(31 downto 0);
    MEM_MULH_RESULT : in  std_logic_vector(31 downto 0);
    MEM_LOAD_WORD   : in  std_logic_vector(31 downto 0);
    WB_ALU_RESULT   : in  std_logic_vector(31 downto 0);
    WB_MUL_RESULT   : in  std_logic_vector(31 downto 0);
    WB_MULH_RESULT  : in  std_logic_vector(31 downto 0);
    WB_LOAD_WORD    : in  std_logic_vector(31 downto 0);
    Rdata_id_in     : out std_logic_vector(31 downto 0);
    selector        : in  std_logic_vector(3 downto 0)
  );
end Mux_rfile1;

architecture Behavioral of Mux_rfile1 is
signal MEM_LB, WB_LB: std_logic_vector(31 downto 0);
signal MEM_signo, WB_signo: std_logic;

begin
  process(rdata_regfile, EX_ALU_RESULT, EX_MUL_RESULT, EX_MULH_RESULT,
          MEM_ALU_RESULT, MEM_MUL_RESULT, MEM_MULH_RESULT, selector)
  begin
    case selector is
      when "0000" => Rdata_id_in <= rdata_regfile;
      when "0001" => Rdata_id_in <= EX_ALU_RESULT;
      when "0010" => Rdata_id_in <= EX_MUL_RESULT;
      when "0011" => Rdata_id_in <= EX_MULH_RESULT;
      when "0100" => Rdata_id_in <= MEM_ALU_RESULT;
      when "0101" => Rdata_id_in <= MEM_MUL_RESULT;
      when "0110" => Rdata_id_in <= MEM_MULH_RESULT;
      --when "0111" => Rdata_id_in <= WB_ALU_RESULT;
      --when "1001" => Rdata_id_in <= WB_MUL_RESULT;
      --when "1010" => Rdata_id_in <= WB_MULH_RESULT;
      when "1011" => Rdata_id_in <= MEM_LOAD_WORD;
      --when "1100" => Rdata_id_in <= WB_LOAD_WORD;
      when "1101" => Rdata_id_in <= MEM_LB ;
      --when "1110" => Rdata_id_in <= WB_LB;
      when others => Rdata_id_in <= rdata_regfile;
    end case;
  end process;
  --sign extension
  MEM_signo   <= MEM_LOAD_WORD(7);
  MEM_LB      <= (MEM_LOAD_WORD or X"FFFFFF00") when MEM_signo = '1' else (MEM_LOAD_WORD and X"000000FF");    
  WB_signo    <= WB_LOAD_WORD(7);
  WB_LB       <= (WB_LOAD_WORD or X"FFFFFF00") when WB_signo = '1' else (WB_LOAD_WORD and X"000000FF");   
end Behavioral;

