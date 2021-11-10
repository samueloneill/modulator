----------------------------------------------------------------------------------
-- Company: UoP
-- Team: Team 29 - Sam O 879282 - Dwight M 879243
-- Engineer: Sam O'Neill
--
-- Create Date: 20.11.2020	16:32:37
-- Module Name: T29_M3_counter3 - Behavioral
-- Project Name: Digital Modulator/Demodulator
-- Target Devices: Basys 3
-- Description: 0 to 3 counter for digit selection of the 7-segment display
--
-- Revision:
-- Revision 1.0 - File Created
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity T29_M3_counter3 is
  generic(g_width: natural);
  port (i_clk, i_CE250Hz, i_reset: in std_logic;
        o_counter3Out: out std_logic_vector(g_width-1 downto 0));
end T29_M3_counter3; 

architecture Behavioral of T29_M3_counter3 is
  signal r_count: std_logic_vector(g_width-1 downto 0) := (others => '0');
begin
  -- Counter process
    countProc: process( i_clk, i_CE250Hz )
    begin
      if(rising_edge(i_clk)) then 
        if i_CE250Hz = '1' then 
          if(i_reset = '0') then
            -- Convert counter to integer, increment, and convert back to slv
            r_count <= std_logic_vector(unsigned(r_count) + 1) ;
          else
            r_count <= "00";   -- Reset counter when reset input is detected
          end if;
        end if;
      end if;  
    end process ;

  -- Assign counter value to output
  o_counter3Out <= r_count;
end architecture;