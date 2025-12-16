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
            clk                         : in std_logic;
            rst                         : in std_logic;
            enable                      : in std_logic;
            -- inputs to EX stage
            immediate_id_in             : in std_logic_vector(31 downto 0);
            --MUX0 
            ALUSrc_id_in                : in std_logic;
            --MUX1
            StoreSel_id_in              : in std_logic;
            --MUX2
            Jump_id_in                  : in std_logic;
            --Branch-Control
            Branch_id_in                : in std_logic_vector(2 downto 0);
            --ALU
            ALUOp_id_in                 : in std_logic_vector(2 downto 0);
            regData1_id_in              : in std_logic_vector(31 downto 0);
            regData2_id_in              : in std_logic_vector(31 downto 0);
            --EX-MEM
            mem_write_en_id_in          : in  std_logic;
            mux_sell_id_in              : in std_logic_vector(2 downto 0);
            pc_id_in                    : in std_logic_vector(31 downto 0); -- ALU     (MUX3&MUX5)
            rd_id_in                    : in std_logic_vector(4 downto 0);
            reg_write_id_in             : in std_logic;
            IsValidRD_id_in             : in std_logic;
            --memfwd
            source_reg_id_in1           : in std_logic_vector(4 downto 0);
            source_reg_id_in2           : in std_logic_vector(4 downto 0);
            Branch_prediction_in        :in std_logic; 
            --matrixmul
            MatrixMul_ReturnAdress_in   : in std_logic_vector(31 downto 0);
            MatrixMul_enable_in         : in std_logic;
            
            -- Outputs to EX stage
            immediate_id_out            : out std_logic_vector(31 downto 0);
            --MUX0 
            ALUSrc_id_out               : out std_logic;
            --MUX1
            StoreSel_id_out             : out std_logic;
            --MUX2
            Jump_id_out                 : out std_logic;
            --Branch-Control
            Branch_id_out               : out std_logic_vector(2 downto 0);
            --ALU
            ALUOp_id_out                : out std_logic_vector(2 downto 0);
            regData1_id_out             : out std_logic_vector(31 downto 0);
            regData2_id_out             : out std_logic_vector(31 downto 0);
            --EX-MEM
            mem_write_en_id_out         : out  std_logic;
            mux_sell_id_out             : out std_logic_vector(2 downto 0);
            pc_id_out                   : out std_logic_vector(31 downto 0); -- ALU     (MUX3&MUX5)
            rd_id_out                   : out std_logic_vector(4 downto 0);
            reg_write_id_out            : out std_logic;
            IsValidRD_id_out            : out std_logic;
            --memfwd
            source_reg_id_out1          : out std_logic_vector(4 downto 0);
            source_reg_id_out2          : out std_logic_vector(4 downto 0);
            Branch_prediction_out       :out std_logic ;
            ---matrixmul
            MatrixMul_ReturnAdress_out  : out std_logic_vector(31 downto 0);
            MatrixMul_enable_out        : out std_logic
    );
end ID_EX;

architecture Behavioral of ID_EX is
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if rst = '0' then
                -- RESET all signals (flush pipeline)
                immediate_id_out        <= (others => '0');
                --MUX0 
                ALUSrc_id_out           <= '0';
                --MUX1
                StoreSel_id_out         <= '0';
                --MUX2
                Jump_id_out             <= '0';
                --Branch-Control
                Branch_id_out           <= (others => '0');
                --ALU
                ALUOp_id_out            <= (others => '0');
                regData1_id_out         <= (others => '0');
                regData2_id_out         <= (others => '0');
                --EX-MEM
                mem_write_en_id_out     <= '0';
                mux_sell_id_out         <= (others => '0');
                pc_id_out               <= (others => '0');
                rd_id_out               <= (others => '0');
                reg_write_id_out        <= '0';
                IsValidRD_id_out        <= '0';
                --memfwd
                source_reg_id_out1      <= (others => '0');
                source_reg_id_out2      <= (others => '0');
                Branch_prediction_out <= '0';
                --matrixmul
                MatrixMul_ReturnAdress_out  <= (others => '0');
                MatrixMul_enable_out        <= '0';

            else
                if enable = '1' then
                    immediate_id_out        <= immediate_id_in;
                    --MUX0 
                    ALUSrc_id_out           <= ALUSrc_id_in;
                    --MUX1
                    StoreSel_id_out         <= StoreSel_id_in;
                    --MUX2
                    Jump_id_out             <= Jump_id_in;
                    --Branch-Control
                    Branch_id_out           <= Branch_id_in;
                    --ALU
                    ALUOp_id_out            <= ALUOp_id_in;
                    regData1_id_out         <= regData1_id_in;
                    regData2_id_out         <= regData2_id_in;
                    --EX-MEM
                    mem_write_en_id_out     <= mem_write_en_id_in;
                    mux_sell_id_out         <= mux_sell_id_in;
                    pc_id_out               <= pc_id_in;
                    rd_id_out               <= rd_id_in;
                    reg_write_id_out        <= reg_write_id_in;
                    IsValidRD_id_out        <= IsValidRD_id_in;
                    --memfwd
                    source_reg_id_out1      <= source_reg_id_in1;
                    source_reg_id_out2      <= source_reg_id_in2;
                    Branch_prediction_out  <= Branch_prediction_in;
                    --matrixmul
                    MatrixMul_ReturnAdress_out  <= MatrixMul_ReturnAdress_in;
                    MatrixMul_enable_out        <= MatrixMul_enable_in;
                end if;
            end if;
        end if;
    end process;
end Behavioral;
