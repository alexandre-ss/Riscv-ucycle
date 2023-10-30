library ieee;
use ieee.std_logic_1164.all;

entity control is
  port (
        opcode: in STD_LOGIC_VECTOR(6 downto 0);
        branch, mem_read, mem_to_reg, mem_write, alu_src, reg_write, jal, jalr: out STD_LOGIC; -- sinais de controle
        lui: out STD_LOGIC_VECTOR(4 downto 0);
        alu_op: out std_logic_vector(2 downto 0):= (others => '0'));
end control;

architecture operacoes of control is
begin
    process(opcode)
        begin
        case opcode is
            when "0110011" => -- R-type
                alu_src    <= '0';
                mem_to_reg <= '0';
                reg_write  <= '1';
                mem_read   <= '0';
                mem_write  <= '0';
                branch     <= '0';
                alu_op     <= "000";
                jal        <= '0';
                jalr       <= '0';  
                lui        <= "11111";

            when "0010011" => -- I-type
                alu_src    <= '1';
                mem_to_reg <= '0';
                reg_write  <= '1';
                mem_read   <= '0';
                mem_write  <= '0';
                branch     <= '0';
                alu_op     <= "001";
                jal        <= '0';
                jalr       <= '0';  
                lui        <= "11111";

            when "0000011" => -- LW
                alu_src    <= '1';
                mem_to_reg <= '1';
                reg_write  <= '1';
                mem_read   <= '1';
                mem_write  <= '0';
                branch     <= '0';
                alu_op     <= "010";
                jal        <= '0';
                jalr       <= '0';  
                lui        <= "11111";

            when "0100011" => -- SW
                alu_src    <= '1';
                mem_to_reg <= '0'; -- Dont care
                reg_write  <= '0';
                mem_read   <= '0';
                mem_write  <= '1';
                branch     <= '0';
                alu_op     <= "010";
                jal        <= '0';
                jalr       <= '0';  
                lui        <= "11111";

            when "1100011" => --Branchs
                alu_src    <= '0';
                mem_to_reg <= '0'; --dont care
                reg_write  <= '0';
                mem_read   <= '0';
                mem_write  <= '0';
                branch     <= '1';
                alu_op     <= "011";
                jal        <= '0';
                jalr       <= '0';
                lui        <= "11111";

            when "1101111" => --JAL
                alu_src    <= 'X';
                mem_to_reg <= '0'; --dont care
                reg_write  <= '1';
                mem_read   <= '0';
                mem_write  <= '0';
                branch     <= '0';
                alu_op     <= "XXX";
                jal        <= '1'; 
                jalr       <= '0';
                lui        <= "11111";

            when "1100111" => --JALR
                alu_src    <= 'X';
                mem_to_reg <= '0'; --dont care
                reg_write  <= '0';
                mem_read   <= '0';
                mem_write  <= '0';
                branch     <= '0';
                alu_op     <= "XXX";
                jal        <= '1';
                jalr       <= '1'; 
                lui        <= "11111";

            when "0110111" => --LUI
                alu_src    <= '1';
                mem_to_reg <= '0'; --dont care
                reg_write  <= '1';
                mem_read   <= '0';
                mem_write  <= '0';
                branch     <= '0';
                alu_op     <= "010";
                jal        <= '0';
                jalr       <= '0'; 
                lui        <= "00000";

            when others =>
                alu_src    <= 'X';
                mem_to_reg <= 'X'; 
                reg_write  <= 'X';
                mem_read   <= 'X';
                mem_write  <= 'X';
                branch     <= 'X';
                alu_op     <= "XXX";
                jal        <= 'X';
                jalr       <= 'X';  
                lui        <= "XXXXX";

        end case;
    end process;
end operacoes;
