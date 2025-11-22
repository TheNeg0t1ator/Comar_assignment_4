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

PCOutPlus <= PCOut_IF_ID + 4;

-- Next PC selection (PC+4 or branch target)
Mux3: Mux port map (
    muxIn0   => PCOutPlus,
    muxIn1   => newAddress,
    selector => PCSrc,
    muxOut   => PCIn
);

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
    writeReg   => writeReg,
    sourceReg1 => instruction(19 downto 15),
    sourceReg2 => instruction(24 downto 20),
    destinyReg => instruction(11 downto 7),
    data       => dataForReg,
    readData1  => regData1,
    readData2  => regData2
);

-- ALU second operand mux (imm or reg)
Mux0: Mux port map (
    muxIn0   => immediate,
    muxIn1   => regData2,
    selector => ALUSrc,
    muxOut   => op2
);


-- ============================================================
-- ================         EX STAGE         ===================
-- ============================================================

-- ALU
ALU: ALU_RV32 port map (
    operator1 => regData1,
    operator2 => op2,
    ALUOp     => ALUOp,
    result    => result,
    zero      => zero,
    carryOut  => carry,
    signo     => signo
);

-- Multiplier
MUL: multiplier port map (
    operator1 => regData1,
    operator2 => op2,
    product   => result_MUL
);

-- Store byte/word mux
Mux1: Mux port map (
    muxIn0   => regData2,
    muxIn1   => regData2Anded,
    selector => StoreSel,
    muxOut   => dataIn
);

-- Branch control
BRControl: Branch_Control port map (
    branch => Branch,
    signo  => signo,
    zero   => zero,
    PCSrc  => PCSrc
);

-- Jump or branch offset
Mux2: Mux port map (
    muxIn0   => immediate,
    muxIn1   => result,
    selector => jump,
    muxOut   => offset
);

regData2Anded <= regData2 and X"000000FF";
shifted       <= offset(30 downto 0) & '0';
newAddress    <= PCOut + shifted;


-- ============================================================
-- ================        MEM STAGE         ===================
-- ============================================================

RAM: Data_Mem port map (
    clk     => clk,
    writeEn => memWrite,
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
    muxIn3 => PCOut,                     -- PC
    muxIn4 => (others => '0'),           -- MULT old? (unused)
    muxIn5 => PCOutPlus,                 -- PC+4
    muxIn6 => result_MUL(31 downto 0),   -- MUL low
    muxIn7 => result_MUL(63 downto 32),  -- MUL high
    selector => toRegister,
    muxOut   => dataForReg
);


-- ============================================================
-- ================     OUTPUT CONNECTIONS    =================
-- ============================================================

ALU_result <= result;


end architecture arch_DataPath;
