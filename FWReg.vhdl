library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
USE ieee.std_logic_unsigned.all;
use std.textio.all;


--Generic FWRegister, with WE & reset added

entity FWReg is
   Generic(W : integer);
   Port (d : in std_logic_vector(W-1 downto 0);
         clk : in std_logic;
         we : in std_logic;
         reset : in std_logic; 
         q : out std_logic_vector(W-1 downto 0));
end FWReg;

Architecture structure of FWReg is

begin
   reg_wr : process(clk)
   begin
      if rising_edge(clk) then
         if reset = '1' then
            q <= (others => '0');
         elsif we = '1' then
            q <= d;
         end if;
      end if;
   end process;

end structure;
