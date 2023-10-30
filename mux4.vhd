library ieee;
use ieee.std_logic_1164.all;

entity mux4 is
  port (a, b, c: in STD_LOGIC_VECTOR(31 downto 0);
        s: in STD_LOGIC_VECTOR(1 downto 0);
        x: out STD_LOGIC_VECTOR(31 downto 0));
end mux4;

architecture operacoes of mux4 is
begin
with s select
    x <= a when "00",
         b when "01",
         c when others; -- 1X
end operacoes;