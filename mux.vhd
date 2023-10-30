library ieee;
use ieee.std_logic_1164.all;

entity mux is
  port (a, b: in STD_LOGIC_VECTOR(31 downto 0);
    s: in STD_LOGIC;
    x: out STD_LOGIC_VECTOR(31 downto 0):= (others => '0'));
end mux;

architecture operacoes of mux is
begin
with s select
    x <= a when '0',
        b when others;
end operacoes;