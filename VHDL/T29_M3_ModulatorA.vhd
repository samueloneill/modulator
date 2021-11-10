----------------------------------------------------------------------------------
-- Company: UoP
-- Team: Team 29 - Sam O 879282 - Dwight M 879243
-- Engineer: Dwight Morrison
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std;

entity T29_M2_modulator is
    port (
        i_CE2Hz, i_CE16Hz,  i_clk:   in std_logic;
        i_Symboltx:                  in std_logic_vector(1 downto 0);
        o_Atxvalue_I:                out std_logic_vector(63 downto 0);
        o_Atxvalue_Q:                out std_logic_vector(63 downto 0);
        AIbit_stream64_0 :           inout std_logic_vector(63 downto 0);
        AIbit_stream64_1 :           inout std_logic_vector(63 downto 0);
        AQbit_stream64_0 :           inout std_logic_vector(63 downto 0);
        AQbit_stream64_1 :           inout std_logic_vector(63 downto 0);
        );
end T29_M2_modulator; 

architecture behavioral of T29_M2_modulator is

    --I

    signal I_datapoint_low0: std_logic_vector(7 downto 0) := "10000000";
    signal I_datapoint_low1: std_logic_vector(7 downto 0) := "10100000";
    signal I_datapoint_low2: std_logic_vector(7 downto 0) := "11000000";
    signal I_datapoint_low3: std_logic_vector(7 downto 0) := "10100000";
    signal I_datapoint_low4: std_logic_vector(7 downto 0) := "10000000";
    signal I_datapoint_low5: std_logic_vector(7 downto 0) := "01100000";
    signal I_datapoint_low6: std_logic_vector(7 downto 0) := "01000000";
    signal I_datapoint_low7: std_logic_vector(7 downto 0) := "01100000";
    
    
    AIbit_stream64_0(7 downto 0)   <= I_datapoint_low0;
    AIbit_stream64_0(15 downto 8)  <= I_datapoint_low1;
    AIbit_stream64_0(23 downto 16) <= I_datapoint_low2;
    AIbit_stream64_0(31 downto 24) <= I_datapoint_low3;
    AIbit_stream64_0(39 downto 32) <= I_datapoint_low4;
    AIbit_stream64_0(47 downto 40) <= I_datapoint_low5;
    AIbit_stream64_0(55 downto 48) <= I_datapoint_low6;
    AIbit_stream64_0(63 downto 56) <= I_datapoint_low7;

    signal I_datapoint_high0: std_logic_vector(7 downto 0) := "10000000";
    signal I_datapoint_high1: std_logic_vector(7 downto 0) := "01100000";
    signal I_datapoint_high2: std_logic_vector(7 downto 0) := "01000000";
    signal I_datapoint_high3: std_logic_vector(7 downto 0) := "01100000";
    signal I_datapoint_high4: std_logic_vector(7 downto 0) := "10000000";
    signal I_datapoint_high5: std_logic_vector(7 downto 0) := "10100000";
    signal I_datapoint_high6: std_logic_vector(7 downto 0) := "11000000";
    signal I_datapoint_high7: std_logic_vector(7 downto 0) := "10100000";
    
    
    AIbit_stream64_1(7 downto 0)   <= I_datapoint_high0;
    AIbit_stream64_1(15 downto 8)  <= I_datapoint_high1;
    AIbit_stream64_1(23 downto 16) <= I_datapoint_high2;
    AIbit_stream64_1(31 downto 24) <= I_datapoint_high3;
    AIbit_stream64_1(39 downto 32) <= I_datapoint_high4;
    AIbit_stream64_1(47 downto 40) <= I_datapoint_high5;
    AIbit_stream64_1(55 downto 48) <= I_datapoint_high6;
    AIbit_stream64_1(63 downto 56) <= I_datapoint_high7;

    --Q

    signal Q_datapoint_low0: std_logic_vector(7 downto 0) := "10000000";
    signal Q_datapoint_low1: std_logic_vector(7 downto 0) := "10100000";
    signal Q_datapoint_low2: std_logic_vector(7 downto 0) := "11000000";
    signal Q_datapoint_low3: std_logic_vector(7 downto 0) := "10100000";
    signal Q_datapoint_low4: std_logic_vector(7 downto 0) := "10000000";
    signal Q_datapoint_low5: std_logic_vector(7 downto 0) := "01100000";
    signal Q_datapoint_low6: std_logic_vector(7 downto 0) := "01000000";
    signal Q_datapoint_low7: std_logic_vector(7 downto 0) := "01100000";
    
    
    AQbit_stream64_0(7 downto 0)   <= Q_datapoint_low0;
    AQbit_stream64_0(15 downto 8)  <= Q_datapoint_low1;
    AQbit_stream64_0(23 downto 16) <= Q_datapoint_low2;
    AQbit_stream64_0(31 downto 24) <= Q_datapoint_low3;
    AQbit_stream64_0(39 downto 32) <= Q_datapoint_low4;
    AQbit_stream64_0(47 downto 40) <= Q_datapoint_low5;
    AQbit_stream64_0(55 downto 48) <= Q_datapoint_low6;
    AQbit_stream64_0(63 downto 56) <= Q_datapoint_low7;

    signal Q_datapoint_high0: std_logic_vector(7 downto 0) := "10000000"; --high
    signal Q_datapoint_high1: std_logic_vector(7 downto 0) := "01100000"; --low
    signal Q_datapoint_high2: std_logic_vector(7 downto 0) := "01000000"; --low
    signal Q_datapoint_high3: std_logic_vector(7 downto 0) := "01100000"; --low
    signal Q_datapoint_high4: std_logic_vector(7 downto 0) := "10000000"; --high
    signal Q_datapoint_high5: std_logic_vector(7 downto 0) := "10100000"; --high
    signal Q_datapoint_high6: std_logic_vector(7 downto 0) := "11000000"; --high
    signal Q_datapoint_high7: std_logic_vector(7 downto 0) := "10100000"; --high
   

    
    AQbit_stream64_1(7 downto 0)   <= Q_datapoint_high0;
    AQbit_stream64_1(15 downto 8)  <= Q_datapoint_high1;
    AQbit_stream64_1(23 downto 16) <= Q_datapoint_high2;
    AQbit_stream64_1(31 downto 24) <= Q_datapoint_high3;
    AQbit_stream64_1(39 downto 32) <= Q_datapoint_high4;
    AQbit_stream64_1(47 downto 40) <= Q_datapoint_high5;
    AQbit_stream64_1(55 downto 48) <= Q_datapoint_high6;
    AQbit_stream64_1(63 downto 56) <= Q_datapoint_high7;

    


begin
    modulator : process (i_clk, i_CE16Hz)
    begin
        case( i_Symboltx ) is
            when "00" =>
            o_Atxvalue_I <= AIbit_stream64_0;
            o_Atxvalue_Q <= AQbit_stream64_0;
            when "01" =>
            o_Atxvalue_I <= AIbit_stream64_0;
            o_Atxvalue_Q <= AQbit_stream64_1;
            when "10" =>
            o_Atxvalue_I <= AIbit_stream64_1;
            o_Atxvalue_Q <= AQbit_stream64_0;
            when "11" =>
            o_Atxvalue_I <= AIbit_stream64_1;
            o_Atxvalue_Q <= AQbit_stream64_1;
        end case ;

    end process ;

end architecture;