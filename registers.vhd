library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity registers is
  port (rs1, rs2, rd : in STD_LOGIC_VECTOR(4 downto 0); -- endereço dos registradores de entrada
	    write_data: in STD_LOGIC_VECTOR(31 downto 0); -- dado a ser escrito no registrador
	    reg_write, clock: in STD_LOGIC; -- write enable e clock
        read_data_1, read_data_2: out STD_LOGIC_VECTOR(31 downto 0):= (others => '0')); -- valor de saída após a leitura dos registradores
end registers;

architecture operacoes of registers is
    Type breg is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
    signal regs : breg := (others => x"00000000");

    begin
    process(clock)
        begin
        if rising_edge(clock) then
            if (reg_write = '1') and (rd /= "00000") then
                regs(to_integer(unsigned(rd))) <= write_data;
            end if;
        end if;
    end process;
        read_data_1 <= regs(to_integer(unsigned(rs1)));
        read_data_2 <= regs(to_integer(unsigned(rs2)));
end operacoes;