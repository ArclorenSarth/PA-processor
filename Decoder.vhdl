library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Decoder is
   port (clk : in std_logic;
         InstID : in std_logic_vector(31 downto 0);
         PCplus4ID : in std_logic_vector(31 downto 0);
         
         ctrlRegWriteEX : out std_logic;
         ctrlMemtoRegEX : out std_logic;
         ctrlMemWriteEX : out std_logic;
         ctrlALUopEX : out std_logic_vector(6 downto 0);
         ctrlALUsrcEX : out std_logic;
         ctrlRegDestEX : out std_logic;
         ctrlJalEX : out std_logic;
         srcAEX : out std_logic_vector(31 downto 0);
         srcBEX : out std_logic_vector(31 downto 0);
         rtEX : out std_logic_vector(4 downto 0);
         rdEX : out std_logic_vector(4 downto 0);
         signImmEX : out std_logic_vector(31 downto 0);
         jumpImmEX : out std_logic_vector(31 downto 0);
         PCLocation : out std_logic_vector(31 downto 0));

end Decoder;



architecture structure of Decoder is





begin






end structure;
