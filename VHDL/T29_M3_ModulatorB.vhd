----------------------------------------------------------------------------------
-- Company: UoP
-- Team: Team 29 - Sam O 879282 - Dwight M 879243
-- Engineer: Sam O'Neill
--
-- Create Date: 07.01.2021	13:04:01
-- Module Name: T29_M3_ModulatorB - Behavioral
-- Project Name: Digital Modulator/Demodulator
-- Target Devices: Basys 3
-- Description: Entity to modulate data using scheme B
--
-- Revision:
-- Revision 1.0 - File Created
-- Revision 1.1 - Added direction function to fix problem with incorrect outputs
-- Revision 1.2 - Added CE16Hz to control data output 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.std_logic_signed.all;

entity T29_M3_ModulatorB is
  Port (i_clk, i_CE2Hz, i_CE16Hz: in std_logic;
        i_Symbol: in std_logic_vector(1 downto 0);
        o_Idata, o_Qdata: inout std_logic_vector(7 downto 0):=x"80";   -- Output TX data on every clock pulse
        o_I_tx, o_Q_tx: out std_logic_vector(7 downto 0):= x"80");     -- Output TX data on every CE16Hz pulse
end T29_M3_ModulatorB;

architecture Behavioral of T29_M3_ModulatorB is
    signal r_count: integer range 0 to 195313 := 0;
    signal last_direction: integer := 1;

    -- Direction function decides the starting direction of each waveform depending on input signal
    function direction (sym:std_logic_vector(1 downto 0)) return integer is
    begin
        case(sym) is
            when "00" => return 1;
            when "01" => return -1;
            when "10" => return 1;
            when "11" => return -1;
            when others => report "unreachable" severity failure;
        end case;
    end function;
begin
    -- Main process constantly outputs data in triangular waveforms
    process (i_clk, i_CE16Hz)
    begin
        if(falling_edge(i_clk)) then 
            if(i_CE2Hz = '1') then
                last_direction <= direction(sym => i_Symbol); -- Call direction function each time symbol changes
            end if;
            
            if(i_CE16Hz='1')then   -- Output 8 data points per waveform
                o_Q_tx <= o_Qdata;
                o_I_tx <= o_Idata;
            end if;
            if(r_count < 195297) then   -- Counter monitors when the waveform has reached a maximum/minimum value
                r_count <= r_count + 1;
            else
                r_count <= 0;
                case(i_Symbol) is
                when "00" =>
                    if(o_Idata=x"C0") then   -- When maximum is reached, change incrment direction
                        o_Idata <= std_logic_vector(unsigned(o_Idata)-1);
                        last_direction <= -1;
                    elsif(o_Idata=x"40") then   -- When minimum is reached, change increment direction
                        o_Idata <= std_logic_vector(unsigned(o_Idata)+1);
                        last_direction <= +1;
                    else                       -- If min/max are not yet reached, carry on incrementing in same direction
                        o_Idata <= std_logic_vector(unsigned(o_Idata)+last_direction);
                    end if;
                    o_Qdata <= x"80";
                when "10" => 
                    if(o_Qdata=x"C0") then
                        o_Qdata <= std_logic_vector(unsigned(o_Qdata)-1);
                        last_direction <= -1;
                    elsif(o_Qdata=x"40") then
                        o_Qdata <= std_logic_vector(unsigned(o_Qdata)+1);
                        last_direction <= +1;
                    else
                        o_Qdata <= std_logic_vector(unsigned(o_Qdata)+last_direction);
                    end if;
                    o_Idata <= x"80";
                when "11" =>             
                    if(o_Idata=x"C0") then
                        o_Idata <= std_logic_vector(unsigned(o_Idata)-1);
                        last_direction <= -1;
                    elsif(o_Idata=x"40") then
                        o_Idata <= std_logic_vector(unsigned(o_Idata)+1);
                        last_direction <= +1;
                    else
                        o_Idata <= std_logic_vector(unsigned(o_Idata)+last_direction);
                    end if;
                    o_Qdata <= x"80";
                when "01" => 
                    if(o_Qdata=x"C0") then
                        o_Qdata <= std_logic_vector(unsigned(o_Qdata)-1);
                        last_direction <= -1;
                    elsif(o_Qdata=x"40") then
                        o_Qdata <= std_logic_vector(unsigned(o_Qdata)+1);
                        last_direction <= +1;
                    else
                        o_Qdata <= std_logic_vector(unsigned(o_Qdata)+last_direction);
                    end if;
                    o_Idata <= x"80";
                when others => o_Qdata <= x"80";
                end case;
            end if;
        end if;
    end process;
end Behavioral;