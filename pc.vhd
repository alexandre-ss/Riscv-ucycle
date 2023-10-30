library ieee;
use ieee.std_logic_1164.all;

entity pc is
  port (
        clock: in STD_LOGIC;
        address_in: in STD_LOGIC_VECTOR(31 downto 0);
        address_out: out STD_LOGIC_VECTOR(31 downto 0) := (others => '0')
  );
end pc;

architecture operacoes of pc is
begin
    process(clock)
        begin
        if rising_edge(clock) then
            address_out <= address_in;
        end if;
    end process;
end operacoes;
