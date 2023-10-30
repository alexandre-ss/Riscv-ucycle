library ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity genImm32 is
	port (
	instr : in std_logic_vector(31 downto 0);
	imm32 : out std_logic_vector(31 downto 0) := (others => '0'));
end genImm32;

architecture imm of genImm32 is
	signal imm_temp : std_logic_vector(31 downto 0);
    signal imm_i : std_logic_vector(31 downto 0);
	signal opcode : std_logic_vector(7 downto 0);
	begin
    imm_i <= (31 downto 12 => instr(31)) & instr(31 downto 20);
	opcode <= '0' & instr(6 downto 0);
	process(opcode, imm_temp, imm_i)
		begin
		case opcode is
        	-- R_type:
			when x"33" =>
				imm32 <= x"00000000";
            -- I_type:
			when x"03" =>
				imm32 <= imm_i;
			when x"13" =>
				case instr(14 downto 12) is
					when "001" => -- SLLI
						imm32 <= (31 downto 5 => '0') & instr(24 downto 20); -- shamt
					when "101" => -- SRLI SRAI
						imm32 <= (31 downto 5 => '0') & instr(24 downto 20); -- shamt
					when others =>
						imm32 <= imm_i;
				end case;
			when x"67" =>
				imm32 <= imm_i;
            -- S_type:
			when x"23" =>
				imm32 <= (31 downto 12 => instr(31)) & instr(31 downto 25) & instr(11 downto 7);
            -- SB_type:
			when x"63" => 
				imm32 <= (31 downto 13 => instr(31)) & instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8) & '0';
            -- U_type:
			when x"37" =>
            	imm_temp <= (31 downto 20 => '0') & instr(31 downto 12);
				imm32 <= std_logic_vector(shift_left(signed(imm_temp), 12));
            -- UJ_type:
			when x"6F" =>
				imm32 <= (31 downto 21 => instr(31)) & instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21) & '0';
			-- Others
			when others =>
				imm32 <= x"00000000";
		end case;
	end process;
end imm;