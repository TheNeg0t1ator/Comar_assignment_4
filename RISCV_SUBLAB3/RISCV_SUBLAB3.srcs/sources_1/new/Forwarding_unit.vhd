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
        Regfile_Selector1, Regfile_Selector2    : out std_logic_vector(2 downto 0);
        Input_select_ex,Input_select_mem        : in std_logic_vector(2 downto 0);
        RD_ex, RD_mem                           : in std_logic_vector(4 downto 0);
        SourceReg1_id, SourceReg2_id            : in std_logic_vector(4 downto 0);
        Valid_rd_ex, Valid_rd_mem               : in std_logic
  );
end Forwarding_unit;

architecture Behavioral of Forwarding_unit is

begin

    process(Input_select_ex,Input_select_mem, RD_ex, RD_mem, SourceReg1_id, SourceReg2_id, Valid_rd_ex, Valid_rd_mem)
    begin
        -- Default values
        Regfile_Selector1 <= "000";
        Regfile_Selector2 <= "000";
    
        if (SourceReg1_id = RD_ex) and (SourceReg1_id /= "00000") and (Valid_rd_ex = '1') then -- Result from EX stage need, forward from ex to id
            case Input_select_ex is
                when "000" => Regfile_Selector1 <= "001";
                when "110" => Regfile_Selector1 <= "010";
                when "111" => Regfile_Selector1 <= "011";
                when others => Regfile_Selector1 <= "000";
            end case;
        elsif (SourceReg1_id = RD_mem) and (SourceReg1_id /= "00000") and (Valid_rd_mem = '1') then -- Result from MEM stage need, forward from mem to id
            case Input_select_mem is
                when "000" => Regfile_Selector1 <= "100";
                when "110" => Regfile_Selector1 <= "101";
                when "111" => Regfile_Selector1 <= "110";
                when others => Regfile_Selector1 <= "000";
            end case;
        end if;


        if (SourceReg2_id = RD_ex) and (SourceReg2_id /= "00000") and (Valid_rd_ex = '1') then -- Result from EX stage need, forward from ex to id
            case Input_select_ex is
                when "000" => Regfile_Selector2 <= "001";
                when "110" => Regfile_Selector2 <= "010";
                when "111" => Regfile_Selector2 <= "011";
                when others => Regfile_Selector2 <= "000";
            end case;
        elsif (SourceReg2_id = RD_mem) and (SourceReg2_id /= "00000") and (Valid_rd_mem = '1') then -- Result from MEM stage need, forward from mem to id
            case Input_select_mem is
                when "000" => Regfile_Selector2 <= "100";
                when "110" => Regfile_Selector2 <= "101";
                when "111" => Regfile_Selector2 <= "110";
                when others => Regfile_Selector2 <= "000";
            end case;
        end if;
        
    end process;


end Behavioral;
