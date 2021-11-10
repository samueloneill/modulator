----------------------------------------------------------------------------------
-- Company: UoP
-- Team: Team 29 - Sam O 879282 - Dwight M 879243
-- Engineer: Sam O'Neill
--
-- Create Date: 20.01.2021	13:17:51
-- Module Name: T29_M3_Demodulator - Behavioral
-- Project Name: Digital Modulator/Demodulator
-- Target Devices: Basys 3
-- Description: Multiply/accumulate digital demodulator
--
-- Revision:
-- Revision 1.0 - File Created
-- Revision 1.1 - Changed values to integers for easier multiplying/adding
-- Revision 1.2 - Instantiated decision entities
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity T29_M3_Demodulator is
  port (i_clk, i_reset, i_CE16Hz, i_CE2Hz: in std_logic;
        i_IData, i_Qdata: in std_logic_vector(7 downto 0);  -- Input RX data from error channel
        i_ErrSel: in std_logic_vector(1 downto 0);          -- Current error select switch configuration
        o_symbol: out std_logic_vector(1 downto 0);         -- Output resulting symbol after demodulation
        o_DataRX: out std_logic_vector(3 downto 0));        -- Output resulting data value after demodulation
end T29_M3_Demodulator; 

architecture behavioral of T29_M3_Demodulator is
    signal r_counter: integer range 0 to 7;
    signal r_multipliedI, r_multipliedQ: integer;
    signal r_sumI, r_sumQ: integer;
    signal r_intIRX, r_intQRX: integer;
    signal r_DecisionI, r_DecisionQ: std_logic_vector (1 downto 0);
begin
    -- Counter from 0-7 steps once for each of the 8 data points per waveform
    -- Allows synchronising of the demodulation process
    counter: process( i_CE16Hz )
    begin
        if (i_CE16Hz = '1') then 
            r_counter <= r_counter + 1;
        end if;
    end process ;

    -- Converting input data from binary to integers for easier calculations 
    bin_to_int : process( i_clk, i_reset, i_iData, i_Qdata )
    begin
        if(i_reset = '1') then
            r_intIRX <= 0;
            r_intQRX <= 0;
        elsif (rising_edge(i_clk)) then
            r_intIRX <= to_integer(unsigned(i_iData));
            r_intQRX <= to_integer(unsigned(i_QData));
        end if;
    end process;

    -- Multiply input data points with the reference waveform
    -- Reference waveform data points:
    -- 0:128, 1:160, 2:192, 3:160, 4:128, 5:96, 6:64, 7:96
    multiply: process (i_CE16Hz, i_clk)
    begin
        if(i_reset = '1') then
            r_multipliedI <= 0;
            r_multipliedQ <= 0;
        elsif(rising_edge(i_clk)) then
            case r_counter is
                when 0 | 4 => 
                    r_multipliedI <= r_intIRX * 128;
                    r_multipliedQ <= r_intQRX * 128;
                when 1 | 3 => 
                    r_multipliedI <= r_intIRX * 160;
                    r_multipliedQ <= r_intQRX * 160;
                when 2 => 
                    r_multipliedI <= r_intIRX * 192;
                    r_multipliedQ <= r_intQRX * 192;
                when 5 | 7 => 
                    r_multipliedI <= r_intIRX * 96;
                    r_multipliedQ <= r_intQRX * 96;
                when 6 => 
                    r_multipliedI <= r_intIRX * 64;
                    r_multipliedQ <= r_intQRX * 64;
                when others => report "unreachable" severity failure;
            end case;
        end if;
    end process;

    -- Add multiplied data together
    accumulate : process( i_clk, i_CE16Hz, r_multipliedI, r_multipliedQ )
    begin
        if(i_reset = '1') then
            r_sumI <= 0;
            r_sumQ <= 0;
        elsif (rising_edge(i_clk)) then
            if(i_CE16Hz = '1') then
                r_sumI <= r_sumI + r_multipliedI;
                r_sumQ <= r_sumQ + r_multipliedQ;
            end if;
        end if;
    end process;

    -- Decision entities handle the accumulated data and use it to decide what data/symbol was sent
    Decision_I : entity work.T29_M3_Decision(Behavioral)
        port map (i_clk=>i_clk, i_reset=>i_reset, i_CE16Hz=>i_CE16Hz, i_CE2Hz=>i_CE2Hz,
                i_ErrSel=>i_ErrSel, i_sum=>r_SumI, o_Decision=>r_DecisionI);

    Decision_Q : entity work.T29_M3_Decision(Behavioral)
        port map (i_clk=>i_clk, i_reset=>i_reset, i_CE16Hz=>i_CE16Hz, i_CE2Hz=>i_CE2Hz,
                i_ErrSel=>i_ErrSel, i_sum=>r_SumQ, o_Decision=>r_DecisionQ);
end architecture;