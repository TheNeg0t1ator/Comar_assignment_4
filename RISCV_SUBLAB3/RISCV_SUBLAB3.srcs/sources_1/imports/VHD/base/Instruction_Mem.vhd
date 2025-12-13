-- if you like to program your own code, just use following website to translate the instruction
-- https://luplab.gitlab.io/rvcodecjs/ 	 	  
-- this site DOES not work for branching!!

---- In this file the instruction are hardcoded
---- During the course it showed that this should be saved into SRAM, but to make it easier we hardcode it here

library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity Instruction_Mem is
    port (
        Address     :in std_logic_vector(15 downto 0);
        instruction :out std_logic_vector(31 downto 0) 
    );
end entity Instruction_Mem;

architecture arch_Instruction_Mem of Instruction_Mem is
    
    type ROM_ARRAY is array (0 to 65535) of std_logic_vector(7 downto 0);      --declaring size of memory. 128 elements of 32 bits
    constant ROM : ROM_ARRAY := (
    --X"10", X"00", X"03", X"17",
--X"00", X"03", X"03", X"13",
X"00", X"00", X"00", X"93",
X"01", X"40", X"02", X"13",
X"00", X"F0", X"02", X"93",
X"00", X"20", X"0F", X"93",
X"01", X"F0", X"91", X"33",
X"00", X"10", X"80", X"93",
X"00", X"61", X"01", X"B3",
X"00", X"11", X"A0", X"23",
X"FE", X"12", X"18", X"E3",
X"00", X"00", X"03", X"93",
X"01", X"F0", X"91", X"33",
X"00", X"10", X"80", X"93",
X"40", X"72", X"84", X"33",
X"00", X"13", X"83", X"93",
X"00", X"61", X"01", X"B3",
X"00", X"81", X"A0", X"23",
X"FE", X"72", X"94", X"E3",
X"00", X"04", X"84", X"93",
X"00", X"15", X"05", X"13",
X"00", X"00", X"0A", X"13",
X"05", X"00", X"0A", X"93",
X"08", X"C0", X"0B", X"13",
X"00", X"50", X"02", X"13",
X"00", X"30", X"02", X"93",
X"00", X"40", X"05", X"93",
X"00", X"00", X"0B", X"93",
X"00", X"00", X"0C", X"13",
X"00", X"00", X"0C", X"93",
X"00", X"00", X"05", X"13",
X"00", X"6A", X"0A", X"33",
X"00", X"6A", X"8A", X"B3",
X"00", X"6B", X"0B", X"33",
X"00", X"10", X"0D", X"93",
X"00", X"50", X"0E", X"93",
X"00", X"30", X"0F", X"13",
X"00", X"00", X"0C", X"93",
X"00", X"00", X"0C", X"13",
X"00", X"00", X"0B", X"93",
X"00", X"00", X"05", X"13",
X"03", X"DC", X"82", X"B3",
X"01", X"72", X"82", X"B3",
X"00", X"22", X"92", X"93",
X"00", X"5A", X"02", X"B3",
X"00", X"02", X"A3", X"03",
X"03", X"DC", X"03", X"B3",
X"01", X"73", X"83", X"B3",
X"00", X"23", X"93", X"93",
X"00", X"7A", X"83", X"B3",
X"00", X"03", X"AE", X"03",
X"03", X"C3", X"0F", X"B3",
X"01", X"F5", X"05", X"33",
X"00", X"1B", X"8B", X"93",
X"FD", X"DB", X"96", X"E3",
X"03", X"EC", X"82", X"B3",
X"01", X"82", X"82", X"B3",
X"00", X"22", X"92", X"93",
X"00", X"5B", X"02", X"B3",
X"00", X"A2", X"A0", X"23",
X"00", X"1C", X"0C", X"13",
X"FB", X"EC", X"14", X"E3",
X"00", X"1C", X"8C", X"93",
X"00", X"40", X"0F", X"93",
X"F9", X"FC", X"9C", X"E3",
X"00", X"00", X"0D", X"93",
    others => X"00"
    );
begin
    instruction <= ROM(conv_integer(Address)) & ROM(conv_integer(Address + 1)) &
                   ROM(conv_integer(Address + 2)) & ROM(conv_integer(Address + 3)); 
    --instruction <= ROM(conv_integer(Address + 3)) & ROM(conv_integer(Address + 2))
      --           & ROM(conv_integer(Address + 1)) & ROM(conv_integer(Address));
 

end architecture arch_Instruction_Mem;
 