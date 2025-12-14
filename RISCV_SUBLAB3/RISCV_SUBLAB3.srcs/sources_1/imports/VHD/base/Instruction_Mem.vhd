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
X"01", X"F2", X"18", X"33",
X"01", X"60", X"05", X"B3",
X"01", X"40", X"06", X"B3",
X"01", X"50", X"07", X"33",
X"01", X"50", X"07", X"B3",
X"01", X"60", X"06", X"33",
X"01", X"06", X"85", X"33",
X"00", X"06", X"82", X"93",
X"00", X"10", X"0D", X"93",
X"00", X"F0", X"03", X"33",
X"00", X"00", X"04", X"93",
X"00", X"02", X"A3", X"83",
X"00", X"03", X"24", X"03",
X"02", X"83", X"83", X"B3",
X"00", X"74", X"84", X"B3",
X"00", X"42", X"A3", X"83",
X"00", X"43", X"24", X"03",
X"02", X"83", X"83", X"B3",
X"00", X"74", X"84", X"B3",
X"00", X"82", X"A3", X"83",
X"00", X"83", X"24", X"03",
X"02", X"83", X"83", X"B3",
X"00", X"74", X"84", X"B3",
X"00", X"C2", X"A3", X"83",
X"00", X"C3", X"24", X"03",
X"02", X"83", X"83", X"B3",
X"00", X"74", X"84", X"B3",
X"01", X"02", X"A3", X"83",
X"01", X"03", X"24", X"03",
X"02", X"83", X"83", X"B3",
X"00", X"74", X"84", X"B3",
X"00", X"95", X"A0", X"23",
X"00", X"45", X"85", X"93",
X"01", X"43", X"03", X"13",
X"FA", X"66", X"10", X"E3",
X"01", X"06", X"86", X"B3",
X"01", X"06", X"85", X"33",
X"00", X"06", X"82", X"93",
X"F8", X"57", X"16", X"E3",
X"00", X"00", X"0D", X"93",

    others => X"00"
    );
begin
    instruction <= ROM(conv_integer(Address)) & ROM(conv_integer(Address + 1)) &
                   ROM(conv_integer(Address + 2)) & ROM(conv_integer(Address + 3)); 
    --instruction <= ROM(conv_integer(Address + 3)) & ROM(conv_integer(Address + 2))
      --           & ROM(conv_integer(Address + 1)) & ROM(conv_integer(Address));
 

end architecture arch_Instruction_Mem;
 