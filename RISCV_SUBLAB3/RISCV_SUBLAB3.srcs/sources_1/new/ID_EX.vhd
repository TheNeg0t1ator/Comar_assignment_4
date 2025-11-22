----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/22/2025 09:46:31 AM
-- Design Name: 
-- Module Name: ID_EX - Behavioral
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

entity ID_EX is
port (
        -- Inputs from ID stage
        instruction_id_in   : in std_logic_vector(31 downto 0);
        PC_id_in            : in std_logic_vector(31 downto 0);
        regData1_id_in      : in std_logic_vector(31 downto 0);
        regData2_id_in      : in std_logic_vector(31 downto 0);
        immediate_id_in     : in std_logic_vector(31 downto 0);

        ALUOp_id_in         : in std_logic_vector(2 downto 0);
        ALUSrc_id_in        : in std_logic;
        Branch_id_in        : in std_logic_vector(2 downto 0);
        MemWrite_id_in      : in std_logic;
        Jump_id_in          : in std_logic;
        WriteReg_id_in      : in std_logic;
        ToRegister_id_in    : in std_logic_vector(2 downto 0);
        StoreSel_id_in      : in std_logic;

        clk                 : in std_logic;
        rst                 : in std_logic;
        enable              : in std_logic;

        -- Outputs to EX stage
        instruction_ex_out  : out std_logic_vector(31 downto 0);
        PC_ex_out           : out std_logic_vector(31 downto 0);
        regData1_ex_out     : out std_logic_vector(31 downto 0);
        regData2_ex_out     : out std_logic_vector(31 downto 0);
        immediate_ex_out    : out std_logic_vector(31 downto 0);

        ALUOp_ex_out        : out std_logic_vector(2 downto 0);
        ALUSrc_ex_out       : out std_logic;
        Branch_ex_out       : out std_logic_vector(2 downto 0);
        MemWrite_ex_out     : out std_logic;
        Jump_ex_out         : out std_logic;
        WriteReg_ex_out     : out std_logic;
        ToRegister_ex_out   : out std_logic_vector(2 downto 0);
        StoreSel_ex_out     : out std_logic
    );
end ID_EX;

architecture Behavioral of ID_EX is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '0' then
                -- RESET all signals (flush pipeline)
                instruction_ex_out <= (others => '0');
                PC_ex_out          <= (others => '0');
                regData1_ex_out    <= (others => '0');
                regData2_ex_out    <= (others => '0');
                immediate_ex_out   <= (others => '0');

                ALUOp_ex_out       <= (others => '0');
                ALUSrc_ex_out      <= '0';
                Branch_ex_out      <= (others => '0');
                MemWrite_ex_out    <= '0';
                Jump_ex_out        <= '0';
                WriteReg_ex_out    <= '0';
                ToRegister_ex_out  <= (others => '0');
                StoreSel_ex_out    <= '0';

            else
                if enable = '1' then
                    -- Data and control signals forwarded to EX stage
                    instruction_ex_out <= instruction_id_in;
                    PC_ex_out          <= PC_id_in;
                    regData1_ex_out    <= regData1_id_in;
                    regData2_ex_out    <= regData2_id_in;
                    immediate_ex_out   <= immediate_id_in;

                    ALUOp_ex_out       <= ALUOp_id_in;
                    ALUSrc_ex_out      <= ALUSrc_id_in;
                    Branch_ex_out      <= Branch_id_in;
                    MemWrite_ex_out    <= MemWrite_id_in;
                    Jump_ex_out        <= Jump_id_in;
                    WriteReg_ex_out    <= WriteReg_id_in;
                    ToRegister_ex_out  <= ToRegister_id_in;
                    StoreSel_ex_out    <= StoreSel_id_in;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
