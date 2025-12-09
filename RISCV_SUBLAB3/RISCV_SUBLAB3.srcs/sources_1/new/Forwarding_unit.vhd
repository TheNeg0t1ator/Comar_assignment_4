----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 30.11.2025 13:08:26
-- Design Name: 
-- Module Name: Forwarding_unit - Behavioral
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

entity Forwarding_unit is
    Port ( 
        Regfile_Selector1, Regfile_Selector2                    : out std_logic_vector(3 downto 0);
        Input_select_ex,Input_select_mem,Input_select_wb        : in std_logic_vector(2 downto 0);
        RD_ex, RD_mem, RD_wb                                    : in std_logic_vector(4 downto 0);
        SourceReg1_id, SourceReg2_id                            : in std_logic_vector(4 downto 0);
        Valid_rd_ex, Valid_rd_mem, Valid_rd_wb                  : in std_logic
  );
end Forwarding_unit;

architecture Behavioral of Forwarding_unit is

begin

    process(Input_select_ex,Input_select_mem, RD_ex, RD_mem, SourceReg1_id, SourceReg2_id, Valid_rd_ex, Valid_rd_mem)
    begin
        -- Default values
        Regfile_Selector1 <= "0000";
        Regfile_Selector2 <= "0000";
    
        if (SourceReg1_id = RD_ex) and (SourceReg1_id /= "00000") and (Valid_rd_ex = '1') then -- Result from EX stage need, forward from ex to id
            case Input_select_ex is
                when "000" => Regfile_Selector1 <= "0001"; --ALU
                when "110" => Regfile_Selector1 <= "0010"; --MUL
                when "111" => Regfile_Selector1 <= "0011"; --MULH
                when others => Regfile_Selector1 <= "0000";
            end case;
        elsif (SourceReg1_id = RD_mem) and (SourceReg1_id /= "00000") and (Valid_rd_mem = '1') then -- Result from MEM stage need, forward from mem to id
            case Input_select_mem is
                when "000" => Regfile_Selector1 <= "0100"; --ALU
                when "110" => Regfile_Selector1 <= "0101"; --MUL
                when "111" => Regfile_Selector1 <= "0110"; --MULH
                when "001" => Regfile_Selector1 <= "1101"; --LB
                when "010" => Regfile_Selector1 <= "1011"; --LW
                when others => Regfile_Selector1 <= "0000";
            end case;
        elsif (SourceReg1_id = RD_wb) and (SourceReg1_id /= "00000") and (Valid_rd_wb = '1') then -- Result from WB stage need, forward from WB to id
            case Input_select_wb is
                when "000" => Regfile_Selector1 <= "0111"; --ALU
                when "110" => Regfile_Selector1 <= "1001"; --MUL
                when "111" => Regfile_Selector1 <= "1010"; --MULH
                when "001" => Regfile_Selector1 <= "1110"; --LB
                when "010" => Regfile_Selector1 <= "1100"; --LW
                when others => Regfile_Selector1 <= "0000";
            end case;
        end if;


        if (SourceReg2_id = RD_ex) and (SourceReg2_id /= "00000") and (Valid_rd_ex = '1') then -- Result from EX stage need, forward from ex to id
            case Input_select_ex is
                when "000" => Regfile_Selector2 <= "0001"; --ALU
                when "110" => Regfile_Selector2 <= "0010"; --MUL
                when "111" => Regfile_Selector2 <= "0011"; --MULH
                when others => Regfile_Selector2 <= "0000";
            end case;
        elsif (SourceReg2_id = RD_mem) and (SourceReg2_id /= "00000") and (Valid_rd_mem = '1') then -- Result from MEM stage need, forward from mem to id
            case Input_select_mem is
                when "000" => Regfile_Selector2 <= "0100"; --ALU
                when "110" => Regfile_Selector2 <= "0101"; --MUL
                when "111" => Regfile_Selector2 <= "0110"; --MULH
                when "001" => Regfile_Selector1 <= "1101"; --LB
                when "010" => Regfile_Selector1 <= "1011"; --LW
                when others => Regfile_Selector2 <= "0000";
            end case;
        elsif (SourceReg2_id = RD_wb) and (SourceReg2_id /= "00000") and (Valid_rd_wb = '1') then -- Result from WB stage need, forward from WB to id
            case Input_select_wb is
                when "000" => Regfile_Selector1 <= "0111"; --ALU
                when "110" => Regfile_Selector1 <= "1001"; --MUL
                when "111" => Regfile_Selector1 <= "1010"; --MULH
                when "001" => Regfile_Selector1 <= "1110"; --LB
                when "010" => Regfile_Selector1 <= "1100"; --LW
                when others => Regfile_Selector1 <= "0000";
            end case;
        end if;
        
    end process;


end Behavioral;
