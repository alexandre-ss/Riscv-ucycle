library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use std.textio.all;
  
entity data_rv is
	port (
            clock : in std_logic;
            we : in std_logic;
            address : in std_logic_vector(7 downto 0);
            datain : in std_logic_vector(31 downto 0);
            dataout : out std_logic_vector(31 downto 0));
end data_rv;

architecture arch of data_rv is
signal read_address : std_logic_vector(7 downto 0);
constant ram_depth : natural := 256;
constant ram_width : natural := 32;
 
type ram_type is array (ram_depth - 1 downto 0)
    of std_logic_vector(ram_width - 1 downto 0);
  
impure function init_ram_hex return ram_type is
    file text_file : text open read_mode is "data.txt";
    variable text_line : line;
    variable ram_content : ram_type;
  begin
      for i in 0 to ram_depth - 1 loop
          if(not endfile(text_file)) then
              readline(text_file, text_line);
              hread(text_line, ram_content(i));
          else
              exit;
          end if;
      end loop; 
      return ram_content;
end function;
  
  signal ram : ram_type := init_ram_hex;
  
      begin	
          process(clock, we) begin
              if rising_edge(clock) then
                  if we = '1' then
                      ram(to_integer(unsigned(address))/4) <= datain;
                  end if;
              end if;
              read_address <= address;
          end process;
      dataout <= ram(to_integer(unsigned(read_address))/4);
          
        
end arch;
