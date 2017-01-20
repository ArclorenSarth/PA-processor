library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;



entity FWRegEXtoMEM is
   port (clk : in std_logic;
         we : in std_logic;
         
         ctrlRegWriteEX : in std_logic;
         ctrlMemtoRegEX : in std_logic;
         ctrlMemWriteEX : in std_logic;
         ALUoutEX : in std_logic_vector(31 downto 0);
         writeDataEX : in std_logic_vector(31 downto 0);
         writeRegEX : in std_logic_vector(4 downto 0));
         
         ctrlRegWriteM : out std_logic;
         ctrlMemtoRegM : out std_logic;
         ctrlMemWriteM : out std_logic;
         ALUoutM : out std_logic_vector(31 downto 0);
         writeDataM : out std_logic_vector(31 downto 0);
         writeRegM : out std_logic_vector(4 downto 0));

end FWRegEXtoMEM;
