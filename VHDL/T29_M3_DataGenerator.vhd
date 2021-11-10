----------------------------------------------------------------------------------
-- Company: UoP
-- Team: Team 29 - Sam O 879282 - Dwight M 879243
-- Engineer: Dwight Morrison/Sam O'Neill
--
-- Create Date: 07.12.2020	11:02:57
-- Module Name: T29_M3_DataGenerator - Behavioral
-- Project Name: Digital Modulator/Demodulator
-- Target Devices: Basys 3
-- Description: A 4 bit data generator 
--
-- Revision:
-- Revision 1.0 - File Created
-- Revision 1.1 - Edited DataGeneratorProc, added 0-F and StudentNumber counters
-- Revision 1.2 - Added if/else to switches process to correctly reset D4 when start/stop is pressed
-- Revision 1.3 - Added PRNG
-- Revision 1.4 - Adjusted PRNG to be 4-bits so that it works properly with the display
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity T29_M3_DataGenerator is
  port (i_Sw15, i_Sw14, i_Sw13, i_Sw12, i_StartStop, i_reset: in std_logic := '0';
        i_clk, i_CE1Hz: in std_logic;
        i_Data_Select_bin: inout std_logic_vector(3 downto 0);
        o_DataValues: inout std_logic_vector(3 downto 0));
end T29_M3_DataGenerator;

architecture Behavioral of T29_M3_DataGenerator is
  signal r_countValue: std_logic_vector(3 downto 0) := "0000";
  shared variable r_StuCount: integer range 0 to 5 := 0;
  signal r_StuNum1, r_StuNuM2: std_logic_vector(3 downto 0);
  signal latched: std_logic := '0';
  signal r_random: std_logic_vector(1 to 4) := "0001";
  
  -- Function for selecting student number to output
  function StuNum (r_StuCount:integer; student:std_logic) return std_logic_vector is
  begin
    case(r_StuCount) is
      -- Takes value of StudentCounter and uses it to choose a digit
      when 0 => return "1000";  -- 8
      when 1 => return "0111";  -- 7
      when 2 => return "1001";  -- 9
      when 3 => return "0010";  -- 2
      -- Student 0 = 879282, Student 1 = 879243
      when 4 => 
        if (student = '0') then -- 8 or 4
          return "1000";
        else return "0100"; end if;
      when 5 => 
        if (student = '0') then -- 2 or 3
          return "0010";
        else return "0011"; end if;
      when others => return "0000";
    end case;
  end function;
  
begin

  btn: process(i_StartStop, i_clk)
  begin
    if rising_edge(i_clk) then
        if(i_StartStop = '1') then
            latched <= not latched;
        end if;
    end if;
  end process;
  -- Assigning switch values to a single vector and latching i_StartStop
  switches: process(i_Sw15, i_Sw14, i_Sw13, i_Sw12)
  begin
    if (latched = '0') then
      i_Data_Select_bin <= "0000";
    else
      i_Data_Select_bin <= (3=>i_Sw15, 2=>i_Sw14, 1=>i_Sw13, 0=>i_Sw12);
    end if;
  end process;

  -- DataGenerator process
  DataGeneratorProc: process( i_clk, i_CE1Hz )
  begin
    if(i_reset = '0') then
      if(latched = '1') then 
        if(i_CE1Hz = '1') then
          case (i_Data_Select_bin) is
            when "0000" =>
              o_DataValues <= "0001";  -- Mode 0
            when "0001" =>
              o_DataValues <= "0111";  -- Mode 1
            when "0010" =>
              o_DataValues <= "1110";  -- Mode 2
            when "0011" =>
              o_DataValues <= "1000";  -- Mode 3
            when "0100" =>
              o_DataValues <= r_countValue;  -- Mode 4 (0-F counter)
            when "0101" =>
              o_DataValues <= r_random;  -- Mode 5 (random number)
            when "0110" =>
              o_DataValues <= r_StuNum1;  -- Mode 6 (879282)
            when "0111" =>
              o_DataValues <= r_StuNuM2;  -- Mode 7 (879243)
            when others =>
              o_DataValues <= "0000";  -- Mode 8 (temperature)
          end case; 
        end if;
      else  -- When start/stop is pressed, clear display until pressed again
        o_DataValues <= "0000";
      end if;
    else   -- When reset is pressed, clear display
      o_DataValues <= "0000";
    end if;
  end process ;

  -- 0-F counter
  counter: process (i_clk, i_CE1Hz)
  begin
    if(i_reset = '0') then
      if(rising_edge(i_clk)) then 
        if i_CE1Hz = '1' then 
          r_countValue <= std_logic_vector(unsigned(r_countValue) + 1);
        end if;
      end if;
    else
      r_countValue <= "0000";
    end if;
  end process;

  -- Counter for cycling through student number digits
  StudentCounter: process (i_clk, i_CE1Hz, i_reset)
  begin
      if(rising_edge(i_clk)) then 
          if i_CE1Hz = '1' then 
              if (r_StuCount < 5) then
                  r_StuCount := r_StuCount + 1 ;
              else
                  r_StuCount := 0;
              end if;
              -- Assign current number by calling function with count value and student 0 or 1
              r_StuNum1 <= StuNum(r_StuCount, student => '0');
              r_StuNuM2 <= StuNum(r_StuCount, student => '1');
          end if;
      end if;
  end process;

  -- Pseudo random number generator using LFSR
  prng: process (i_CE1Hz)
    begin
      if(i_CE1Hz = '1') then
        if(i_reset = '1') then
          r_random <= "0001";
        else
          r_random <= (r_random(3) xor r_random(2)) & r_random(1 to 3);
        end if;
      end if;
    end process;
end architecture;