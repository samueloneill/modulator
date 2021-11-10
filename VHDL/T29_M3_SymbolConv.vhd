----------------------------------------------------------------------------------
-- Company: UoP
-- Team: Team 29 - Sam O 879282 - Dwight M 879243
-- Engineer: Sam O'Neill
--
-- Create Date: 21.11.2020	10:01:33
-- Module Name: T29_M3_SymbolConv - Behavioral
-- Project Name: Digital Modulator/Demodulator
-- Target Devices: Basys 3
-- Description: Symbol converter entity to convert 4bit inputs to 2bit outputs
--
-- Revision:
-- Revision 1.0 - File Created
-- Revision 1.1 - Removed counter and replaced with 'tmp' signal
--              - Removed r_Sym signals which were unnecessary as o_Symbol can just be directly addressed
--              - Added 'reset' signal to solve immediate output problem found during simulations
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std;

entity T29_M3_SymbolConv is
    port (i_Data: in std_logic_vector(3 downto 0);
        i_CE2Hz, i_clk: in std_logic;
        o_Symbol: out std_logic_vector(1 downto 0));
end T29_M3_SymbolConv; 

architecture behavioral of T29_M3_SymbolConv is
    signal reset: std_logic := '1';
    signal tmp: std_logic;
begin
    symbolConv : process (i_clk)
    begin
        if rising_edge(i_clk) then
            if (reset = '1') then    -- Checks for tmp bit which is high on the first run, to allow immediate output
                    reset <= '0';   -- Changes reset so that tmp isn't reset to 1
                    tmp <= '1';
                    o_Symbol <= i_Data(3 downto 2);
            elsif (i_CE2Hz = '1') then 
                tmp <= NOT tmp;    -- Invert tmp 
                if (tmp = '0') then
                    o_Symbol <= i_Data(3 downto 2);
                else
                    o_Symbol <= i_Data(1 downto 0);
                end if;
            end if;
        end if;
    end process ;
end architecture;