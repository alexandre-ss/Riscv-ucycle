library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity adder is
  port (a, b: in STD_LOGIC_VECTOR(31 downto 0);
        x: out STD_LOGIC_VECTOR(31 downto 0):= (others => '0'));
end adder;

architecture operacoes of adder is
begin
    x <= std_logic_vector(to_integer(unsigned(a)) + signed(b)); --caso dê erro pode ser o signed
end operacoes;
