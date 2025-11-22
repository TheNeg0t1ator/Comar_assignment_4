----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/22/2025 09:48:25 AM
-- Design Name: 
-- Module Name: EX_MEM - Behavioral
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

entity EX_MEM is
port (
        clk             : in  std_logic;
        rst             : in  std_logic;
        enable          : in  std_logic;

        -- Inputs from EX stage
        ALU_result_ex_in    : in  std_logic_vector(31 downto 0);
        rs2_val_ex_in       : in  std_logic_vector(31 downto 0); -- store data
        rd_ex_in            : in  std_logic_vector(4 downto 0);

        mem_read_ex_in      : in  std_logic;
        mem_write_ex_in     : in  std_logic;
        reg_write_ex_in     : in  std_logic;
        mem_to_reg_ex_in    : in  std_logic;

        -- Outputs to MEM stage
        ALU_result_mem_out  : out std_logic_vector(31 downto 0);
        rs2_val_mem_out     : out std_logic_vector(31 downto 0);
        rd_mem_out          : out std_logic_vector(4 downto 0);

        mem_read_mem_out    : out std_logic;
        mem_write_mem_out   : out std_logic;
        reg_write_mem_out   : out std_logic;
        mem_to_reg_mem_out  : out std_logic
    );
end EX_MEM;

architecture Behavioral of EX_MEM is
begin
    Process(clk)
        begin
            if rising_edge(clk) then
    
                if rst = '0' then
                    ALU_result_mem_out <= (others => '0');
                    rs2_val_mem_out    <= (others => '0');
                    rd_mem_out         <= (others => '0');
    
                    mem_read_mem_out   <= '0';
                    mem_write_mem_out  <= '0';
                    reg_write_mem_out  <= '0';
            mem_to_reg_mem_out <= '0';
            else
                if enable = '1' then
                    ALU_result_mem_out <= ALU_result_ex_in;
                    rs2_val_mem_out    <= rs2_val_ex_in;
                    rd_mem_out         <= rd_ex_in;
    
                    mem_read_mem_out   <= mem_read_ex_in;
                    mem_write_mem_out  <= mem_write_ex_in;
                    reg_write_mem_out  <= reg_write_ex_in;
                    mem_to_reg_mem_out <= mem_to_reg_ex_in;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
