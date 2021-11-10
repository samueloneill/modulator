----------------------------------------------------------------------------------
-- Company: UoP
-- Team: Team 29 - Sam O 879282 - Dwight M 879243
-- Engineer: Sam O'Neill
-- 
-- Create Date: 19.11.2020 17:24:39
-- Module Name: T29_M3_Debounce - Logic
-- Project Name: Digital Modulator/Demodulator
-- Target Devices: Basys 3
-- Description: A debouncing entity to prevent bouncing inputs
-- 
-- Revision:
-- Revision 1.0 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity T29_M3_Debounce is
    generic (counter_size: integer); -- 20bit counter
    port (i_clk, i_Switch: in std_logic;
          o_Debounced: out std_logic);
end T29_M3_Debounce; 

architecture logic of T29_M3_Debounce is
    signal flipflop: std_logic_vector(1 downto 0);
    signal set: std_logic;
    signal counterOut: std_logic_vector(counter_size downto 0) := (others => '0');
begin
    set <= flipflop(0) xor flipflop(1);  -- compare previous 2 states of switch input

    process(i_clk)
    begin
        if rising_edge(i_clk) then
            flipflop(0) <= i_Switch;  -- FF1 takes current value of switch
            flipflop(1) <= flipflop(0); -- FF2 takes value of FF1 (previous switch)
            if (set = '1') then
                counterOut <= (others => '0');  -- reset counter if FF1 =/= FF2
            elsif (counterOut(counter_size) = '0') then 
                counterOut <= std_logic_vector(unsigned(counterOut) + 1);  -- increment counter if stable time is not reached
            else
                o_Debounced <= flipflop(1);  -- output becomes current switch value when stable time is reached
            end if;
        end if;
    end process;
end architecture;