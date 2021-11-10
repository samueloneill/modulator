----------------------------------------------------------------------------------
-- Company: UoP
-- Team: Team 29 - Sam O 879282 - Dwight M 879243
-- Engineer: Sam O'Neill
--
-- Create Date: 09.01.2021	14:46:45
-- Module Name: T29_M3_ChannelB - Behavioral
-- Project Name: Digital Modulator/Demodulator
-- Target Devices: Basys 3
-- Description: Channel block which adds error to transmissions using a PRNG
--
-- Revision:
-- Revision 1.0 - File Created
-- Revision 1.1 - Modified LFSR design to fix problems with random number generation
-- Revision 1.2 - Added error select switches/output processes
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity T29_M3_ChannelB is
  port (i_Itx, i_Qtx: in std_logic_vector(7 downto 0);    -- Input TX data
        i_sw11, i_sw10, i_reset: in std_logic := '0';     -- Input switches
        i_clk, i_CE16Hz: in std_logic := '0';
        o_I_rx, o_Q_rx: out std_logic_vector(7 downto 0) := x"80";  -- Output RX data
        o_errSel: out std_logic_vector (1 downto 0));               -- Output current error select switch configuration for use in other entities
end T29_M3_ChannelB; 

architecture behavioral of T29_M3_ChannelB is
    signal r_errSel: std_logic_vector(1 downto 0) := "00";   
    signal r_random: std_logic_vector(1 to 7) := "0101000";
begin
    -- 7bit LFSR based PRNG
    prng: process (i_clk)
    begin 
        if(rising_edge(i_clk)) then
            if(i_reset = '0') then
                r_random <= (r_random(6) xor r_random(5)) & r_random(1 to 6);
            else
                r_random <= "0101000";
            end if;
        end if;
    end process;

    -- Assigning switch inputs to a single error select vector
    switches: process(i_sw11, i_sw10)
    begin
        r_errSel <= (1=>i_sw11, 0=>i_sw10);
    end process;

    -- Process for checking error mode and dividing output as necessary
    output: process(i_CE16Hz, r_errSel)
    begin
    if(falling_edge(i_CE16Hz)) then
        case(r_errSel) is 
            when "00" =>
                -- no change
                o_Q_rx <= i_Qtx;
                o_I_rx <= i_Itx;
            when "01" =>
                -- +/- 16
                o_Q_rx <= std_logic_vector(signed(i_Qtx) + signed(r_random)/4);
                o_I_rx <= std_logic_vector(signed(i_Itx) + signed(r_random)/4);
            when "10" => 
                -- +/- 32
                o_Q_rx <= std_logic_vector(signed(i_Qtx) + signed(r_random)/2);
                o_I_rx <= std_logic_vector(signed(i_Itx) + signed(r_random)/2);
            when "11" => 
                -- +/- 64
                o_Q_rx <= std_logic_vector(signed(i_Qtx) + signed(r_random));
                o_I_rx <= std_logic_vector(signed(i_Itx) + signed(r_random));
            when others => report "unreachable" severity failure;
        end case;
    end if;
    end process;
    
    o_errsel <= r_errSel;
end architecture;