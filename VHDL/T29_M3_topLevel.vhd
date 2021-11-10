----------------------------------------------------------------------------------
-- Company: UoP
-- Team: Team 29 - Sam O 879282 - Dwight M 879243
-- Engineer: Sam O'Neill
-- 
-- Create Date: 07.01.2021 12:25:24 
-- Module Name: T29_M3_topLevel - Behavioral
-- Project Name: Digital Modulator/Demodulator
-- Target Devices: Basys 3
-- Description: Top-level entity instantiating all others
--
-- Revision:
-- Revision 1.0 - File Created
-- Revision 1.1 - Added debounce for start/stop button
-- Revision 1.2 - Added demodulator B and modulator A entities
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity T29_M3_topLevel is
    port (i_C100MHz, i_reset: in std_logic;
        i_SW15, i_SW14, i_SW13, i_SW12, i_SW11, i_SW10, i_SW9, i_SW8, i_SW7: in std_logic := '0';
        i_StartStop: in std_logic := '0';
        o_segCathodes: out std_logic_vector(6 downto 0);
        o_segAnodes: out std_logic_vector(3 downto 0));
end T29_M3_topLevel;

architecture Behavioral of T29_M3_topLevel is
    component clk_wiz_0 is
        port(clk_out1, locked: out std_logic;
             clk_in1, reset: in std_logic);
    end component;

    -- Internal signal declarations
    signal i_clk, d_BTND, w_CE1Hz, w_CE2Hz, w_CE16Hz, w_CE250Hz: std_logic;
    signal r_c3Value, r_Symbol, r_errorSelect: std_logic_vector(1 downto 0);
    signal r_datamode: std_logic_vector (3 downto 0);
    signal r_QtxB, r_ItxB, r_QrxB, r_IrxB: std_logic_vector(7 downto 0);
    signal r_DtxB, r_DrxB: std_logic_vector(3 downto 0);
begin
    -- Instantiate DCM block
    C100MHz: clk_wiz_0
    port map (clk_out1=>i_clk, reset=>i_reset, clk_in1=>i_C100MHz);

    -- Debounce start/stop button
    StartStop: entity work.T29_M3_Debounce(logic)
        generic map(counter_size => 20)
        port map(i_clk=>i_clk, i_switch=>i_StartStop, o_Debounced=>d_BTND);

    -- Instantiate clock enables
    CE1Hz: entity work.T29_M3_ClockEnable(CEArc)
        generic map (g_maxCount => 10E7, g_increment => 1)
        port map (i_Clk => i_Clk, o_CE => w_CE1Hz);
    CE2Hz: entity work.T29_M3_ClockEnable(CEArc)
        generic map (g_maxCount => 10E7, g_increment => 2)
        port map (i_Clk => i_Clk, o_CE => w_CE2Hz);
    CE16Hz: entity work.T29_M3_ClockEnable(CEArc)
        generic map (g_maxCount => 10E7, g_increment => 16)
        port map (i_Clk => i_Clk, o_CE => w_CE16Hz);
    CE250Hz: entity work.T29_M3_ClockEnable(CEArc)
        generic map (g_maxCount => 10E7, g_increment => 250)
        port map (i_Clk => i_Clk, o_CE => w_CE250Hz);

    DataGenerator: entity work.T29_M3_DataGenerator(Behavioral)
        port map(i_Sw15=>i_Sw15, i_Sw14=>i_Sw14, i_Sw13=>i_Sw13, i_Sw12=>i_Sw12,
                i_StartStop=>d_BTND, i_clk=>i_clk, i_CE1Hz=>w_CE1Hz, i_reset=>i_reset,
                i_Data_Select_bin=>r_dataMode, o_DataValues=>r_DtxB);
    
    SymbolConverter: entity work.T29_M3_SymbolConv(Behavioral)
        port map(i_clk=>i_clk, i_CE2Hz=>w_CE2Hz, i_data=>r_DtxB, o_Symbol=>r_Symbol);

    ModulatorB : entity work.T29_M3_ModulatorB(Behavioral)
        port map (i_clk=>i_clk, i_CE16Hz=>w_CE16Hz, i_CE2Hz=>w_CE2Hz, i_Symbol=>r_Symbol,
                o_I_tx=>r_ItxB, o_Q_tx=>r_QtxB);

    Channel : entity work.T29_M3_ChannelB(Behavioral)
        port map (i_Itx=>r_ItxB, i_Qtx=>r_QtxB, i_CE16Hz=>w_CE16Hz, i_clk=>i_clk,
                  o_I_rx=>r_IrxB, o_Q_rx=>r_QrxB, i_sw11=>i_sw11, i_sw10=>i_sw10);
                  
    Demodulator: entity work.T29_M3_Demodulator(Behavioral)
        port map(i_clk=>i_clk, i_reset=>i_reset, i_CE16Hz=>w_CE16Hz, i_CE2Hz=>w_CE2Hz, i_IData=>r_IrxB, i_Qdata=>r_QrxB,
                 i_ErrSel=>r_errorSelect, o_symbol=>r_Symbol, o_DataRX=>r_DrxB);
    
    counter_0_to_3: entity work.T29_M3_counter3(Behavioral)
        generic map(g_width=>2)
        port map(i_clk=>i_clk, i_CE250Hz=>w_CE250Hz, o_counter3Out=>r_c3Value, i_reset=>i_reset);

    DisplayDriver : entity work.T29_M3_DisplayDriver(Behavioral)
        port map(i_digitSelect=>r_c3Value, o_segAnodes=>o_segAnodes, o_segCathodes=>o_segCathodes,
                i_sw9=>i_sw9, i_sw8=>i_sw8, i_sw7=>i_sw7,
                i_DataMode=>r_dataMode, i_DataValue=>r_DtxB, i_Symbol=>r_Symbol,  
                i_qtx_b=>r_QtxB, i_itx_b=>r_ItxB, i_qrx_b=>r_QrxB, i_irx_b=>r_IrxB, i_datatx_b=>r_DtxB, i_datarx_b=>r_DrxB);
end Behavioral;
