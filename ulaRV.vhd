library ieee;
USE ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ulaRV is
  port (
    opcode : in std_logic_vector(3 downto 0);
    A, B : in std_logic_vector(31 downto 0);
    Z : out std_logic_vector(31 downto 0);
  	zero : out std_logic);
end ulaRV;

architecture ula of ulaRV is
	signal Z_aux : std_logic_vector(31 downto 0);
	signal zero_aux : std_logic;
    
	begin process(opcode, A, B, Z_aux, zero_aux)
	begin
    	-- Switch case do OpCode
		case opcode is
			when b"0000" =>		-- ADD
				Z_aux <= std_logic_vector(signed(A) + signed(B));
			when b"0001" =>		-- SUB
				Z_aux <= std_logic_vector(signed(A) - signed(B));
			when b"0010" =>		-- AND
				Z_aux <= A and B;
			when b"0011" =>		-- OR
				Z_aux <= A or B;
			when b"0100" =>		-- XOR
				Z_aux <= A xor B;
			when b"0101" =>		-- SLL
				Z_aux <= std_logic_vector(shift_left(signed(A), to_integer(unsigned(B))));
			when b"0110" =>		-- SRL
				Z_aux <= std_logic_vector(shift_right(unsigned(A), to_integer(unsigned(B))));
			when b"0111" =>		-- SRA
				Z_aux <= std_logic_vector(shift_right(signed(A), to_integer(unsigned(B))));
			when b"1000" =>		-- SLT
				if signed(A) < signed(B) then
					Z_aux <= x"00000001";
				else
					Z_aux <= x"00000000";
				end if;
			when b"1001" =>		-- SLTU
				if unsigned(A) < unsigned(B) then
					Z_aux <= x"00000001";
				else
					Z_aux <= x"00000000";
				end if;
			when b"1010" =>		-- SGE
				if signed(A) >= signed(B) then
					Z_aux <= x"00000001";
				else
					Z_aux <= x"00000000";
				end if;
			when b"1011" =>		-- SGEU
				if unsigned(A) >= unsigned(B) then
					Z_aux <= x"00000001";
				else
					Z_aux <= x"00000000";
				end if;
			when b"1100" =>		-- SEQ
				if A = B then
					Z_aux <= x"00000001";
				else
					Z_aux <= x"00000000";
				end if;
			when b"1101" =>		-- SNE
				if A /= B then
					Z_aux <= x"00000001";
				else
					Z_aux <= x"00000000";
				end if;
			when others =>
				Z_aux <= x"00000000";
		end case;
        
        -- Indicacao de zero na saida
		if Z_aux = x"00000000" then
			zero_aux <= '1';
        else
        	zero_aux <= '0';
		end if;
        
        -- Atribuicao das saidas da ULA
		Z <= Z_aux;
		zero <= zero_aux;
	end process;
end ula;