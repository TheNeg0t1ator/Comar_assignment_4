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
