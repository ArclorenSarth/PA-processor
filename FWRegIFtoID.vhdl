library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;


entity FWRegIFtoID is
   port (clk : in std_logic;
         we : in std_logic;
         reset : in std_logic;
         
         instIF : in std_logic_vector(31 downto 0);
         PCplus4IF : in std_logic_vector(31 downto 0);
         instID : out std_logic_vector(31 downto 0);
         PCplus4ID : out std_logic_vector(31 downto 0));
end FWRegIFtoID;


architecture structure of FWRegIFtoID is
   
   component FWReg is
      Generic(W : integer);
      Port (d : in std_logic_vector(W-1 downto 0);
            clk : in std_logic;
            we : in std_logic;
            reset : in std_logic; 
            q : out std_logic_vector(W-1 downto 0));
   end component;

   component FWReg1 is
      Port (d : in std_logic;
            clk : in std_logic;
            we : in std_logic;
            reset : in std_logic; 
            q : out std_logic);
   end component;

begin

   finst : FWReg Generic map(32) port map(instIF,clk,we,reset,instID);
   fPCplus4 : FWReg Generic map(32) port map(PCplus4IF,clk,we,reset,PCplus4ID);


end structure;

