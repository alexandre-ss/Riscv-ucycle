library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
  
entity rom_rv is
	port (address : in std_logic_vector(31 downto 0);
	      dataout : out std_logic_vector(31 downto 0):= (others => '0'));
end rom_rv;

architecture arch of rom_rv is
constant rom_depth : natural := 256;
constant rom_width : natural := 32;
 
type rom_type is array (rom_depth - 1 downto 0)
  of std_logic_vector(rom_width - 1 downto 0);

impure function init_rom_hex return rom_type is
  file text_file : text open read_mode is "instruction.txt";
  variable text_line : line;
  variable rom_content : rom_type;
begin
  for i in 0 to rom_depth - 1 loop
    if(not endfile(text_file)) then
      readline(text_file, text_line);
      hread(text_line, rom_content(i));
    else
      exit;
    end if;
  end loop; 
  return rom_content;
end function;

signal mem : rom_type := init_rom_hex;
begin	
	dataout <=  mem(to_integer(unsigned(address)));
end arch;