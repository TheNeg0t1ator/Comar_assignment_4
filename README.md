# Comar_assignment_4

<img width="752" height="261" alt="image" src="https://github.com/user-attachments/assets/e5d005fe-76ad-403c-b16e-a63f32b53094" />

# Sublab 1

# Sublab 2

## VHDL

### DataPath

Updated the **Mux-ToRegFile** component to include the extra ports required for supporting the multiplier hardware.  
<img width="1920" height="1032" alt="Image" src="https://github.com/user-attachments/assets/57c2cd25-b2a7-47bc-9622-1c28a67f0dc9" />

Added the **multiplier** component from Toledo to the datapath.  
<img width="1920" height="1032" alt="Image" src="https://github.com/user-attachments/assets/a07a66cd-5c60-4a11-b2e5-8143fe4f4613" />

Connected the ALU inputs to the multiplier inputs and routed the **multiplier** output to the **Mux-ToRegFile**.  
<img width="1920" height="1032" alt="Image" src="https://github.com/user-attachments/assets/05b61710-b9a4-4612-868b-b222b4f1ed72" />

### Mux-ToRegFile

Added two new input ports to support the **multiplier** output:

- `muxIn6 => result_MUL(31 downto 0)` for **MUL** (lower 32 bits)  
- `muxIn7 => result_MUL(63 downto 32)` for **MULH** (upper 32 bits)

<img width="1920" height="1032" alt="Image" src="https://github.com/user-attachments/assets/6632d350-c476-4eae-8294-261e33902925" />

Updated the MUX selection logic so the correct **multiplier** output can be written to the register file:

- `muxIn6` selected when `ToRegister = "110"`  
- `muxIn7` selected when `ToRegister = "111"`

<img width="1920" height="1032" alt="Image" src="https://github.com/user-attachments/assets/d17c6b3f-3d5b-4e33-a870-a8c05fd2c7f5" />

### Control

Extended the control logic so that **MUL** and **MULH** opcodes are recognized and mapped to the correct `ToRegister` values:

- `MUL` → `ToRegister = "110"`  
- `MULH` → `ToRegister = "111"`

<img width="1920" height="1032" alt="Image" src="https://github.com/user-attachments/assets/96207186-caef-4db9-a5ec-48a68016ca55" />
<img width="1920" height="1032" alt="Image" src="https://github.com/user-attachments/assets/35afbc54-6055-423d-9b07-95e724627e0e" />

# Sublab 3

## VHDL

### 5-Stage Implementation

To achieve a fully pipelined 5-stage RISC-V processor, the CPU was split into five stages separated by pipeline buffers:  
`IF`, `ID`, `EX`, `MEM`, `WB`.

The main advantages are reducing the critical path and increasing throughput by executing different parts of the pipeline simultaneously.

<img width="712" height="265" alt="image" src="https://github.com/user-attachments/assets/dc90a6f2-b525-4666-8896-0ed8c309a45f" />

Our implementation:

#### IF Stage
<img width="1045" height="131" alt="image" src="https://github.com/user-attachments/assets/dec62696-a8fe-4e3c-90d5-a995788be537" />

#### ID Stage
<img width="1204" height="605" alt="image" src="https://github.com/user-attachments/assets/acedf998-ee0a-4c57-b5a3-ad013fd0e5ab" />

#### EX Stage
<img width="1193" height="476" alt="image" src="https://github.com/user-attachments/assets/e0d3e0b5-0f69-455f-b0fd-539eac72839f" />

#### MEM Stage
<img width="1225" height="668" alt="image" src="https://github.com/user-attachments/assets/2d42f565-2ffd-4c4b-88e9-2c3e09831a2c" />

#### WB Stage
<img width="1224" height="665" alt="image" src="https://github.com/user-attachments/assets/35dd5634-7c9e-4af8-b093-f73017eba1d0" />

#### Simulation  
(Add screenshot of simulation + relevant code)

> **Note:** This pipeline currently has unresolved hazards due to the architecture. These issues will be addressed in the next chapter.

### Data Hazards

In a 5-stage RISC-V pipeline, a **data hazard** occurs when an instruction needs a register value that has not yet been written back by a previous instruction. For example, if an instruction calculates a value but the next instruction reads the register before the writeback stage completes, the old value is read.  This is a **Read After Write (RAW)** hazard.

(Add image explaining RAW hazard + forwarding paths)

There are several solutions:
- Insert **NOPs** manually in assembly  
- Have the CPU **stall** pipeline stages  
- Implement **Data Forwarding**

**Data Forwarding** checks if the required register value is already computed inside the pipeline. If it exists in `EX`, `MEM`, or `WB` (priority `EX` > `MEM` > `WB`), the value is forwarded directly to the operator inputs of `IF_ID buffer`, bypassing the old value in the register file. This is the fastest solution, as it avoids stalling, but it increases hardware complexity, area, and power consumption.

Our implementation:

> **Note:** In our current implimentation `Load` instructions aren't forwarded, this can still happen for the `MEM` and `WB` stage. However as in the `EX` stage the memory has not been acsessed yet so the data can not be forwarded and the instruction will have to be stalled.

(Add screenshot of forwarding unit code)  
(Add schematic showing forwarding logic)
