--the ram is simplified to some register, just like the ROM this is to make the design easier
--single port RAM of 16 local * 8 bits (16 registers of 8 bits)
--no chip select and no read enable cause the output goes to a mux, not a bus
--0H to 7H for output data (0H-3H and 4H-7H 32 bits register) 2reg 32 bits
--8H to FH for input operations (8H-BH and CH-FH for inputs) 2reg 32 bits

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Data_Mem is
    port (
        clk     :in std_logic;
        writeEn :in std_logic;
        Address :in std_logic_vector(7 downto 0);
        dataIn  :in std_logic_vector(31 downto 0);
        dataOut :out std_logic_vector(31 downto 0);

        --matrix mul data IO
        Vaddr_1 : in std_logic_vector(7 downto 0);
        Vaddr_2 : in std_logic_vector(7 downto 0);
        Vdata_1 : out std_logic_vector(159 downto 0);
        Vdata_2 : out std_logic_vector(159 downto 0)

    );
end entity Data_Mem;

architecture arch_Data_Mem of Data_Mem is

    type RAM is array (255 downto 0) of std_logic_vector(7 downto 0);
    signal MEM : RAM := (others => (others => '0'));
begin
    process(clk)
    begin
    if rising_edge(clk) then -- maybe test falling edge if the matrix mul does not write correctly
        if (writeEn = '1') then
            MEM(conv_integer(Address))   <= dataIn(7 downto 0);
            MEM(conv_integer(Address+1)) <= dataIn(15 downto 8);
            MEM(conv_integer(Address+2)) <= dataIn(23 downto 16);
            MEM(conv_integer(Address+3)) <= dataIn(31 downto 24);
        end if;
    dataOut <= MEM(conv_integer(Address+3)) & MEM(conv_integer(Address+2)) &
               MEM(conv_integer(Address+1)) & MEM(conv_integer(Address)); 

    Vdata_1 <=  MEM(conv_integer(Vaddr_1)+19) & MEM(conv_integer(Vaddr_1)+18) & MEM(conv_integer(Vaddr_1)+17) & MEM(conv_integer(Vaddr_1)+16) &
                MEM(conv_integer(Vaddr_1)+15) & MEM(conv_integer(Vaddr_1)+14) & MEM(conv_integer(Vaddr_1)+13) & MEM(conv_integer(Vaddr_1)+12) &
                MEM(conv_integer(Vaddr_1)+11) & MEM(conv_integer(Vaddr_1)+10) & MEM(conv_integer(Vaddr_1)+9)  & MEM(conv_integer(Vaddr_1)+8)  &
                MEM(conv_integer(Vaddr_1)+7)  & MEM(conv_integer(Vaddr_1)+6)  & MEM(conv_integer(Vaddr_1)+5)  & MEM(conv_integer(Vaddr_1)+4  ) &
                MEM(conv_integer(Vaddr_1)+3)  & MEM(conv_integer(Vaddr_1)+2)  & MEM(conv_integer(Vaddr_1)+1)  & MEM(conv_integer(Vaddr_1)    );
    
    Vdata_2 <=  MEM(conv_integer(Vaddr_2)+19) & MEM(conv_integer(Vaddr_2)+18) & MEM(conv_integer(Vaddr_2)+17) & MEM(conv_integer(Vaddr_2)+16) &
                MEM(conv_integer(Vaddr_2)+15) & MEM(conv_integer(Vaddr_2)+14) & MEM(conv_integer(Vaddr_2)+13) & MEM(conv_integer(Vaddr_2)+12) &
                MEM(conv_integer(Vaddr_2)+11) & MEM(conv_integer(Vaddr_2)+10) & MEM(conv_integer(Vaddr_2)+9)  & MEM(conv_integer(Vaddr_2)+8)  &
                MEM(conv_integer(Vaddr_2)+7)  & MEM(conv_integer(Vaddr_2)+6)  & MEM(conv_integer(Vaddr_2)+5)  & MEM(conv_integer(Vaddr_2)+4  ) &
                MEM(conv_integer(Vaddr_2)+3)  & MEM(conv_integer(Vaddr_2)+2)  & MEM(conv_integer(Vaddr_2)+1)  & MEM(conv_integer(Vaddr_2)    );        
    end if;
    end process;
    
    

end arch_Data_Mem ; -- arch_Data_Mem