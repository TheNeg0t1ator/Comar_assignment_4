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
        clk                         : in  std_logic;
        rst                         : in  std_logic;
        enable                      : in  std_logic;
        -- Inputs from EX stage
            ALU_result_ex_in        : in std_logic_vector(31 downto 0); -- ALU     (MUX0)& (RAM ADDRESS)
        -- RAM
            mem_write_en_ex_in      : in  std_logic;
            mem_write_data_ex_in    : in std_logic_vector(31 downto 0);
        --MEM_WB
            mux_sell_ex_in          : in std_logic_vector(2 downto 0);
            pc_ex_in                : in std_logic_vector(31 downto 0); -- ALU     (MUX3&MUX5)
            MUL_result_ex_in        : in std_logic_vector(63 downto 0); -- ALU     (MUX6&MUX7)
            rd_ex_in                : in std_logic_vector(4 downto 0);
            reg_write_ex_in         : in std_logic;

        -- Outputs to MEM stage
            ALU_result_ex_out       : out std_logic_vector(31 downto 0); -- ALU     (MUX0)& (RAM ADDRESS)
        -- RAM
            mem_write_en_ex_out     : out std_logic;
            mem_write_data_ex_out   : out std_logic_vector(31 downto 0);
        --MEM_WB
            mux_sell_ex_out         : out std_logic_vector(2 downto 0);
            pc_ex_out               : out std_logic_vector(31 downto 0); -- ALU     (MUX3&MUX5)
            MUL_result_ex_out       : out std_logic_vector(63 downto 0); -- ALU     (MUX6&MUX7) 
            rd_ex_out               : out std_logic_vector(4 downto 0);
            reg_write_ex_out        : out std_logic
    );
end EX_MEM;

architecture Behavioral of EX_MEM is
begin
    Process(clk)
        begin
            if rising_edge(clk) then
                if rst = '0' then
                -- Outputs to MEM stage
                    ALU_result_ex_out       <= (others => '0');
                -- RAM
                    mem_write_en_ex_out     <= '0';
                    mem_write_data_ex_out   <= (others => '0');
                --MEM_WB
                    mux_sell_ex_out         <= (others => '0');
                    pc_ex_out               <= (others => '0');
                    MUL_result_ex_out       <= (others => '0');
                    rd_ex_out               <= (others => '0');
                    reg_write_ex_out        <= '0';
                else
                if enable = '1' then
                -- Outputs to MEM stage
                    ALU_result_ex_out       <= ALU_result_ex_in;
                -- RAM
                    mem_write_en_ex_out     <= mem_write_en_ex_in;
                    mem_write_data_ex_out   <= mem_write_data_ex_in;
                --MEM_WB
                    mux_sell_ex_out         <= mux_sell_ex_in;
                    pc_ex_out               <= pc_ex_in;
                    MUL_result_ex_out       <= MUL_result_ex_in;
                    rd_ex_out               <= rd_ex_in;
                    reg_write_ex_out        <= reg_write_ex_in;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
