library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_displayDriver is
end TB_displayDriver; 

architecture behavioral of TB_displayDriver is
    signal i_dataMode: std_logic_vector(3 downto 0) := "0001";     -- Testbench uses M2 mode 1 (data = 7, symbols = 01,11)
    signal i_Symbol: std_logic_vector(1 downto 0);
    signal i_dataValue: std_logic_vector(3 downto 0) := "0111";

    signal i_digitSelect: std_logic_vector(1 downto 0);  -- 0-3 counter output

    signal o_segAnodes: std_logic_vector(3 downto 0);   
    signal o_segCathodes: std_logic_vector(6 downto 0);

    signal i_qtx_b, i_itx_b: std_logic_vector(7 downto 0);  -- Data from modulator
    signal i_qrx_b, i_irx_b: std_logic_vector(7 downto 0);  -- Data from error chanel 
    signal i_datatx_b, i_datarx_b: std_logic_vector(3 downto 0); -- Data values before/after transmission
    signal i_sw9, i_sw8, i_sw7, i_Clk, i_freezeBtn, i_reset: std_logic := '0';
    signal w_CE2Hz, w_CE16Hz, w_CE250Hz: std_logic;
    
    constant clk_period: time := 10 ns;

begin
    symbolConv : entity work.T29_M3_SymbolConv(Behavioral)
        port map(i_clk=>i_clk, i_CE2Hz=>w_CE2Hz, i_data=>i_dataValue, o_Symbol=>i_Symbol);

    modulator : entity work.T29_M3_ModulatorB(Behavioral)
        port map (i_clk=>i_clk, i_CE16Hz=>w_CE16Hz, i_Symbol=>i_Symbol, o_Q_tx=>i_Qtx_B, o_I_tx=>i_Itx_B);

    CE2 : entity work.T29_M3_ClockEnable(CEArc)
        generic map (g_maxCount => 10E7, g_increment => 2)
        port map (i_Clk => i_Clk, o_CE => w_CE2Hz);
    
    CE250 : entity work.T29_M3_ClockEnable(CEArc)
        generic map (g_maxCount => 10E7, g_increment => 250)
        port map (i_Clk => i_Clk, o_CE => w_CE250Hz);
    
    CE16 : entity work.T29_M3_ClockEnable(CEArc)
        generic map (g_maxCount => 10E7, g_increment => 16)
        port map (i_Clk => i_Clk, o_CE => w_CE16Hz);

    Channel : entity work.T29_M3_ChannelB(Behavioral)
        port map (i_Itx=>i_Itx_B, i_Qtx=>i_Qtx_B, i_CE16Hz=>w_CE16Hz, i_clk=>i_clk,
                  o_Irx=>i_Irx_B, o_Qrx=>i_Qrx_B);
    
    counter_0_to_3: entity work.T29_M3_counter3(Behavioral)
        generic map(g_width=>2)
        port map(i_clk=>i_clk, i_CE250Hz=>w_CE250Hz, o_counter3Out=>i_digitSelect, i_reset=>i_reset);

    DisplayDriver : entity work.T29_M3_DisplayDriver(Behavioral)
        port map(i_digitSelect=>i_digitSelect, o_segAnodes=>o_segAnodes, o_segCathodes=>o_segCathodes,
                i_sw9=>'1', i_sw8=>'0', i_sw7=>'1',
                i_DataMode=>i_dataMode, i_DataValue=>i_dataValue, i_Symbol=>i_Symbol,  
                i_qtx_b=>i_Qtx_B, i_itx_b=>i_Itx_B, i_qrx_b=>i_Qrx_B, i_irx_b=>i_Irx_B, i_datatx_b=>i_datatx_b, i_datarx_b=>i_datarx_b);
    
    -- Clock process 
    sysClock_process: process
    begin
        i_Clk <= '0';
        wait for Clk_period/2;
        i_Clk <= '1';
        wait for Clk_period/2;
    end process;    
end architecture;