library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity multiplier is
    generic (
        SIZE        : integer := 32;
        PIPE_STAGES : integer := 5   -- set to 4 or 5
    );
    port (
        clk       : in  std_logic;
        rst       : in  std_logic;
        operator1 : in  std_logic_vector(SIZE-1 downto 0);
        operator2 : in  std_logic_vector(SIZE-1 downto 0);
        product   : out std_logic_vector(2*SIZE-1 downto 0)
    );
end entity;

architecture rtl of multiplier is

    constant CHUNK : integer := SIZE / PIPE_STAGES;

    type op_pipe_t is array (0 to PIPE_STAGES-1) of unsigned(SIZE-1 downto 0);
    type acc_pipe_t is array (0 to PIPE_STAGES-1) of unsigned(2*SIZE-1 downto 0);

    signal a_pipe : op_pipe_t;
    signal b_pipe : op_pipe_t;
    signal acc    : acc_pipe_t;

begin

    process(clk)
        variable part : unsigned(2*SIZE-1 downto 0);
    begin
        if rising_edge(clk) then
            if rst = '0' then
                for i in 0 to PIPE_STAGES-1 loop
                    a_pipe(i) <= (others => '0');
                    b_pipe(i) <= (others => '0');
                    acc(i)    <= (others => '0');
                end loop;
            else
                ----------------------------------------------------------------
                -- Stage 0
                ----------------------------------------------------------------
                a_pipe(0) <= unsigned(operator1);
                b_pipe(0) <= unsigned(operator2);

                part :=
                    resize(
                        unsigned(operator1) *
                        resize(unsigned(operator2(CHUNK-1 downto 0)), SIZE),
                        2*SIZE
                    );

                acc(0) <= part;

                ----------------------------------------------------------------
                -- Remaining pipeline stages
                ----------------------------------------------------------------
                for i in 1 to PIPE_STAGES-1 loop
                    a_pipe(i) <= a_pipe(i-1);
                    b_pipe(i) <= b_pipe(i-1);

                    part :=
                        resize(
                            a_pipe(i-1) *
                            resize(
                                b_pipe(i-1)((i+1)*CHUNK-1 downto i*CHUNK),
                                SIZE
                            ),
                            2*SIZE
                        ) sll (i*CHUNK);

                    acc(i) <= acc(i-1) + part;
                end loop;
            end if;
        end if;
    end process;

    product <= std_logic_vector(acc(PIPE_STAGES-1));

end architecture;
