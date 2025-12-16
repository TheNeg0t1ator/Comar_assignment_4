----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/15/2025 07:17:51 PM
-- Design Name: 
-- Module Name: MatrixMul - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MatrixMul is
  Port (
    clk       : in  std_logic;
    rst       : in  std_logic;
    -- 5 inputs for Matrix A
    MatrixA_1       : in  STD_LOGIC_VECTOR (31 downto 0);
    MatrixA_2       : in  STD_LOGIC_VECTOR (31 downto 0);
    MatrixA_3       : in  STD_LOGIC_VECTOR (31 downto 0);
    MatrixA_4       : in  STD_LOGIC_VECTOR (31 downto 0);
    MatrixA_5       : in  STD_LOGIC_VECTOR (31 downto 0);
    -- 5 inputs for Matrix B
    MatrixB_1       : in  STD_LOGIC_VECTOR (31 downto 0);
    MatrixB_2       : in  STD_LOGIC_VECTOR (31 downto 0);
    MatrixB_3       : in  STD_LOGIC_VECTOR (31 downto 0);
    MatrixB_4       : in  STD_LOGIC_VECTOR (31 downto 0);
    MatrixB_5       : in  STD_LOGIC_VECTOR (31 downto 0);
    -- 1 output for Resultant Matrix C
    ResultMatrixC   : out STD_LOGIC_VECTOR (31 downto 0)

   );
end MatrixMul;

architecture Behavioral of MatrixMul is

    component multiplier
        port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        operator1 : in  std_logic_vector(31 downto 0);
        operator2 : in  std_logic_vector(31 downto 0);
        product   : out std_logic_vector(63 downto 0)
        );
    end component;


    signal output_product1, output_product2, output_product3, output_product4, output_product5 : std_logic_vector(63 downto 0);
    signal temp_sum1, temp_sum2, temp_sum3 : std_logic_vector(31 downto 0);
begin


MUL1: multiplier
    port map (
        clk       => clk,
        rst       => rst,
        operator1 => MatrixA_1,
        operator2 => MatrixB_1,
        product   => output_product1
    );

MUL2: multiplier
    port map (
        clk       => clk,
        rst       => rst,
        operator1 => MatrixA_2,
        operator2 => MatrixB_2,
        product   => output_product2
    );

MUL3: multiplier
    port map (
        clk       => clk,
        rst       => rst,
        operator1 => MatrixA_3,
        operator2 => MatrixB_3,
        product   => output_product3
    );

MUL4: multiplier
    port map (
        clk       => clk,
        rst       => rst,
        operator1 => MatrixA_4,
        operator2 => MatrixB_4,
        product   => output_product4
    ); 

MUL5: multiplier
    port map (
        clk       => clk,
        rst       => rst,
        operator1 => MatrixA_5,
        operator2 => MatrixB_5,
        product   => output_product5
    );

    temp_sum1 <= std_logic_vector(unsigned(output_product1(31 downto 0)) + unsigned(output_product2(31 downto 0)));
    temp_sum2 <= std_logic_vector(unsigned(output_product3(31 downto 0)) + unsigned(output_product4(31 downto 0)));
    temp_sum3 <= std_logic_vector(unsigned(temp_sum1) + unsigned(temp_sum2));
    ResultMatrixC <= std_logic_vector(unsigned(temp_sum3) + unsigned(output_product5(31 downto 0)));




end Behavioral;
