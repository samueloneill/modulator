----------------------------------------------------------------------------------
-- Company: UoP
-- Engineer: Dwight Morrison
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;
use IEEE.std_logic_signed.all;

entity T29_M3_ChannelA is
  port (
        i_sw11, i_sw10, i_reset:                  in  std_logic := '0';
        i_clk, i_CE16Hz:                          in  std_logic := '0';
        o_Atxvalue_I, o_Atxvalue_Q:               in  std_logic_vector(63 downto 0);
        o_Arxvalue_I, o_Arxvalue_Q:               out std_logic_vector(63 downto 0);
  );

end T29_M3_ChannelA; 

architecture behavioral of T29_M3_ChannelA is
    signal errorSel: std_logic_vector(1 downto 0) := "00";
    signal rand:     std_logic_vector(0 to 7) := "10000000";
    signal marker:   std_logic := '0';
begin
    -- 8bit linear LFSR 
    prng: process (i_clk)
    begin 
        if(rising_edge(i_clk)) then
            if(i_reset = '0') then
                rand <= (( (rand (5) xor rand (7)) xor rand (4)) xor rand (3));
            else
                rand <= "10000000";
            end if;
        end if;
    end process;

    -- switch vector
    switches: process(i_sw11, i_sw10)
    begin
        or <= (1=>i_sw11, 0=>i_sw10);
    end process;



    -- Process for checking error mode and dividing output as necessary
    output: process(i_CE16Hz, or, marker)
    begin
   
        
    if(falling_edge(i_CE16Hz)) then
        case(r_errorSel) is 
            when "00" =>
                -- +/- 0
                o_Arxvalue_Q <= o_Atxvalue_I;
                o_Arxvalue_I <= o_Atxvalue_Q;

            when "01" =>
                -- +/- 16
                o_Arxvalue_I(7 downto 0)   <= std_logic_vector(signed(o_Atxvalue_I(7 downto 0))   + signed(rand)/8);
                o_Arxvalue_I(15 downto 8)  <= std_logic_vector(signed(o_Atxvalue_I(15 downto 8))  + signed(rand)/8);
                o_Arxvalue_I(23 downto 16) <= std_logic_vector(signed(o_Atxvalue_I(23 downto 16)) + signed(rand)/8);
                o_Arxvalue_I(31 downto 24) <= std_logic_vector(signed(o_Atxvalue_I(31 downto 24)) + signed(rand)/8);
                o_Arxvalue_I(39 downto 32) <= std_logic_vector(signed(o_Atxvalue_I(39 downto 32)) + signed(rand)/8);
                o_Arxvalue_I(47 downto 40) <= std_logic_vector(signed(o_Atxvalue_I(47 downto 40)) + signed(rand)/8);
                o_Arxvalue_I(55 downto 48) <= std_logic_vector(signed(o_Atxvalue_I(55 downto 48)) + signed(rand)/8);
                o_Arxvalue_I(63 downto 56) <= std_logic_vector(signed(o_Atxvalue_I(63 downto 56)) + signed(rand)/8);
                
                o_Arxvalue_Q(7 downto 0)   <= std_logic_vector(signed(o_Atxvalue_Q(7 downto 0))   + signed(rand)/8);
                o_Arxvalue_Q(15 downto 8)  <= std_logic_vector(signed(o_Atxvalue_Q(15 downto 8))  + signed(rand)/8);
                o_Arxvalue_Q(23 downto 16) <= std_logic_vector(signed(o_Atxvalue_Q(23 downto 16)) + signed(rand)/8);
                o_Arxvalue_Q(31 downto 24) <= std_logic_vector(signed(o_Atxvalue_Q(31 downto 24)) + signed(rand)/8);
                o_Arxvalue_Q(39 downto 32) <= std_logic_vector(signed(o_Atxvalue_Q(39 downto 32)) + signed(rand)/8);
                o_Arxvalue_Q(47 downto 40) <= std_logic_vector(signed(o_Atxvalue_Q(47 downto 40)) + signed(rand)/8);
                o_Arxvalue_Q(55 downto 48) <= std_logic_vector(signed(o_Atxvalue_Q(55 downto 48)) + signed(rand)/8);
                o_Arxvalue_Q(63 downto 56) <= std_logic_vector(signed(o_Atxvalue_Q(63 downto 56)) + signed(rand)/8);

            when "10" => 
                -- +/- 32
                o_Arxvalue_I(7 downto 0)   <= std_logic_vector(signed(o_Atxvalue_I(7 downto 0))   + signed(rand)/4);
                o_Arxvalue_I(15 downto 8)  <= std_logic_vector(signed(o_Atxvalue_I(15 downto 8))  + signed(rand)/4);
                o_Arxvalue_I(23 downto 16) <= std_logic_vector(signed(o_Atxvalue_I(23 downto 16)) + signed(rand)/4);
                o_Arxvalue_I(31 downto 24) <= std_logic_vector(signed(o_Atxvalue_I(31 downto 24)) + signed(rand)/4);
                o_Arxvalue_I(39 downto 32) <= std_logic_vector(signed(o_Atxvalue_I(39 downto 32)) + signed(rand)/4);
                o_Arxvalue_I(47 downto 40) <= std_logic_vector(signed(o_Atxvalue_I(47 downto 40)) + signed(rand)/4);
                o_Arxvalue_I(55 downto 48) <= std_logic_vector(signed(o_Atxvalue_I(55 downto 48)) + signed(rand)/4);
                o_Arxvalue_I(63 downto 56) <= std_logic_vector(signed(o_Atxvalue_I(63 downto 56)) + signed(rand)/4);
                
                o_Arxvalue_Q(7 downto 0)   <= std_logic_vector(signed(o_Atxvalue_Q(7 downto 0))   + signed(rand)/4);
                o_Arxvalue_Q(15 downto 8)  <= std_logic_vector(signed(o_Atxvalue_Q(15 downto 8))  + signed(rand)/4);
                o_Arxvalue_Q(23 downto 16) <= std_logic_vector(signed(o_Atxvalue_Q(23 downto 16)) + signed(rand)/4);
                o_Arxvalue_Q(31 downto 24) <= std_logic_vector(signed(o_Atxvalue_Q(31 downto 24)) + signed(rand)/4);
                o_Arxvalue_Q(39 downto 32) <= std_logic_vector(signed(o_Atxvalue_Q(39 downto 32)) + signed(rand)/4);
                o_Arxvalue_Q(47 downto 40) <= std_logic_vector(signed(o_Atxvalue_Q(47 downto 40)) + signed(rand)/4);
                o_Arxvalue_Q(55 downto 48) <= std_logic_vector(signed(o_Atxvalue_Q(55 downto 48)) + signed(rand)/4);
                o_Arxvalue_Q(63 downto 56) <= std_logic_vector(signed(o_Atxvalue_Q(63 downto 56)) + signed(rand)/4);

            when "11" => 
                -- +/- 64
                o_Arxvalue_I(7 downto 0)   <= std_logic_vector(signed(o_Atxvalue_I(7 downto 0))   + signed(rand)/2);
                o_Arxvalue_I(15 downto 8)  <= std_logic_vector(signed(o_Atxvalue_I(15 downto 8))  + signed(rand)/2);
                o_Arxvalue_I(23 downto 16) <= std_logic_vector(signed(o_Atxvalue_I(23 downto 16)) + signed(rand)/2);
                o_Arxvalue_I(31 downto 24) <= std_logic_vector(signed(o_Atxvalue_I(31 downto 24)) + signed(rand)/2);
                o_Arxvalue_I(39 downto 32) <= std_logic_vector(signed(o_Atxvalue_I(39 downto 32)) + signed(rand)/2);
                o_Arxvalue_I(47 downto 40) <= std_logic_vector(signed(o_Atxvalue_I(47 downto 40)) + signed(rand)/2);
                o_Arxvalue_I(55 downto 48) <= std_logic_vector(signed(o_Atxvalue_I(55 downto 48)) + signed(rand)/2);
                o_Arxvalue_I(63 downto 56) <= std_logic_vector(signed(o_Atxvalue_I(63 downto 56)) + signed(rand)/2);
                
                o_Arxvalue_Q(7 downto 0)   <= std_logic_vector(signed(o_Atxvalue_Q(7 downto 0))   + signed(rand)/2);
                o_Arxvalue_Q(15 downto 8)  <= std_logic_vector(signed(o_Atxvalue_Q(15 downto 8))  + signed(rand)/2);
                o_Arxvalue_Q(23 downto 16) <= std_logic_vector(signed(o_Atxvalue_Q(23 downto 16)) + signed(rand)/2);
                o_Arxvalue_Q(31 downto 24) <= std_logic_vector(signed(o_Atxvalue_Q(31 downto 24)) + signed(rand)/2);
                o_Arxvalue_Q(39 downto 32) <= std_logic_vector(signed(o_Atxvalue_Q(39 downto 32)) + signed(rand)/2);
                o_Arxvalue_Q(47 downto 40) <= std_logic_vector(signed(o_Atxvalue_Q(47 downto 40)) + signed(rand)/2);
                o_Arxvalue_Q(55 downto 48) <= std_logic_vector(signed(o_Atxvalue_Q(55 downto 48)) + signed(rand)/2);
                o_Arxvalue_Q(63 downto 56) <= std_logic_vector(signed(o_Atxvalue_Q(63 downto 56)) + signed(rand)/2);
            when others => report "unreachable" severity failure;
        end case;
    end if;
  end process;
end architecture;