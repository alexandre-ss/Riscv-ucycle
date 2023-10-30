library ieee;
use ieee.std_logic_1164.all;

entity or_0 is
  port (a, b: in STD_LOGIC;
        x: out STD_LOGIC);
end or_0;

architecture operacoes of or_0 is
begin
    x <= a or b;
end operacoes;
