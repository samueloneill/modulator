library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_DataGen is
end TB_DataGen; 

architecture behavioral of TB_DataGen is
    signal i_Sw15, i_Sw14, i_Sw13, i_Sw12, i_reset: std_logic := '0';
    signal r_StartStop: std_logic := '0';
    signal i_clk, i_CE1Hz: std_logic;
    signal o_DataMode: std_logic_vector(3 downto 0);
    signal o_DataValue: std_logic_vector(3 downto 0);

    constant clk_period: time := 10 ns;
begin
    uut: entity work.T29_M3_DataGenerator(behavioral)
        port map (i_StartStop=>r_StartStop, i_clk=>i_clk, i_CE1Hz=>i_CE1Hz, i_Sw15=>i_Sw15, i_Sw14=>i_Sw14,
                i_Sw13=>i_Sw13, i_Sw12=>i_Sw12, i_reset=>i_reset, i_Data_Select_bin=>o_DataMode, o_DataValues=>o_DataValue);
    
    CE1Hz: entity work.T29_M3_ClockEnable(CEArc)
        generic map (g_maxCount => 10E7, g_increment => 1)
        port map (i_Clk => i_Clk, o_CE => i_CE1Hz);

    -- Clock process definitions
    sysClock_process: process
    begin
        i_Clk <= '0';
        wait for Clk_period/2;
        i_Clk <= '1';
        wait for Clk_period/2;
    end process;
end architecture;