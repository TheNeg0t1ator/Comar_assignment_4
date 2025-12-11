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
    "00011010", "01000000", "00000010", "10010011", -- li t0, 420
    "00000000", "10100000", "00000100", "00010011", -- li s0, 10
    --"00000000", "00000000", "00000000", "00010011", -- nop
    --"00000000", "00000000", "00000000", "00010011", -- nop
    "00000000", "01010000", "00100000", "00100011", -- sw t0, 0(x0)
    "00000000", "10000010", "10000010", "10110011", -- add t0, t0, s0
    "00000000", "00000000", "00100010", "10000011", -- lw t0, 0(x0)
    --"00000000", "00000000", "00000000", "00010011", -- nop
    "00000000", "10000010", "10000010", "10110011", -- add t0, t0, s0
    
    -- Nfact(5)
    --"00000000", "01010000", "00000100", "00010011",
    --"00000000", "00010000", "00000100", "10010011",
    --"00000010", "10000100", "10000100", "10110011",
    --"11111111", "11110100", "00000100", "00010011",
    --"11111110", "10000000", "01001100", "11100011",
    others => X"00"
    );
begin
    instruction <= ROM(conv_integer(Address)) & ROM(conv_integer(Address + 1)) &
                   ROM(conv_integer(Address + 2)) & ROM(conv_integer(Address + 3)); 
    --instruction <= ROM(conv_integer(Address + 3)) & ROM(conv_integer(Address + 2))
      --           & ROM(conv_integer(Address + 1)) & ROM(conv_integer(Address));
 

end architecture arch_Instruction_Mem;
 