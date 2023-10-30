library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;

entity unicycle is
    port(clock : in STD_LOGIC);
end unicycle;

architecture operacoes of unicycle is
    -- ================================================== Components ==================================================

    component rom_rv is
        port (address : in STD_LOGIC_VECTOR(31 downto 0);
              dataout : out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component registers is
        port (rs1, rs2, rd : in STD_LOGIC_VECTOR(4 downto 0);
              write_data: in STD_LOGIC_VECTOR(31 downto 0);
              reg_write, clock: in STD_LOGIC;
              read_data_1, read_data_2: out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component control is
        port (
              opcode: in STD_LOGIC_VECTOR(6 downto 0);
              branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write, jal, jalr: out STD_LOGIC;
              alu_op: out std_logic_vector(2 downto 0));
    end component;

    component genImm32 is port(
                instr: in std_logic_vector(31 downto 0);
                imm32: out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component ula_control is
        port (  instruction: in std_logic_vector(9 downto 0);
                alu_op :     in std_logic_vector(2 downto 0);
                alu_ctr :    out std_logic_vector(3 downto 0));
    end component;

    component mux is
        port (a, b: in STD_LOGIC_VECTOR(31 downto 0);
              s: in STD_LOGIC;
              x: out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component ulaRV is
        port (  opcode : in std_logic_vector(3 downto 0);
                A, B : in std_logic_vector(31 downto 0);
                Z : out std_logic_vector(31 downto 0);
                zero : out std_logic);
    end component;

    component shift_left_func is
        port (      
              a: in STD_LOGIC_VECTOR(31 downto 0);
              x: out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component adder is
        port (a, b: in STD_LOGIC_VECTOR(31 downto 0);
              x: out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component and_0 is
        port (a, b: in STD_LOGIC;
              x: out STD_LOGIC);
    end component;

    component data_rv is
        port (
                clock : in std_logic;
                we : in std_logic;
                address : in std_logic_vector(7 downto 0);
                datain : in std_logic_vector(31 downto 0);
                dataout : out std_logic_vector(31 downto 0));
    end component;

    component pc is
        port (
              clock: in STD_LOGIC;
              address_in: in STD_LOGIC_VECTOR(31 downto 0);
              address_out: out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    component mux4 is
        port (a, b, c: in STD_LOGIC_VECTOR(31 downto 0);
          s: in STD_LOGIC_VECTOR(1 downto 0);
          x: out STD_LOGIC_VECTOR(31 downto 0));
    end component;

    component or_0 is
        port (a, b: in STD_LOGIC;
              x: out STD_LOGIC);
    end component;

    -- ================================================== Signals ==================================================

    -- rom_rv
    signal uni_dataout : STD_LOGIC_VECTOR(31 downto 0);

    -- registers
    signal uni_read_data_1, uni_read_data_2 : STD_LOGIC_VECTOR(31 downto 0);

    -- control
    signal uni_branch, uni_mem_read, uni_mem_to_reg, uni_mem_write, uni_alu_src, uni_reg_write, uni_jal, uni_jalr: std_logic;
    signal uni_aluop : std_logic_vector(2 downto 0);

    -- genimm32
    signal uni_instruction_genimm32: STD_LOGIC_VECTOR(9 downto 0);
    signal uni_imm32: STD_LOGIC_VECTOR(31 downto 0);

    -- ula_control
    signal uni_alu_ctr: std_logic_vector(3 downto 0);

    -- mux_alu
    signal uni_mux_alu_out: STD_LOGIC_VECTOR(31 downto 0);

    -- ulaRV
    signal uni_Z: std_logic_vector(31 downto 0);
    signal uni_zero : std_logic;

    -- shift_left
    signal uni_shift_left_out: std_logic_vector(31 downto 0);

    -- add_imm32
    signal uni_adder_imm32_out: STD_LOGIC_VECTOR(31 downto 0);

    -- add_pc
    signal uni_adder_pc_out: STD_LOGIC_VECTOR(31 downto 0);

    -- mux_pc
    signal uni_mux_pc_out: STD_LOGIC_VECTOR(31 downto 0);

    -- and_pc
    signal uni_and_pc_out: std_logic;

    -- data_rv
    signal uni_data_rv_out: std_logic_vector(31 downto 0);

    -- mux_data_rv
    signal uni_mux_data_rv_out: std_logic_vector(31 downto 0);

    -- pc
    signal uni_pc_out: std_logic_vector(31 downto 0);
    signal uni_pc_aux: std_logic_vector(31 downto 0);

    -- or_pc
    signal uni_or_pc_out: std_logic;

    -- mux4
    signal uni_mux4_out: STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal uni_mux4_in: STD_LOGIC_VECTOR(1 downto 0);

    --mux jalr
    signal uni_mux_jalr_out: std_logic_vector(31 downto 0);

    begin
        -- Pc
        uni_pc: pc port map(clock, uni_mux_pc_out, uni_pc_out);

        -- Rom
        uni_pc_aux <= std_logic_vector(shift_right(unsigned(uni_pc_out), 2));
        uni_rom_rv: rom_rv port map(uni_pc_aux, uni_dataout);

        -- Banco de registradores
        uni_registers: registers port map(uni_dataout(19 downto 15), uni_dataout(24 downto 20), uni_dataout(11 downto 7), uni_mux_data_rv_out, uni_reg_write, clock, uni_read_data_1, uni_read_data_2);

        -- Controladora
        uni_control: control port map(uni_dataout(6 downto 0), uni_branch, uni_mem_read, uni_mem_to_reg, uni_mem_write, uni_alu_src, uni_reg_write,  uni_jal, uni_jalr, uni_aluop);

        -- Gerador de imediatos
        uni_genImm32: genImm32 port map(uni_dataout, uni_imm32);

        -- Controladora da ula
        uni_instruction_genimm32 <= uni_dataout(31 downto 25) & uni_dataout(14 downto 12); 
        uni_ula_control: ula_control port map(uni_instruction_genimm32, uni_aluop, uni_alu_ctr);

        -- Mux que entra na ula
        uni_mux_alu: mux port map(uni_read_data_2, uni_imm32, uni_alu_src, uni_mux_alu_out);

        -- Ula
        uni_ulaRV: ulaRV port map(uni_alu_ctr, uni_read_data_1, uni_mux_alu_out, uni_Z, uni_zero);

        -- Shift left, que na teoria iria deslocar 1x para a esquerda
        uni_shift_left: shift_left_func port map(uni_imm32, uni_shift_left_out);

        -- Mux  pra verificar se é um jal
        uni_mux_jalr: mux port map(uni_pc_out, uni_read_data_1, uni_jalr, uni_mux_jalr_out);

        -- Somador que soma o imediato com um endereço vindo do pc
        uni_adder_imm32: adder port map(uni_mux_jalr_out, uni_shift_left_out, uni_adder_imm32_out);

        -- Somador que faz o pc+4
        uni_adder_pc: adder port map(uni_pc_out, x"00000004", uni_adder_pc_out);

        -- Operaçõo end usada para saltos condicionais ou incondicionais (branches e jumps)
        uni_and_mux_pc: and_0 port map(uni_branch, uni_zero, uni_and_pc_out);

        -- Ou para verificar a existência do jal
        uni_or_mux_pc: or_0 port map(uni_jal, uni_and_pc_out, uni_or_pc_out);

        -- Mux para retornar para o pc o pc+4 ou o endereço de um salto realizado
        uni_mux_pc: mux port map(uni_adder_pc_out, uni_adder_imm32_out, uni_or_pc_out, uni_mux_pc_out);

        -- Memória ram
        uni_data_rv: data_rv port map(clock, uni_mem_write, uni_Z(7 downto 0), uni_read_data_2, uni_data_rv_out); 

        -- Mux na saída da memória ram que será conectado ao dado para ser escrito no registrador 
        uni_mux4_in <= uni_jal & uni_mem_to_reg;
        uni_mux_data_rv: mux4 port map(uni_Z, uni_data_rv_out, uni_adder_pc_out, uni_mux4_in, uni_mux_data_rv_out);
end operacoes;