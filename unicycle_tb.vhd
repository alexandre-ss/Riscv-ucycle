-- Testbench for mux 2
library IEEE;
use IEEE.std_logic_1164.all;
 
entity testbench is
-- empty
end testbench; 

architecture tb of testbench is

-- DUT component
component unicycle is
    port(clock : in STD_LOGIC);
end component;

-- Sinais para conectar nas entradas e saídas

signal clk: std_logic; 

begin
  -- Connect DUT
  DUT: unicycle port map(clock => clk );

  ClockGen: process
  begin
      clk <= '0';     wait for 5 ps;
      clk <= '1';     wait for 5 ps;
  end process ClockGen;
end tb;
