library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TB_Demodulator is
end TB_Demodulator; 

architecture behavioral of TB_Demodulator is
    signal i_CE16, i_ce2, i_ce1, i_clk, i_reset: std_logic := '0';
    signal i_IData, i_QData: std_logic_vector(7 downto 0);
    signal i_ErrSel: std_logic_vector (1 downto 0) := "00";
    signal o_Symbol: std_logic_vector (1 downto 0);
    signal o_dataRX: std_logic_vector (3 downto 0);
    signal r_count: integer;
begin
  demodulator : entity work.T29_M3_DemodulatorB(Behavioral)
    port map(i_clk=>i_clk, i_reset=>i_reset, i_CE=>i_Ce16, i_ce2=>i_ce2, i_ce3=>i_ce1, i_IRX=>i_IData, i_QRX=>i_QData,
            i_ErrorSelect=>i_ErrSel, o_symbol=>o_symbol, o_dataRx=>o_dataRx, i_count=>r_count);

  ce16: entity work.T29_M3_ClockEnable(CEArc)
  generic map(g_maxCount=>10E7, g_increment=>16)
  port map(i_clk=>i_clk, o_CE=>i_CE16);
  
  ce2: entity work.T29_M3_ClockEnable(CEArc)
  generic map(g_maxCount=>10E7, g_increment=>2)
  port map(i_clk=>i_clk, o_CE=>i_CE2);
  
  ce1: entity work.T29_M3_ClockEnable(CEArc)
  generic map(g_maxCount=>10E7, g_increment=>1)
  port map(i_clk=>i_clk, o_CE=>i_CE1);

  process(i_clk)
    begin
        i_Clk <= not i_Clk after 5 ns;
    end process;  
    
  Count : process (i_clk, i_ce16, i_reset)
  begin
     if i_reset = '1' then 
        r_count <= 0;
    elsif rising_edge (i_clk) then 
       if i_ce16 = '1' then 
          if (r_count >= 7) then 
             r_count <= 0;
        else
             r_count <= r_count + 1;
         end if;  
       end if;
    end if;   
  end process Count;
end architecture;

           
