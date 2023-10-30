library ieee;
use ieee.std_logic_1164.all;

entity and_0 is
  port (a, b: in STD_LOGIC;
        x: out STD_LOGIC);
end and_0;

architecture operacoes of and_0 is
begin
    x <= a and b;
end operacoes;
