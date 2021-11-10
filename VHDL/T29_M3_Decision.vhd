----------------------------------------------------------------------------------
-- Company: UoP
-- Team: Team 29 - Sam O 879282 - Dwight M 879243
-- Engineer: Sam O'Neill
--
-- Create Date: 04.02.2021	10:18:45
-- Module Name: T29_M3_Decision - Behavioral
-- Project Name: Digital Modulator/Demodulator
-- Target Devices: Basys 3
-- Description: Entity to process multiply/accumulate data and decide the original bits
--
-- Revision:
-- Revision 1.0 - File Created
-- Revision 1.1 - Added decision processes
-- Revision 1.2 - Added makePositive function to deal with negative numbers
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity T29_M3_Decision is
  port (i_clk, i_reset, i_CE16Hz, i_CE2Hz: in std_logic := '0';
        i_sum: in integer;
        i_ErrSel: in std_logic_vector(1 downto 0);
        o_Decision: out std_logic_vector(1 downto 0));
end T29_M3_Decision; 

architecture behavioral of T29_M3_Decision is
    signal r_bit0, r_bit0_max, r_bit0_min, r_bit1, r_bit1_max, r_bit1_min: integer;  -- Signals for triangle waveform data
    signal r_line, r_line_max, r_line_min: integer;  -- Signals for straight line waveform data
    -- Signals after subtraction from input sum:
    signal r_sub0, r_sub0_max, r_sub0_min, r_sub1, r_sub1_max, r_sub1_min: integer;
    signal r_subLine, r_subLine_max, r_subLine_min: integer;
    -- Signals after removing negatives:
    signal r_pos0, r_pos0_max, r_pos0_min, r_pos1, r_pos1_max, r_pos1_min: integer;
    signal r_posLine, r_posLine_max, r_posLine_min: integer;
    
    signal r_minimum, r_decision, r_lastDecision: integer;

    -- Function to remove negative values
    function makePositive(value: integer := 0) return integer is 
        variable multiplier: integer := 1;
    begin
        if(value < 0) then
            return value * multiplier;
        else
            return value;
        end if;
    end function;

begin
    -- Decide reference values based on chosen error select mode
    reference: process (i_clk, i_ErrSel, i_reset)
    begin
        if(i_reset = '1') then
            r_bit0 <= 0; r_bit0_max <= 0; r_bit0_min <= 0;
            r_bit1 <= 0; r_bit1_max <= 0; r_bit1_min <= 0;
            r_line <= 0; r_line_max <= 0; r_line_min <= 0;
        elsif(rising_edge(i_clk)) then
            if(i_CE16Hz = '1') then
                case (i_ErrSel) is 
                    when "00" =>
                        r_bit0 <= 143360; r_bit0_max <= 143360; r_bit0_min <= 143360;
                        r_bit1 <= 118784; r_bit1_max <= 118784; r_bit1_min <= 118784;
                        r_line <= 131072; r_line_max <= 131072; r_line_min <= 131072;
                    when "01" =>
                        r_bit0 <= 143360; r_bit0_max <= 159744; r_bit0_min <= 126976;
                        r_bit1 <= 118784; r_bit1_max <= 135168; r_bit1_max <= 102400;
                        r_line <= 131072; r_line_max <= 114688; r_line_min <= 147456;
                    when "10" =>
                        r_bit0 <= 143360; r_bit0_max <= 176128; r_bit0_min <= 110592;
                        r_bit1 <= 118784; r_bit1_max <= 151552; r_bit1_max <= 86016;
                        r_line <= 131072; r_line_max <= 98304; r_line_min <= 163840;
                    when "11" =>
                        r_bit0 <= 143360; r_bit0_max <= 208896; r_bit0_min <= 77824;
                        r_bit1 <= 118784; r_bit1_max <= 182016; r_bit1_min <= 53248;
                        r_line <= 131072; r_line_max <= 196608; r_line_min <= 65536;
                    when others => report "unreachable" severity failure;
                end case;
            end if;
        end if;
    end process;

    -- Subtract reference values from accumulator value, and make sure they are all positive
    subtract : process( i_clk, i_reset, i_sum,
                        r_bit0, r_bit0_max, r_bit0_min, 
                        r_bit1, r_bit1_max, r_bit1_min,
                        r_line, r_line_max, r_line_min)
    begin
        if(i_reset = '1') then
            r_sub0<=0; r_sub0_max<=0; r_sub0_min<=0; r_sub1<=0; r_sub1_max<=0; r_sub1_min<=0;
            r_subLine<=0; r_subLine_max<=0; r_subLine_min<=0;
        elsif(rising_edge(i_clk)) then
            if(i_CE16Hz = '1') then
                r_sub0 <= i_Sum - r_bit0; r_pos0 <= makePositive(value => r_sub0);
                r_sub0_max <= i_Sum - r_bit0_max; r_pos0_max <= makePositive(value => r_sub0_max);
                r_sub0_min <= i_Sum - r_bit0_min; r_pos0_min <= makePositive(value => r_sub0_min);
                r_sub1 <= i_Sum - r_bit1; r_pos1 <= makePositive(value => r_sub1);
                r_sub1_max <= i_Sum - r_bit1_max; r_pos1_max <= makePositive(value => r_sub1_max);
                r_sub1_min <= i_Sum - r_bit1_min; r_pos1_min <= makePositive(value => r_sub1_min);
                r_subLine <= i_Sum - r_line; r_posLine <= makePositive(value => r_subLine);
                r_subLine_max <= i_Sum - r_line_max; r_posLine_max <= makePositive(value => r_subLine_max);
                r_subLine_min <= i_Sum - r_line_min; r_posLine_min <= makePositive(value => r_subLine_min);
            end if; 
        end if;    
    end process ;

    -- Decision processes for choosing a bit
    process( i_clk, i_reset,  
            r_pos0, r_pos0_max, r_pos0_min, 
            r_pos1, r_pos1_max, r_pos1_min,
            r_posLine, r_posLine_max, r_posLine_min)
    begin
        if(i_reset = '1') then
            r_decision <= 0;
            r_minimum <= 0;
        elsif(rising_edge(i_clk)) then
            if(i_CE16Hz = '1') then
                r_minimum <= r_posLine_max;
                if(r_pos1_max < r_minimum) then
                    r_minimum <= r_pos1_max; r_decision <= 0; end if;
                if(r_posLine_max < r_minimum) then
                    r_minimum <= r_posLine_max; r_decision <= 1; end if;
                if(r_pos0_max < r_minimum) then
                    r_minimum <= r_pos0_max; r_decision <= 2; end if;
                if(r_pos1_min < r_minimum) then
                    r_minimum <= r_pos1_min; r_decision <= 3; end if;
                if(r_posLine_min < r_minimum) then
                    r_minimum <= r_posLine_min; r_decision <= 4; end if;
                if(r_pos0_min < r_minimum) then
                    r_minimum <= r_pos0_min; r_decision <= 5; end if;
                if(r_pos1 < r_minimum) then
                    r_minimum <= r_pos1; r_decision <= 6; end if;
                if(r_posLine < r_minimum) then
                    r_minimum <= r_posLine; r_decision <= 7; end if;
                if(r_pos0 < r_minimum) then
                    r_minimum <= r_pos0; r_decision <= 8; end if;
            end if;
            r_lastDecision <= r_decision;
        end if;
    end process;
    decision: process(i_clk, i_CE16Hz, r_lastDecision)
    begin
        if(i_CE16Hz = '1') then
            case(r_lastDecision) is
                when 0 => o_Decision <= "01";
                when 1 => o_Decision <= "11";
                when 2 => o_Decision <= "00";
                when 3 => o_Decision <= "01";
                when 4 => o_Decision <= "11";
                when 5 => o_Decision <= "00";
                when 6 => o_Decision <= "01";
                when 7 => o_Decision <= "11";
                when 8 => o_Decision <= "00";
                when others => o_Decision <= "10";
            end case ;
        end if;
    end process;
end architecture;