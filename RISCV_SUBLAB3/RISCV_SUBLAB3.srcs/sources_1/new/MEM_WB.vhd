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
        -- MUX
            mux_sell_wb_in     : in std_logic_vector(2 downto 0);
            ALU_result_wb_in   : in std_logic_vector(31 downto 0); -- ALU     (MUX0)
            mem_data_wb_in     : in std_logic_vector(31 downto 0); -- LB LW   (MUX1&MUX2)
            pc_wb_in           : in std_logic_vector(31 downto 0); -- ALU     (MUX3&MUX5)
            MUL_result_wb_in   : in std_logic_vector(63 downto 0); -- ALU     (MUX6&MUX7)
        -- Writing to register File 
            rd_wb_in           : in std_logic_vector(4 downto 0);
            reg_write_wb_in    : in std_logic;
            IsValidRD_mem_in        : in std_logic;

        -- Outputs to WB stage
        -- MUX
        mux_sell_wb_out     : out std_logic_vector(2 downto 0);
        ALU_result_wb_out   : out std_logic_vector(31 downto 0); -- ALU     (MUX0)
        mem_data_wb_out     : out std_logic_vector(31 downto 0); -- LB LW   (MUX1&MUX2)
        pc_wb_out           : out std_logic_vector(31 downto 0); -- ALU     (MUX3&MUX5)
        MUL_result_wb_out   : out std_logic_vector(63 downto 0); -- ALU     (MUX6&MUX7)
        
        
        -- Writing to register File 
        rd_wb_out           : out std_logic_vector(4 downto 0);
        reg_write_wb_out    : out std_logic;
        --wb
        IsValidRD_wb_out        : out std_logic
    );
end MEM_WB;

architecture Behavioral of MEM_WB is

begin

    process(clk)
    begin
        if Falling_edge(clk) then

            if rst = '0' then
                mux_sell_wb_out     <= (others => '0');
                ALU_result_wb_out   <= (others => '0');
                mem_data_wb_out     <= (others => '0');
                pc_wb_out           <= (others => '0');
                MUL_result_wb_out   <= (others => '0');
                rd_wb_out           <= (others => '0');
                reg_write_wb_out    <= '0';
                IsValidRD_wb_out    <= '0';

            else
                if enable = '1' then
                    mux_sell_wb_out     <=  mux_sell_wb_in;
                    ALU_result_wb_out   <= ALU_result_wb_in;
                    mem_data_wb_out     <= mem_data_wb_in;
                    pc_wb_out           <= pc_wb_in;
                    MUL_result_wb_out   <= MUL_result_wb_in;
                    rd_wb_out           <= rd_wb_in;
                    reg_write_wb_out    <= reg_write_wb_in;
                    IsValidRD_wb_out    <= IsValidRD_mem_in;

                end if;
            end if;

        end if;
    end process;
end Behavioral;
