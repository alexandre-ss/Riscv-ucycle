library ieee;
use ieee.std_logic_1164.all;

entity ula_control is
    port (  instruction: in std_logic_vector(9 downto 0);
            alu_op :     in std_logic_vector(2 downto 0);
            alu_ctr :    out std_logic_vector(3 downto 0));
end ula_control;

architecture operacoes of ula_control is
    signal funct7 : std_logic_vector(6 downto 0);
    signal funct3 : std_logic_vector(2 downto 0);
    begin
    
    funct7 <= instruction(9 downto 3);
    funct3 <= instruction(2 downto 0);
    process(funct7, funct3, alu_op) begin
        case alu_op is
            when "000" =>    -- R-type
                case funct7 is
                    when "0000000" =>
                        case funct3 is
                            when "000" => -- ADD
                                alu_ctr <= "0000";
                            when "001" => -- SLL
                                alu_ctr <= "0101";
                            when "010" => -- SLT
                                alu_ctr <= "1000";
                            when "011" => -- SLTU
                                alu_ctr <= "1001";
                            when "100" => -- XOR
                                alu_ctr <= "0100";
                            when "101" => -- SRL
                                alu_ctr <= "0110";
                            when "110" => -- OR
                                alu_ctr <= "0011";
                            when others => -- 111 AND
                                alu_ctr <= "0010";
                        end case;
                    when others =>  -- Casos 0100000
                        case funct3 is
                            when "000" => -- SUB
                                alu_ctr <= "0001";
                            when others => -- 101 SRA
                                alu_ctr <= "0111";
                        end case;
                end case;
            when "001" =>    -- I-type
                case funct3 is
                    when "000" =>   -- ADDI
                        alu_ctr <= "0000";
                    when "001" =>   -- SLLI
                        alu_ctr <= "0101";
                    when "010" =>   -- SLTI
                        alu_ctr <= "1000";
                    when "011" =>   -- SLTIU
                        alu_ctr <= "1001";
                    when "100" =>   -- XORI
                        alu_ctr <= "0100";
                    when "101" =>   -- SRLI ou SRAI
                        case funct7 is
                            when "0000000" =>   -- SRLI
                                alu_ctr <= "0110";
                            when others =>  -- 0100000 SRAI
                                alu_ctr <= "0111";
                        end case;
                    when "110" =>   -- ORI
                        alu_ctr <= "0011";
                    when others =>   -- 111 ANDI
                        alu_ctr <= "0010";
                end case;
            when "010" =>
                        alu_ctr <= "0000";  -- SW - LW - LUI
                        
            when "011" =>    -- Branch
                case funct3 is --INVERTIDOS PARA QUANDO ACONTEÇA O Z SEJA 1 E O AND FAÇA O BRANCH
                    when "000" =>   -- BEQ
                        alu_ctr <= "1101";  -- SNE
                    when "001" =>   -- BNE
                        alu_ctr <= "1100";  -- SEQ
                    when "100" =>   -- BLT
                        alu_ctr <= "1010";  -- SGE                        
                    when "101" =>   -- BGE
                        alu_ctr <= "1000";  -- SLT
                    when others =>
                        alu_ctr <= "1111";
                end case;
            when others =>
                alu_ctr <= "XXXX";
        end case;
    end process;
end operacoes;
