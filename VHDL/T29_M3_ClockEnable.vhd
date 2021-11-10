----------------------------------------------------------------------------------
-- Company: UoP
-- Team: Team 29 - Sam O 879282 - Dwight M 879243
-- Engineer: Sam O'Neill
--
-- Create Date: 30.11.2020	23:27:23
-- Module Name: T29_M3_ClockEnable - CEArc
-- Project Name: Digital Modulator/Demodulator
-- Target Devices: Basys 3
-- Description: Clock divider to generate clock enable signals
--
-- Revision:
-- Revision 1.0 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity T29_M3_ClockEnable is
    generic (g_maxCount, g_increment: natural);
    port (i_clk: in std_logic;
        o_CE: out std_logic);
end T29_M3_ClockEnable; 

architecture CEArc of T29_M3_ClockEnable is
    signal r_count: natural range 0 to g_maxCount := 0; -- internal counter
begin
    -- Internal counter process
  countProc : process( i_clk )
  begin
    if rising_edge(i_clk) then -- sync on rising edge
      if r_count < g_maxCount - 1 then
        r_count <= r_count + g_increment;  
      else
        r_count <= 0;     
      end if ;
    end if;  
  end process ;

  -- Clock enable generation process
  ceProc : process( r_count, i_clk )
  begin
    if falling_edge(i_clk) then -- sync on rising edge
      if r_count < g_maxCount -1 then
        o_CE <= '0';
      else
        o_CE <= '1';
      end if;  
    end if;  
  end process ;
end architecture;