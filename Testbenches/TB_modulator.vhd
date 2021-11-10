library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_modulator is
end TB_modulator;

architecture Behavioral of TB_modulator is
    signal clk, CE16, CE2: std_logic := '0';
    signal i_symbol: std_logic_vector(1 downto 0) := "00";
    signal o_qtx, o_qrx, o_itx, o_irx: std_logic_vector(7 downto 0);
    signal i_sw11, i_sw10: std_logic := '0';
begin

    uut : entity work.T29_M3_ModulatorB(Behavioral)
        port map(i_clk=>clk, i_CE16hz=>CE16, i_CE2hz=>CE2, i_symbol=>i_symbol, o_Q_tx=>o_Qtx, o_I_tx=>o_Itx);
        
    enable: entity work.T29_M3_ClockEnable(CEArc)
        generic map(g_maxCount=>10E7, g_increment=>16)
        port map(i_clk=>clk, o_CE=>CE16);
        
    enable2: entity work.T29_M3_ClockEnable(CEArc)
        generic map(g_maxCount=>10E7, g_increment=>2)
        port map(i_clk=>clk, o_CE=>CE2);
        
    channel: entity work.T29_M3_ChannelB(Behavioral)
        port map(i_Itx=>o_itx, i_Qtx=>o_qtx, i_sw11=>i_sw11, i_sw10=>i_sw10, i_clk=>clk, 
        i_CE16Hz=>ce16, o_I_rx=>o_irx, o_Q_rx=>o_qrx);
    
    process(clk)
    begin
        Clk <= not Clk after 5 ns;
    end process;
end Behavioral;
