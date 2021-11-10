----------------------------------------------------------------------------------
-- Company: UoP
-- Team: Team 29 - Sam O 879282 - Dwight M 879243
-- Engineer: Dwight and sam
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.std_logic_signed.all;

entity T29_M3_DemodulatorA is
    port (
    i_clk, i_CE16Hz:                          in  std_logic:= '0';
    o_Arxvalue_I, o_Arxvalue_Q:               in  std_logic_vector(63 downto 0);
    ref_wave_0:                               in  std_logic_vector(63 downto 0);
    ref_wave_1:                               in  std_logic_vector(63 downto 0);
    erorr_datarx:                             out std_logic_vector(0 downto 5);
    o_dataSrx:                                out std_logic_vector(0 downto 1);
    );
end T29_M3_DemodulatorA; 


architecture behavioral of T29_M3_DemodulatorA is
    
    signal ref_wave_0:     std_logic_vector(63 downto 0);
    signal ref_wave_1:     std_logic_vector(63 downto 0);
    signal latch_I:        std_logic:= '0';
    signal latch_Q:        std_logic:= '0';

begin
    De-modulator : process (i_clk, i_CE16Hz)
    begin
        if (o_Arxvalue_I(7) AND ref_wave_0(7)) = "1"
        then 

        case (o_Arxvalue_I(7,15,23)
            when "110"
            erorr_datarx <= "100000"; --+16
            latch_I <= "1";
            o_dataSrx <= "00"
            when "101"
            erorr_datarx <= "010000"; --+32
            latch_I <= "1";
            o_dataSrx <= "00"
            when "100"
            erorr_datarx <= "001000"; --+64
            latch_I <= "1";
            o_dataSrx <= "00"
            when "110"
            erorr_datarx <= "000100"; ---16
            latch_I <= "0";
            when "101"
            erorr_datarx <= "000010"; ---32
            latch_I <= "0";
            o_dataSrx <= "00"
            when "100"
            erorr_datarx <= "000001"; ---64
            latch_I <= "0";
            o_dataSrx <= "00"
            when others =>
            
        end case ;    

        if (o_Arxvalue_Q(7) AND ref_wave_0(7)) = "1"
        then 

        case (o_Arxvalue_Q(7,15,23)
            when "110"
            erorr_datarx <= "100000"; --+16
            latch_Q <= "1";
            o_dataSrx <= "00"
            when "101"
            erorr_datarx <= "010000"; --+32
            latch_Q <= "1";
            o_dataSrx <= "00"
            when "100"
            erorr_datarx <= "001000"; --+64
            latch_Q <= "1";
            o_dataSrx <= "00"
            when "110"
            erorr_datarx <= "000100"; ---16
            latch_Q <= "0";
            o_dataSrx <= "00"
            when "101"
            erorr_datarx <= "000010"; ---32
            latch_Q <= "0";
            o_dataSrx <= "00"
            when "100"
            erorr_datarx <= "000001"; ---64
            latch_Q <= "0";   
            o_dataSrx <= "00"
            when others =>
            
        end case ;    
    end process ;
end architecture;