library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DataPath is
    port (
        clk         : in std_logic;
        rst         : in std_logic; --reset is button, must be debounced
        ALU_result  : out std_logic_vector(31 downto 0)
    );
end entity DataPath;

architecture arch_DataPath of DataPath is

    component PC
        port (
            PCIn    : in std_logic_vector(31 downto 0);
            clk     : in std_logic;
            rst     : in std_logic;                                                     
            PCOut   : out std_logic_vector(31 downto 0)
        );
    end component;

    component Instruction_Mem
        port (
            Address     :in std_logic_vector(15 downto 0);
            instruction :out std_logic_vector(31 downto 0)
        );
    end component;

    component Reg_File
        port (
            clk         :in std_logic;
            writeReg    :in std_logic;                          --signal for write in register
            sourceReg1  :in std_logic_vector(4 downto 0);       --address of rs1
            sourceReg2  :in std_logic_vector(4 downto 0);       --address of rs2
            destinyReg  :in std_logic_vector(4 downto 0);       --address of rd
            data        :in std_logic_vector(31 downto 0);      --Data to be written
            readData1   :out std_logic_vector(31 downto 0);     --data in rs1
            readData2   :out std_logic_vector(31 downto 0)      --data in rs2    
        );
    end component;

    component Mux
        port (
            muxIn0      :in std_logic_vector(31 downto 0);
            muxIn1      :in std_logic_vector(31 downto 0);
            selector    :in std_logic;
            muxOut      :out std_logic_vector(31 downto 0)    
    );
    end component;

    component ALU_RV32
        port (
            operator1   :in std_logic_vector(31 downto 0);
            operator2   :in std_logic_vector(31 downto 0);
            ALUOp       :in std_logic_vector(2 downto 0);
            result      :out std_logic_vector(31 downto 0);
            zero        :out std_logic;
            carryOut    :out std_logic;
            signo  		:out std_logic
        );
    end component;

    component Data_Mem
        port (
            clk     :in std_logic;
            writeEn :in std_logic;
            Address :in std_logic_vector(3 downto 0);
            dataIn  :in std_logic_vector(31 downto 0);
            dataOut :out std_logic_vector(31 downto 0)
        );
    end component;

    component Immediate_Generator
        port (
            instruction     : in std_logic_vector(31 downto 0);
            immediate       : out std_logic_vector(31 downto 0)
        );
    end component;

    component Mux_Store
        port (
            muxIn0      :in std_logic_vector(31 downto 0);  --SB
            muxIn1      :in std_logic_vector(31 downto 0);  --SW
            selector    :in std_logic;
            muxOut      :out std_logic_vector(31 downto 0)
    );
    end component;

    component Branch_Control
        port (
            branch      : in std_logic_vector(2 downto 0);
            signo       : in std_logic;
            zero        : in std_logic;
            PCSrc       : out std_logic
        );
    end component;

    component Mux_ToRegFile
        generic (
            busWidth    :integer := 32
            --selWidth    :integer := 3
        );
        port (
            muxIn0     :in std_logic_vector(busWidth-1 downto 0);       --register
            muxIn1     :in std_logic_vector(busWidth-1 downto 0);       --LB
            muxIn2     :in std_logic_vector(busWidth-1 downto 0);       --LW
            muxIn3     :in std_logic_vector(busWidth-1 downto 0);       --PC
            muxIn4     :in std_logic_vector(busWidth-1 downto 0);       --mult
            muxIn5     :in std_logic_vector(busWidth-1 downto 0);       --PC+4
            muxIn6     :in std_logic_vector(busWidth-1 downto 0);       --MUL
            muxIn7     :in std_logic_vector(busWidth-1 downto 0);       --MULH
            selector   :in std_logic_vector(2 downto 0);       --ToRegister
            muxOut     :out std_logic_vector(busWidth-1 downto 0)
        );
    end component;

    component Control
        port (
            opcode      : in std_logic_vector(6 downto 0);
            funct3      : in std_logic_vector(2 downto 0);
            funct7      : in std_logic_vector(6 downto 0);
            jump        : out std_logic;
            ToRegister  : out std_logic_vector(2 downto 0);
            MemWrite    : out std_logic;
            Branch      : out std_logic_vector(2 downto 0);
            ALUOp       : out std_logic_vector(2 downto 0);
            StoreSel    : out std_logic;
            ALUSrc      : out std_logic;
            WriteReg    : out std_logic
        );
    end component;
    
    component multiplier
        port (
            operator1   : in std_logic_vector(32-1 downto 0);
            operator2   : in std_logic_vector(32-1 downto 0);
            product     : out std_logic_vector(2*32-1 downto 0)
        );
    end component;
    
    component if_id
        port (
		  instruction_if_in     :in std_logic_vector(31 downto 0);
		  PC_if_in			    :in std_logic_vector(31 downto 0);
          clk					:in std_logic;
		  rst					:in std_logic;
		  enable				:in std_logic;
          instruction_id_out    :out std_logic_vector(31 downto 0);
		  PC_id_out			    :out std_logic_vector(31 downto 0) 
        );
    end component;

    -- ID_EX component declaration (added)
    component ID_EX
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
    end component;
    
    signal PCOut_IF_ID, PCOutPlus_IF_ID     : std_logic_vector(31 downto 0);    --data out from PC register
    signal PCOut, PCOutPlus     : std_logic_vector(31 downto 0);    --data out from PC register
    signal instruction_To_IF_ID : std_logic_vector(31 downto 0);    --instruction from ROM mem to IF_ID
    signal instruction          : std_logic_vector(31 downto 0);    --intruction from IF_ID to the rest
    signal PCIn                 : std_logic_vector(31 downto 0);    --PC updated
    signal regData1,regData2    : std_logic_vector(31 downto 0);    --data readed from register file
    signal signo, zero, carry   : std_logic;
    signal result, dataIn       : std_logic_vector(31 downto 0);    --alu result and data in to memory
    signal immediate            : std_logic_vector(31 downto 0);    --immediate generated
    signal dataOut              : std_logic_vector(31 downto 0);    --data from memory
    signal jump, memWrite       : std_logic;
    signal StoreSel, ALUSrc     : std_logic;
    signal writeReg, PCSrc      : std_logic;
    signal toRegister, Branch, ALUOp : std_logic_vector(2 downto 0);
    signal dataForReg           : std_logic_vector(31 downto 0);    --data to be written in register File
    signal op2                  : std_logic_vector(31 downto 0);    --operator for ALU(output from mux)
    signal offset               : std_logic_vector(31 downto 0);    --PC+immediate after shift or result(jal)
    signal regData2Anded        : std_logic_vector(31 downto 0);
    signal newAddress           : std_logic_vector(31 downto 0);
    signal shifted              : std_logic_vector(31 downto 0);
    signal result_MUL           : std_logic_vector(63 downto 0);

    -- Signals for ID_EX outputs (pipelined values)
    signal instruction_ex       : std_logic_vector(31 downto 0);
    signal PC_ex                : std_logic_vector(31 downto 0);
    signal regData1_ex          : std_logic_vector(31 downto 0);
    signal regData2_ex          : std_logic_vector(31 downto 0);
    signal immediate_ex         : std_logic_vector(31 downto 0);

    signal ALUOp_ex             : std_logic_vector(2 downto 0);
    signal ALUSrc_ex            : std_logic;
    signal Branch_ex            : std_logic_vector(2 downto 0);
    signal MemWrite_ex          : std_logic;
    signal Jump_ex              : std_logic;
    signal WriteReg_ex          : std_logic;
    signal ToRegister_ex        : std_logic_vector(2 downto 0);
    signal StoreSel_ex          : std_logic;

    -- EX stage local op2 (computed from pipelined signals)
    signal op2_ex               : std_logic_vector(31 downto 0);

begin
-- ============================================================
-- ================         IF STAGE         ===================
-- ============================================================

PCount: PC port map (
    clk   => clk,
    rst   => rst,
    PCIn  => PCIn,
    PCOut => PCOut_IF_ID
);

ROM: Instruction_Mem port map (
    Address     => PCOut_IF_ID(15 downto 0),
    instruction => instruction_To_IF_ID
);

-- use the PC value that comes out of IF/ID (PCOut) as basis for PC+4
PCOutPlus <= PCOut + 4;

-- Next PC selection (PC+4 or branch target)
Mux3: Mux port map (
    muxIn0   => PCOutPlus,
    muxIn1   => newAddress,
    selector => PCSrc,
    muxOut   => PCIn
);


-- ============================================================
-- ================      IF_ID pipeline register    ==========
-- ============================================================

-- IF/ID pipeline register
IF_ID_REG: if_id port map (
    instruction_if_in  => instruction_To_IF_ID,
    PC_if_in           => PCOut_IF_ID,
    clk                => clk,
    rst                => rst,
    enable             => '1',
    instruction_id_out => instruction,
    PC_id_out          => PCOut
);


-- ============================================================
-- ================         ID STAGE         ===================
-- ============================================================

-- Control unit
Ctrl: Control port map (
    opcode      => instruction(6 downto 0),
    funct3      => instruction(14 downto 12),
    funct7      => instruction(31 downto 25),
    jump        => jump,
    MemWrite    => memWrite,
    Branch      => Branch,
    ALUOp       => ALUOp,
    StoreSel    => StoreSel,
    ALUSrc      => ALUSrc,
    WriteReg    => WriteReg,
    ToRegister  => toRegister
);

-- Immediate generator
Imm: Immediate_Generator port map (
    instruction => instruction,
    immediate   => immediate
);

-- Register file read
RFILE: Reg_File port map (
    clk        => clk,
    writeReg   => writeReg,   -- writeReg still driven by control here (WB timing not inserted)
    sourceReg1 => instruction(19 downto 15),
    sourceReg2 => instruction(24 downto 20),
    destinyReg => instruction(11 downto 7),
    data       => dataForReg,
    readData1  => regData1,
    readData2  => regData2
);

-- NOTE: ALU second operand selection moved to EX stage (after ID_EX) to pipeline control signals.


-- ============================================================
-- ================      ID_EX pipeline register    ==========
-- ============================================================

ID_EX_REG: ID_EX port map (
    -- inputs from ID-stage signals
    instruction_id_in   => instruction,
    PC_id_in            => PCOut,
    regData1_id_in      => regData1,
    regData2_id_in      => regData2,
    immediate_id_in     => immediate,

    ALUOp_id_in         => ALUOp,
    ALUSrc_id_in        => ALUSrc,
    Branch_id_in        => Branch,
    MemWrite_id_in      => memWrite,
    Jump_id_in          => jump,
    WriteReg_id_in      => writeReg,
    ToRegister_id_in    => toRegister,
    StoreSel_id_in      => StoreSel,

    clk                 => clk,
    rst                 => rst,
    enable              => '1',

    -- outputs to EX stage
    instruction_ex_out  => instruction_ex,
    PC_ex_out           => PC_ex,
    regData1_ex_out     => regData1_ex,
    regData2_ex_out     => regData2_ex,
    immediate_ex_out    => immediate_ex,

    ALUOp_ex_out        => ALUOp_ex,
    ALUSrc_ex_out       => ALUSrc_ex,
    Branch_ex_out       => Branch_ex,
    MemWrite_ex_out     => MemWrite_ex,
    Jump_ex_out         => Jump_ex,
    WriteReg_ex_out     => WriteReg_ex,
    ToRegister_ex_out   => ToRegister_ex,
    StoreSel_ex_out     => StoreSel_ex
);


-- ============================================================
-- ================         EX STAGE (pipelined)   ===========
-- ============================================================

-- compute op2 in EX using pipelined immediate/regData2 and ALUSrc control
Mux0_EX: Mux port map (
    muxIn0   => immediate_ex,
    muxIn1   => regData2_ex,
    selector => ALUSrc_ex,
    muxOut   => op2_ex
);

-- ALU uses pipelined regData1_ex and op2_ex and pipelined ALUOp_ex
ALU: ALU_RV32 port map (
    operator1 => regData1_ex,
    operator2 => op2_ex,
    ALUOp     => ALUOp_ex,
    result    => result,
    zero      => zero,
    carryOut  => carry,
    signo     => signo
);

-- Multiplier (still uses pipelined operands)
MUL: multiplier port map (
    operator1 => regData1_ex,
    operator2 => op2_ex,
    product   => result_MUL
);

-- Store byte/word mux uses pipelined regData2_ex
Mux1: Mux port map (
    muxIn0   => regData2_ex,
    muxIn1   => regData2Anded,
    selector => StoreSel_ex,
    muxOut   => dataIn
);

-- Branch control uses pipelined Branch_ex
BRControl: Branch_Control port map (
    branch => Branch_ex,
    signo  => signo,
    zero   => zero,
    PCSrc  => PCSrc
);

-- Jump or branch offset selection uses pipelined immediate_ex and Jump_ex
Mux2: Mux port map (
    muxIn0   => immediate_ex,
    muxIn1   => result,
    selector => Jump_ex,
    muxOut   => offset
);

-- regData2Anded should use pipelined regData2_ex
regData2Anded <= regData2_ex and X"000000FF";

-- shift offset and compute new address using pipelined PC_ex
shifted       <= offset(30 downto 0) & '0';
newAddress    <= PC_ex + shifted;


-- ============================================================
-- ================        MEM STAGE         ===================
-- ============================================================

RAM: Data_Mem port map (
    clk     => clk,
    writeEn => MemWrite_ex,
    Address => result(3 downto 0),
    dataIn  => dataIn,
    dataOut => dataOut
);


-- ============================================================
-- ================         WB STAGE         ===================
-- ============================================================

MuxReg: Mux_ToRegFile port map (
    muxIn0 => result,                    -- ALU
    muxIn1 => dataOut,                   -- LB
    muxIn2 => dataOut,                   -- LW
    muxIn3 => PC_ex,                     -- PC (pipelined)
    muxIn4 => (others => '0'),           -- MULT old? (unused)
    muxIn5 => PC_ex,                 -- PC+4 (pipelined) --TODO
    muxIn6 => result_MUL(31 downto 0),   -- MUL low
    muxIn7 => result_MUL(63 downto 32),  -- MUL high
    selector => ToRegister_ex,
    muxOut   => dataForReg
);


-- ============================================================
-- ================     OUTPUT CONNECTIONS    =================
-- ============================================================

ALU_result <= result;

end architecture arch_DataPath;
