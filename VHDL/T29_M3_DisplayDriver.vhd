----------------------------------------------------------------------------------
-- Company: UoP
-- Team: Team 29 - Sam O 879282 - Dwight M 879243
-- Engineer: Sam O'Neill/Dwight Morrison
--
-- Create Date: 20.11.2020	18:12:32
-- Module Name: T29_M3_DisplayDriver - Behavioral
-- Project Name: Digital Modulator/Demodulator
-- Target Devices: Basys 3
-- Description: 7-segment display driver entity consisting of a digit selector and BCD decoder
--
-- Revision:
-- Revision 1.0 - File Created
-- Revision 1.1 - Made several changes to digit selector to fit inputs from DG
-- Revision 1.2 - Added display select switches
-- Revision 1.3 - Changed digitSelect process to incorporate new display options
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity T29_M3_DisplayDriver is
  port (i_dataMode: in std_logic_vector(3 downto 0);     -- Data selection mode from DG
        i_Symbol: in std_logic_vector(1 downto 0);       -- Data represented as symbols from SC
        i_dataValue: in std_logic_vector(3 downto 0);    -- Data as 4bit number, used for displaying digit 3 (data value)
        i_digitSelect: in std_logic_vector(1 downto 0);  -- 0-3 counter output to choose digit to address
        o_segAnodes: out std_logic_vector(3 downto 0);   
        o_segCathodes: out std_logic_vector(6 downto 0);
        i_qtx_b, i_itx_b: in std_logic_vector(7 downto 0);  -- Data from modulator
        i_qrx_b, i_irx_b: in std_logic_vector(7 downto 0);  -- Data from error chanel 
        i_datatx_b, i_datarx_b: in std_logic_vector(3 downto 0); -- Data values before/after transmission
        i_sw9, i_sw8, i_sw7, i_freezeBtn: in std_logic := '0');
end T29_M3_DisplayDriver; 

architecture behavioral of T29_M3_DisplayDriver is
    signal r_digitShown: std_logic_vector(3 downto 0);   -- The current digit being addressed
    signal r_dispSel: std_logic_vector(2 downto 0); -- The display select switches assigned to a single vector
    signal i_qtx_a, i_qrx_a, i_datarx_a, i_datatx_a, i_itx_a, i_irx_a: std_logic_vector(7 downto 0);
begin
    switches: process (i_sw9, i_sw8, i_sw7)
    begin
        r_dispSel <= (2 => i_sw9, 1 => i_sw8, 0 => i_sw7);
    end process;

    -- Digit selector - chooses which digit to address and controls anodes
    digitSelect: process( i_digitSelect, i_dataMode, r_dispSel)
    begin              
        case( i_digitSelect ) is
            when "00" =>                                                -- Digit 1 (rightmost) 
                o_segAnodes <= "1110";
                case (r_dispSel) is
                    when "000" | "100" => r_digitShown <= "000" & i_Symbol(0);
                    when "001" => r_digitShown <= i_Qtx_A(3 downto 0);
                    when "010" => r_digitShown <= i_DataRX_A(3 downto 0);
                    when "011" => r_digitShown <= i_Qrx_A(3 downto 0);
                    when "101" => r_digitShown <= i_Qtx_B(3 downto 0);
                    when "110" => r_digitShown <= i_DataRX_B;
                    when "111" => r_digitShown <= i_Qrx_B(3 downto 0);
                    when others => r_digitShown <= "0000";
                end case;
            when "01" =>                                                -- Digit 2 
                o_segAnodes <= "1101";
                case (r_dispSel) is
                    when "000" | "100" => r_digitShown <= "000" & i_Symbol(1);
                    when "001" => r_digitShown <= i_Qtx_A(7 downto 4);
                    when "010" => r_digitShown <= i_DataRX_A(7 downto 4);
                    when "011" => r_digitShown <= i_Qrx_A(7 downto 4);
                    when "101" => r_digitShown <= i_Qtx_B(7 downto 4);
                    when "110" => r_digitShown <= "0000";
                    when "111" => r_digitShown <= i_Qrx_B(7 downto 4);
                    when others => r_digitShown <= "0000";
                end case;

            when "10" =>                                                -- Digit 3 
                o_segAnodes <= "1011";
                case (r_dispSel) is
                    when "000" | "100" => r_digitShown <= i_dataValue;
                    when "001" => r_digitShown <= i_Itx_A(3 downto 0);
                    when "010" => r_digitShown <= i_DataTX_A(3 downto 0);
                    when "011" => r_digitShown <= i_Irx_A(3 downto 0);
                    when "101" => r_digitShown <= i_Itx_B(3 downto 0);
                    when "110" => r_digitShown <= "0000";
                    when "111" => r_digitShown <= i_Irx_B(3 downto 0);
                    when others => r_digitShown <= "0000";
                end case;            
            when "11" =>                                                -- Digit 4 (leftmost) 
                o_segAnodes <= "0111";
                case (r_dispSel) is
                    when "000" | "100" => r_digitShown <= i_dataMode;
                    when "001" => r_digitShown <= i_Itx_A(7 downto 4);
                    when "010" => r_digitShown <= i_DataTX_A(7 downto 4);
                    when "011" => r_digitShown <= i_Irx_A(7 downto 4);
                    when "101" => r_digitShown <= i_Itx_B(7 downto 4);
                    when "110" => r_digitShown <= i_DataTX_B;
                    when "111" => r_digitShown <= i_Irx_B(7 downto 4);
                    when others => r_digitShown <= "0000";
                end case;

            when others => r_digitShown <= (others => '0'); o_segAnodes <= (others => '1');
        end case ;
    end process ;
    
    -- BCD to 7seg decoder - instructs display which number/digit to show    
    with r_digitShown select o_segCathodes <= 
        "0000001" when "0000", -- 0
        "1001111" when "0001", -- 1
        "0010010" when "0010", -- 2
        "0000110" when "0011", -- 3
        "1001100" when "0100", -- 4
        "0100100" when "0101", -- 5
        "0100000" when "0110", -- 6
        "0001111" when "0111", -- 7
        "0000000" when "1000", -- 8
        "0000100" when "1001", -- 9
        "0000010" when "1010", -- a
        "1100000" when "1011", -- b
        "0110001" when "1100", -- c
        "1000010" when "1101", -- d
        "0110000" when "1110", -- e
        "0111000" when "1111", -- f
        "1111111" when others; -- all off
end architecture;