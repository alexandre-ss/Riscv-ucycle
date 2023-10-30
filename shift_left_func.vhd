library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity shift_left_func is
  port (      
        a: in STD_LOGIC_VECTOR(31 downto 0);
        x: out STD_LOGIC_VECTOR(31 downto 0));
end shift_left_func;

architecture operacoes of shift_left_func is
begin
    x <= std_logic_vector(shift_left(signed(a),0)); --não faz shift pois já está fazendo no genimm32
end operacoes;
