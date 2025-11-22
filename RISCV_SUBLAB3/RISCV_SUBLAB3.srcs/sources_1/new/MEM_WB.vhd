----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/22/2025 09:50:03 AM
-- Design Name: 
-- Module Name: MEM_WB - Behavioral
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

entity MEM_WB is
    port (
        clk             : in  std_logic;
        rst             : in  std_logic;
        enable          : in  std_logic;

        -- Inputs from MEM stage
        mem_data_mem_in     : in  std_logic_vector(31 downto 0); -- loaded data
        ALU_result_mem_in   : in  std_logic_vector(31 downto 0);
        rd_mem_in           : in  std_logic_vector(4 downto 0);

        reg_write_mem_in    : in  std_logic;
        mem_to_reg_mem_in   : in  std_logic;

        -- Outputs to WB stage
        mem_data_wb_out     : out std_logic_vector(31 downto 0);
        ALU_result_wb_out   : out std_logic_vector(31 downto 0);
        rd_wb_out           : out std_logic_vector(4 downto 0);

        reg_write_wb_out    : out std_logic;
        mem_to_reg_wb_out   : out std_logic
    );
end MEM_WB;

architecture Behavioral of MEM_WB is

begin

    process(clk)
    begin
        if rising_edge(clk) then

            if rst = '0' then
                mem_data_wb_out   <= (others => '0');
                ALU_result_wb_out <= (others => '0');
                rd_wb_out         <= (others => '0');

                reg_write_wb_out  <= '0';
                mem_to_reg_wb_out <= '0';

            else
                if enable = '1' then
                    mem_data_wb_out   <= mem_data_mem_in;
                    ALU_result_wb_out <= ALU_result_mem_in;
                    rd_wb_out         <= rd_mem_in;

                    reg_write_wb_out  <= reg_write_mem_in;
                    mem_to_reg_wb_out <= mem_to_reg_mem_in;
                end if;
            end if;

        end if;
    end process;


end Behavioral;
