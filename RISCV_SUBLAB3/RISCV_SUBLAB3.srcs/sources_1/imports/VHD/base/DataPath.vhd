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
            clk                 :in  std_logic;
            writeReg            :in  std_logic;                          --signal for write in register
            sourceReg1          :in  std_logic_vector(4 downto 0);       --address of rs1
            sourceReg2          :in  std_logic_vector(4 downto 0);       --address of rs2
            destinyReg          :in  std_logic_vector(4 downto 0);       --address of rd
            data                :in  std_logic_vector(31 downto 0);      --Data to be written
            readData1           :out std_logic_vector(31 downto 0);     --data in rs1
            readData2           :out std_logic_vector(31 downto 0);      --data in rs2
            Matrixmul_ra        :out std_logic_vector(31 downto 0);
            Matrixmul_ra_src    :in  std_logic_vector(4 downto 0)
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
            signo       :out std_logic
        );
    end component;

    component Data_Mem
        port (
            clk     :in std_logic;
            writeEn :in std_logic;
            Address :in std_logic_vector(7 downto 0);
            dataIn  :in std_logic_vector(31 downto 0);
            dataOut :out std_logic_vector(31 downto 0);

            --matrix mul data IO
            Vaddr_1 : in std_logic_vector(7 downto 0);
            Vaddr_2 : in std_logic_vector(7 downto 0);
            Vdata_1 : out std_logic_vector(159 downto 0);
            Vdata_2 : out std_logic_vector(159 downto 0)

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
            WriteReg    : out std_logic;
            IsValidRD   : out std_logic
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
          PC_if_in              :in std_logic_vector(31 downto 0);
          clk                   :in std_logic;
          rst                   :in std_logic;
          enable                :in std_logic;
          instruction_id_out    :out std_logic_vector(31 downto 0);
          PC_id_out             :out std_logic_vector(31 downto 0);
          Branch_prediction_in  :in std_logic; 
		  Branch_prediction_out :out std_logic 
        );
    end component;

    -- ID_EX component declaration (added)
    component ID_EX
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
            MatrixMul_Adress1_in        : in std_logic_vector(31 downto 0);
            MatrixMul_Adress2_in        : in std_logic_vector(31 downto 0);
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
            MatrixMul_Adress1_out       : out std_logic_vector(31 downto 0);
            MatrixMul_Adress2_out       : out std_logic_vector(31 downto 0);
            MatrixMul_ReturnAdress_out  : out std_logic_vector(31 downto 0);
            MatrixMul_enable_out        : out std_logic
        );
    end component;

    component EX_MEM
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
                IsValidRD_ex_in         : in std_logic;
                --MatrixMul addresses and return address
                MatrixMul_Adress1_in          : in std_logic_vector(31 downto 0);
                MatrixMul_Adress2_in          : in std_logic_vector(31 downto 0);
                MatrixMul_ReturnAdress_in     : in std_logic_vector(31 downto 0);
                MatrixMul_enable_in          : in std_logic;

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
                reg_write_ex_out        : out std_logic;
                IsValidRD_ex_out        : out std_logic;
                --MatrixMul addresses and return address
                MatrixMul_Adress1_out          : out std_logic_vector(31 downto 0);
                MatrixMul_Adress2_out          : out std_logic_vector(31 downto 0);
                MatrixMul_ReturnAdress_out     : out std_logic_vector(31 downto 0);
                MatrixMul_enable_out           : out std_logic
        );
    end component;

    component MEM_WB
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
                IsValidRD_mem_in   : in std_logic;

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
            IsValidRD_wb_out        : out std_logic
        );
    end component;


    component Mux_rfile1
      Port ( 
        rdata_regfile   : in  std_logic_vector(31 downto 0);
        EX_ALU_RESULT   : in  std_logic_vector(31 downto 0);
        EX_MUL_RESULT   : in  std_logic_vector(31 downto 0);
        EX_MULH_RESULT  : in  std_logic_vector(31 downto 0);
        MEM_ALU_RESULT  : in  std_logic_vector(31 downto 0);
        MEM_MUL_RESULT  : in  std_logic_vector(31 downto 0);
        MEM_MULH_RESULT : in  std_logic_vector(31 downto 0);
        MEM_LOAD_WORD   : in  std_logic_vector(31 downto 0);
        Rdata_id_in     : out std_logic_vector(31 downto 0);
        selector        : in  std_logic_vector(3 downto 0)
      );
    end component;

    component Forwarding_unit
        Port ( 
            Regfile_Selector1, Regfile_Selector2                    : out std_logic_vector(3 downto 0);
            Input_select_ex,Input_select_mem,Input_select_wb        : in std_logic_vector(2 downto 0);
            RD_ex, RD_mem, RD_wb                                    : in std_logic_vector(4 downto 0);
            SourceReg1_id, SourceReg2_id                            : in std_logic_vector(4 downto 0);
            Valid_rd_ex, Valid_rd_mem, Valid_rd_wb                  : in std_logic
        );
     end component;

    component Mux_ramfwd
      Port ( 
        SourceReg:   in  std_logic_vector (31 downto 0);
        MEM_LOAD_WORD:   in  std_logic_vector (31 downto 0);
        Output:   out std_logic_vector (31 downto 0);
        selector: in  std_logic_vector (1 downto 0)
      );
    end component;

    component memfwd
      Port (
        selector1:      out  std_logic_vector (1 downto 0);
        selector2:      out  std_logic_vector (1 downto 0);
        ex_source_reg1: in  std_logic_vector (4 downto 0);
        ex_source_reg2: in  std_logic_vector (4 downto 0);
        mem_rd:         in  std_logic_vector (4 downto 0);
        mux_sellwb:     in  std_logic_vector (2 downto 0)
       );
    end component;

    component  Branch_Predictor
        Port ( 
            Prediction_in   : in  std_logic;
            IF_in           : in  std_logic_vector(31 downto 0);
            Current_PC      : in  std_logic_vector(31 downto 0);
            New_PC          : out std_logic_vector(31 downto 0);
            Prediction_out  : out std_logic
        );
    end component;
    component Mux_Predict
    port (
            PC_Current : in  std_logic_vector(31 downto 0);
            PC_Old     : in  std_logic_vector(31 downto 0);
            PC_New     : in  std_logic_vector(31 downto 0);
            selector   : in  std_logic;
            Predictor  : in  std_logic;
            muxOut     : out std_logic_vector(31 downto 0);
            RST        : out std_logic
        );
    end component;

    component MatrixMul
        port (
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
    end component;
-- ===================== Signals =====================
    signal PCOut_IF_ID, PCOutPlus_IF_ID, PCOut, PCOutPlus : std_logic_vector(31 downto 0);
    signal instruction_To_IF_ID, instruction : std_logic_vector(31 downto 0);
    signal PCIn : std_logic_vector(31 downto 0);

-- Additional small signals that were missing
    signal newAddress   : std_logic_vector(31 downto 0);
    signal PCSrc        : std_logic;
    signal offset       : std_logic_vector(31 downto 0);
    signal shifted      : std_logic_vector(31 downto 0);

-- ID stage

    signal regdata1_MUX, regdata2_MUX : std_logic_vector(31 downto 0);

-- forward
    signal Regfile_Selector_signal1, Regfile_Selector_signal2 : std_logic_vector(3 downto 0);
    signal Valid_rd_mem_signal : std_logic;
    signal Valid_rd_WB_signal : std_logic;

-- ID-EX reg
    -- inputs to EX stage
    signal immediate_id_in     : std_logic_vector(31 downto 0);
    --MUX0
    signal ALUSrc_id_in        : std_logic;
    --MUX1
    signal StoreSel_id_in      : std_logic;
    --MUX2
    signal Jump_id_in          : std_logic;
    --Branch-Control
    signal Branch_id_in        : std_logic_vector(2 downto 0);
    --ALU
    signal ALUOp_id_in         : std_logic_vector(2 downto 0);
    signal regData1_id_in      : std_logic_vector(31 downto 0);
    signal regData2_id_in      : std_logic_vector(31 downto 0);
    --EX-MEM
    signal mem_write_en_id_in  :  std_logic;
    signal mux_sell_id_in      : std_logic_vector(2 downto 0);
    signal pc_id_in            : std_logic_vector(31 downto 0); -- ALU     (MUX3&MUX5)
    signal rd_id_in            : std_logic_vector(4 downto 0);
    signal reg_write_id_in     : std_logic;
    signal IsValidRD_id_in_sig : std_logic;
    -- Outputs to EX stage
    signal immediate_id_out    : std_logic_vector(31 downto 0);
    --MUX0
    signal ALUSrc_id_out       : std_logic;
    --MUX1
    signal StoreSel_id_out     : std_logic;
    --MUX2
    signal Jump_id_out         : std_logic;
    --Branch-Control
    signal Branch_id_out       : std_logic_vector(2 downto 0);
    --ALU
    signal ALUOp_id_out        : std_logic_vector(2 downto 0);
    signal regData1_id_out     : std_logic_vector(31 downto 0);
    signal regData2_id_out     : std_logic_vector(31 downto 0);
    --EX-MEM
    signal mem_write_en_id_out :  std_logic;
    signal mux_sell_id_out     : std_logic_vector(2 downto 0);
    signal pc_id_out           : std_logic_vector(31 downto 0); -- ALU     (MUX3&MUX5)
    signal rd_id_out           : std_logic_vector(4 downto 0);
    signal reg_write_id_out    : std_logic;
    signal IsValidRD_id_out_sig : std_logic;
    --memfwd
    signal source_reg_id_out1_sig   : std_logic_vector(4 downto 0);
    signal source_reg_id_out2_sig   : std_logic_vector(4 downto 0);
    --matrixmul
    signal MatrixMul_Adress1_out_sig      : std_logic_vector(31 downto 0);
    signal MatrixMul_Adress2_out_sig      : std_logic_vector(31 downto 0);
    signal MatrixMul_ReturnAdress_out_sig : std_logic_vector(31 downto 0);
    signal MatrixMul_enable_out_sig       : std_logic;
    signal MatrixMul_ra_in_sig            : std_logic_vector(31 downto 0);

-- EX
    --MUX0
    signal op2_ex: std_logic_vector(31 downto 0);
    --MUX1
    signal regData2Anded: std_logic_vector(31 downto 0);
    --ALU
    signal signo, zero, carry: std_logic;

    --Mux_ramfwd
    signal mux_ramfwd_out1 : std_logic_vector(31 downto 0);
    signal mux_ramfwd_out2 : std_logic_vector(31 downto 0);
    signal ramfwd_selector1 : std_logic_vector(1 downto 0);
    signal ramfwd_selector2 : std_logic_vector(1 downto 0);

-- EX-MEM reg
    -- Inputs from EX stage
    signal ALU_result_ex_in        : std_logic_vector(31 downto 0); -- ALU     (MUX0)& (RAM ADDRESS)
    -- RAM
    signal mem_write_en_ex_in      : std_logic;
    signal mem_write_data_ex_in    : std_logic_vector(31 downto 0);
    --MEM_WB
    signal mux_sell_ex_in          : std_logic_vector(2 downto 0);
    signal pc_ex_in                : std_logic_vector(31 downto 0); -- ALU     (MUX3&MUX5)
    signal MUL_result_ex_in        : std_logic_vector(63 downto 0); -- ALU     (MUX6&MUX7)                                                    Property of LogicLab
    signal rd_ex_in                : std_logic_vector(4 downto 0);
    signal reg_write_ex_in         : std_logic;
    -- Outputs to MEM stage
    signal ALU_result_ex_out       : std_logic_vector(31 downto 0); -- ALU     (MUX0)& (RAM ADDRESS)
    -- RAM
    signal mem_write_en_ex_out     : std_logic;
    signal mem_write_data_ex_out   : std_logic_vector(31 downto 0);

--RAM
    signal mem_mux_data         : std_logic_vector(31 downto 0);
    signal mem_mux_adress       : std_logic_vector(31 downto 0);
    signal mem_matrix_ra        : std_logic_vector(31 downto 0);
    --matrix mul 
    signal VectorAddress_1      : std_logic_vector(31 downto 0);
    signal VectorAddress_2      : std_logic_vector(31 downto 0);
    signal VectorData_1         : std_logic_vector(159 downto 0);
    signal VectorData_2         : std_logic_vector(159 downto 0);

-- MEM-WB reg
    -- input
    --MUX
    signal mux_sell_wb_in     : std_logic_vector(2 downto 0);
    signal ALU_result_wb_in   : std_logic_vector(31 downto 0); -- ALU     (MUX0)
    signal mem_data_wb_in     : std_logic_vector(31 downto 0); -- LB LW   (MUX1&MUX2)
    signal pc_wb_in           : std_logic_vector(31 downto 0); -- ALU     (MUX3&MUX5)
    signal MUL_result_wb_in   : std_logic_vector(63 downto 0); -- ALU     (MUX6&MUX7)
    --REFILE
    signal rd_wb_in           : std_logic_vector(4 downto 0);
    signal reg_write_wb_in    : std_logic;
    -- output
    --MUX
    signal mux_sell_wb_out     : std_logic_vector(2 downto 0);
    signal ALU_result_wb_out   : std_logic_vector(31 downto 0); -- ALU     (MUX0)
    signal mem_data_wb_out     : std_logic_vector(31 downto 0); -- LB LW   (MUX1&MUX2)
    signal pc_wb_out           : std_logic_vector(31 downto 0); -- ALU     (MUX3&MUX5)
    signal MUL_result_wb_out   : std_logic_vector(63 downto 0); -- ALU     (MUX6&MUX7)
    --REFILE
    signal rd_wb_out           : std_logic_vector(4 downto 0);
    signal reg_write_wb_out    : std_logic;

    signal data_For_RegFile : std_logic_vector(31 downto 0);
    signal branch_rst :std_logic;
    signal prediction_IF, prediction_ID , prediction_EX :std_logic;
    signal RST_Branch : std_logic;

    --matrix multiplier signals
    signal MatrixA_1, MatrixA_2, MatrixA_3, MatrixA_4, MatrixA_5 : std_logic_vector(31 downto 0);
    signal MatrixB_1, MatrixB_2, MatrixB_3, MatrixB_4, MatrixB_5 : std_logic_vector(31 downto 0);
    signal ResultMatrixC : std_logic_vector(31 downto 0);
    signal matrixmul_enable : std_logic;

begin
--branch_RST <= rst or PCSrc;

-- ===================== IF STAGE =====================
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

Mux3: Mux_Predict port map (
    PC_Current => PCOutPlus,
    PC_Old     => pc_ex_in,
    PC_New     => newAddress,
    selector   => PCSrc,
    Predictor  => prediction_EX,
    muxOut     => PCIn,
    RST        => RST_Branch
);

Branch_Predictor_inst : Branch_Predictor port map ( 
    Prediction_in   => '1',                    -- static prediction for now
    IF_in           => instruction_To_IF_ID,   -- full instruction
    Current_PC      => PCOut_IF_ID,             -- FULL 32-bit PC
    New_PC          => PCOutPlus,                    -- next PC goes here
    Prediction_out  => prediction_IF
);
-- ===================== IF_ID =====================
IF_ID_REG: if_id port map (
    instruction_if_in  => instruction_To_IF_ID,
    PC_if_in           => PCOut_IF_ID,
    clk                => clk,
    rst                => rst and RST_Branch,
    enable             => '1',
    instruction_id_out => instruction,
    PC_id_out          => PCOut,
    Branch_prediction_in  => prediction_IF,
	Branch_prediction_out => prediction_ID
);

-- ===================== ID STAGE =====================
Ctrl: Control port map (
    opcode      => instruction(6 downto 0),
    funct3      => instruction(14 downto 12),
    funct7      => instruction(31 downto 25),
    jump        => Jump_id_in,
    MemWrite    => mem_write_en_id_in,
    Branch      => Branch_id_in,
    ALUOp       => ALUOp_id_in,
    StoreSel    => StoreSel_id_in,
    ALUSrc      => ALUSrc_id_in,
    WriteReg    => reg_write_id_in,
    ToRegister  => mux_sell_id_in,
    IsValidRD   => IsValidRD_id_in_sig
);

Imm: Immediate_Generator port map (
    instruction => instruction,
    immediate   => immediate_id_in
);

RFILE: Reg_File port map (
    clk        => clk,
    writeReg   => reg_write_wb_out,
    sourceReg1 => instruction(19 downto 15),
    sourceReg2 => instruction(24 downto 20),
    destinyReg => rd_wb_out,
    data       => data_For_RegFile,
    readData1  => regdata1_MUX,
    readData2  => regdata2_MUX,
    Matrixmul_ra => MatrixMul_ra_in_sig,
    Matrixmul_ra_src => instruction(11 downto 7)  
);

mux_rfile1_inst1: Mux_rfile1 port map (
    rdata_regfile  => regdata1_MUX,
    EX_ALU_RESULT   =>  ALU_result_ex_in,
    EX_MUL_RESULT   =>  MUL_result_ex_in (31 downto 0),
    EX_MULH_RESULT  =>  MUL_result_ex_in (63 downto 32),
    MEM_ALU_RESULT  =>  ALU_result_ex_out,
    MEM_MUL_RESULT  =>  MUL_result_wb_in (31 downto 0),
    MEM_MULH_RESULT =>  MUL_result_wb_in (63 downto 32),
    MEM_LOAD_WORD   =>  mem_data_wb_in,
    Rdata_id_in     => regData1_id_in,
    selector        => Regfile_Selector_signal1
);

mux_rfile1_inst2: Mux_rfile1 port map (
    rdata_regfile  => regdata2_MUX,
    EX_ALU_RESULT   =>  ALU_result_ex_in,
    EX_MUL_RESULT   =>  MUL_result_ex_in (31 downto 0),
    EX_MULH_RESULT  =>  MUL_result_ex_in (63 downto 32),
    MEM_ALU_RESULT  =>  ALU_result_ex_out,
    MEM_MUL_RESULT  =>  MUL_result_wb_in (31 downto 0),
    MEM_MULH_RESULT =>  MUL_result_wb_in (63 downto 32),
    MEM_LOAD_WORD   =>  mem_data_wb_in,
    Rdata_id_in     =>  regData2_id_in,
    selector        =>  Regfile_Selector_signal2
);

-- ================== Forwarding ===================

ForwardingUnit: Forwarding_unit port map (
    Regfile_Selector1    => Regfile_Selector_signal1,
    Regfile_Selector2    => Regfile_Selector_signal2,
    Input_select_ex      => mux_sell_ex_in,
    Input_select_mem     => mux_sell_wb_in,
    Input_select_wb      => mux_sell_wb_out,
    RD_ex                => rd_ex_in,
    RD_mem               => rd_wb_in,
    RD_wb                => rd_wb_out,
    SourceReg1_id        => instruction(19 downto 15),
    SourceReg2_id        => instruction(24 downto 20),
    Valid_rd_ex         => IsValidRD_id_out_sig,
    Valid_rd_mem        => Valid_rd_mem_signal,
    Valid_rd_wb         => Valid_rd_WB_signal
);

-- ===================== ID_EX =====================
ID_EX_REG: ID_EX port map (
    clk                 => clk,
    rst                => rst and RST_Branch,
    enable              => '1',
    -- inputs to EX stage
    immediate_id_in     => immediate_id_in,
    --MUX0
    ALUSrc_id_in        => ALUSrc_id_in,
    --MUX1
    StoreSel_id_in      => StoreSel_id_in,
    --MUX2
    Jump_id_in          => Jump_id_in,
    --Branch-Control
    Branch_id_in        => Branch_id_in,
    --ALU
    ALUOp_id_in         => ALUOp_id_in,
    regData1_id_in      => regData1_id_in,
    regData2_id_in      => regData2_id_in,
    --memfwd
    source_reg_id_in1   => instruction(19 downto 15),
    source_reg_id_in2   => instruction(24 downto 20),
    --EX-MEM
    mem_write_en_id_in  => mem_write_en_id_in,
    mux_sell_id_in      => mux_sell_id_in,
    pc_id_in            => PCOut,
    rd_id_in            => instruction(11 downto 7),
    reg_write_id_in     => reg_write_id_in,
    IsValidRD_id_in     => IsValidRD_id_in_sig,
    --matrixmul
    MatrixMul_Adress1_in        => regdata1_MUX,
    MatrixMul_Adress2_in        => regdata2_MUX,
    MatrixMul_ReturnAdress_in   => MatrixMul_ra_in_sig,
    MatrixMul_enable_in         => '0',

    -- Outputs to EX stage
    immediate_id_out    => immediate_id_out,
    --MUX0
    ALUSrc_id_out       => ALUSrc_id_out,
    --MUX1
    StoreSel_id_out     => StoreSel_id_out,
    --MUX2
    Jump_id_out         => Jump_id_out,
    --Branch-Control
    Branch_id_out       => Branch_id_out,
    --ALU
    ALUOp_id_out        => ALUOp_id_out,
    regData1_id_out     => regData1_id_out,
    regData2_id_out     => regData2_id_out,
    --EX-MEM
    mem_write_en_id_out => mem_write_en_ex_in,
    mux_sell_id_out     => mux_sell_ex_in,
    pc_id_out           => pc_ex_in,
    rd_id_out           => rd_ex_in,
    reg_write_id_out    => reg_write_ex_in,
    IsValidRD_id_out    => IsValidRD_id_out_sig,
    --memfwd
    source_reg_id_out1  => source_reg_id_out1_sig,
    source_reg_id_out2  => source_reg_id_out2_sig,
    Branch_prediction_in  => prediction_ID,
	Branch_prediction_out => prediction_EX,
    --matrixmul
    MatrixMul_Adress1_out      => MatrixMul_Adress1_out_sig,
    MatrixMul_Adress2_out      => MatrixMul_Adress2_out_sig,
    MatrixMul_ReturnAdress_out => MatrixMul_ReturnAdress_out_sig,
    MatrixMul_enable_out       => MatrixMul_enable_out_sig
);


-- ===================== EX STAGE =====================
Mux0_EX: Mux port map (
    muxIn0   => immediate_id_out,
    muxIn1   => mux_ramfwd_out2,
    selector => ALUSrc_id_out,
    muxOut   => op2_ex
);

ALU: ALU_RV32 port map (
    operator1 => mux_ramfwd_out1,
    operator2 => op2_ex,
    ALUOp     => ALUOp_id_out,
    result    => ALU_result_ex_in,
    zero      => zero,
    carryOut  => carry,
    signo     => signo
);

MUL: multiplier port map (
    operator1 => mux_ramfwd_out1,
    operator2 => op2_ex,
    product   => MUL_result_ex_in
);

Mux1: Mux port map (
    muxIn0   => mux_ramfwd_out2,
    muxIn1   => regData2Anded,
    selector => StoreSel_id_out,
    muxOut   => mem_write_data_ex_in
);

BRControl: Branch_Control port map (
    branch => Branch_id_out,
    signo  => signo,
    zero   => zero,
    PCSrc  => PCSrc
);

Mux2: Mux port map (
    muxIn0   => immediate_id_out,
    muxIn1   => ALU_result_ex_in,
    selector => Jump_id_out,
    muxOut   => offset
);

mux_ramfwd_1: Mux_ramfwd port map (
    SourceReg       => regData1_id_out,
    MEM_LOAD_WORD   => mem_data_wb_in,
    Output          => mux_ramfwd_out1,
    selector        => ramfwd_selector1
);

mux_ramfwd_2: Mux_ramfwd port map (
    SourceReg       => regData2_id_out,
    MEM_LOAD_WORD   => mem_data_wb_in,
    Output          => mux_ramfwd_out2,
    selector        => ramfwd_selector2
);

mufwd_unit: memfwd port map (
    selector1        => ramfwd_selector1,
    selector2        => ramfwd_selector2,
    ex_source_reg1   => source_reg_id_out1_sig,
    ex_source_reg2   => source_reg_id_out2_sig,
    mem_rd           => rd_wb_in,
    mux_sellwb       => mux_sell_wb_in
);


branch_rst <= rst;
regData2Anded <= mux_ramfwd_out2 and X"000000FF";
shifted       <= offset(30 downto 0) & '0';
newAddress    <= pc_ex_in + shifted;


-- ===================== EX_MEM =====================
EX_MEM_REG: EX_MEM port map (
    clk               => clk,
    rst               => rst,
    enable            => '1',
    -- Inputs from EX stage
        ALU_result_ex_in        => ALU_result_ex_in,
    -- RAM
        mem_write_en_ex_in      => mem_write_en_ex_in,
        mem_write_data_ex_in    => mem_write_data_ex_in,
    --MEM_WB
        mux_sell_ex_in          => mux_sell_ex_in,
        pc_ex_in                => pc_ex_in,
        MUL_result_ex_in        => MUL_result_ex_in,
        rd_ex_in                => rd_ex_in,
        reg_write_ex_in         => reg_write_ex_in,
        IsValidRD_ex_in         => IsValidRD_id_out_sig,
        --MatrixMul addresses and return address
        MatrixMul_Adress1_in        => MatrixMul_Adress1_out_sig,
        MatrixMul_Adress2_in        => MatrixMul_Adress2_out_sig,
        MatrixMul_ReturnAdress_in   => MatrixMul_ReturnAdress_out_sig,
        MatrixMul_enable_in            => MatrixMul_enable_out_sig,

    -- Outputs to MEM stage
        ALU_result_ex_out       => ALU_result_ex_out,
    -- RAM
        mem_write_en_ex_out     => mem_write_en_ex_out,
        mem_write_data_ex_out   => mem_write_data_ex_out,
    --MEM_WB
        mux_sell_ex_out         => mux_sell_wb_in,
        pc_ex_out               => pc_wb_in,
        MUL_result_ex_out       => MUL_result_wb_in,
        rd_ex_out               => rd_wb_in,
        reg_write_ex_out        => reg_write_wb_in,
        IsValidRD_ex_out        => Valid_rd_mem_signal,
        --MatrixMul addresses and return address
        MatrixMul_Adress1_out        => VectorAddress_1,
        MatrixMul_Adress2_out        => VectorAddress_2,
        MatrixMul_ReturnAdress_out   => mem_matrix_ra,
        MatrixMul_enable_out            => matrixmul_enable
);

-- ===================== MEM STAGE =====================

Mux_RAM_Data: Mux port map (
    muxIn0   => mem_write_data_ex_out,
    muxIn1   => ResultMatrixC,
    selector => matrixmul_enable,
    muxOut   => mem_mux_data
);

Mux_RAM_Address: Mux port map (
    muxIn0   =>  ALU_result_ex_out,
    muxIn1   =>  mem_matrix_ra,
    selector =>  matrixmul_enable,
    muxOut   =>  mem_mux_adress
);

RAM: Data_Mem port map (
    clk     => clk,
    writeEn => mem_write_en_ex_out,
    Address => mem_mux_adress(7 downto 0),
    dataIn  => mem_mux_data,
    dataOut => mem_data_wb_in,

        --matrix mul data IO
    Vaddr_1 => VectorAddress_1(7 downto 0), -- matrix a
    Vaddr_2 => VectorAddress_2(7 downto 0), -- matrix b
    Vdata_1 => VectorData_1,
    Vdata_2 => VectorData_2
);

matrix_multiplier_inst : MatrixMul port map (
    MatrixA_1       => VectorData_1(31 downto 0),
    MatrixA_2       => VectorData_1(63 downto 32),
    MatrixA_3       => VectorData_1(95 downto 64),
    MatrixA_4       => VectorData_1(127 downto 96),
    MatrixA_5       => VectorData_1(159 downto 128),
    MatrixB_1       => VectorData_2(31 downto 0),
    MatrixB_2       => VectorData_2(63 downto 32),
    MatrixB_3       => VectorData_2(95 downto 64),
    MatrixB_4       => VectorData_2(127 downto 96),
    MatrixB_5       => VectorData_2(159 downto 128),
    ResultMatrixC   => ResultMatrixC
);


-- ===================== MEM_WB =====================
MEM_WB_REG: MEM_WB port map (
    clk                 => clk,
    rst                 => rst,
    enable              => '1',
    -- Inputs from MEM stage
    -- MUX
         mux_sell_wb_in     => mux_sell_wb_in,
         ALU_result_wb_in   => ALU_result_ex_out,     -- ALU     (MUX0)
         mem_data_wb_in     => mem_data_wb_in,       -- LB LW   (MUX1&MUX2)
         pc_wb_in           => pc_wb_in,             -- ALU     (MUX3&MUX5)
         MUL_result_wb_in   => MUL_result_wb_in,     -- ALU     (MUX6&MUX7)
    -- Writing to register File
         rd_wb_in           => rd_wb_in,
         reg_write_wb_in    => reg_write_wb_in,
         IsValidRD_mem_in   => Valid_rd_mem_signal,
    -- Outputs to WB stage
    -- MUX
        mux_sell_wb_out     => mux_sell_wb_out,
        ALU_result_wb_out   => ALU_result_wb_out,    -- ALU     (MUX0)
        mem_data_wb_out     => mem_data_wb_out,      -- LB LW   (MUX1&MUX2)
        pc_wb_out           => pc_wb_out, -- ALU     (MUX3&MUX5)
        MUL_result_wb_out   => MUL_result_wb_out,-- ALU     (MUX6&MUX7)
    -- Writing to register File
        rd_wb_out           => rd_wb_out,
        reg_write_wb_out    => reg_write_wb_out,
        IsValidRD_wb_out    => Valid_rd_WB_signal
);

-- ===================== WB STAGE =====================
WB_MUX: Mux_ToRegFile port map (
    muxIn0   => ALU_result_wb_out,
    muxIn1   => mem_data_wb_out,
    muxIn2   => mem_data_wb_out,
    muxIn3   => pc_wb_out,
    muxIn4   => (others => '0'),
    muxIn5   => pc_wb_out,
    muxIn6   => MUL_result_wb_out(31 downto 0),
    muxIn7   => MUL_result_wb_out(63 downto 32),
    selector => mux_sell_wb_out,
    muxOut   => data_For_RegFile
);


-- expose ALU result from EX stage on top-level port (helps debugging)
ALU_result <= ALU_result_ex_in;

end architecture arch_DataPath;