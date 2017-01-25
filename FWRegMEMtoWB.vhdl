library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;



entity FWRegMEMtoWB is
   port (clk : in std_logic;
         we : in std_logic;
         reset : in std_logic;
         
         ctrlRegWriteM : in std_logic;
         ctrlMemtoRegM : in std_logic;
         ctrlALUopM : in std_logic_vector(6 downto 0);
         ALUoutM : in std_logic_vector(31 downto 0);
         readDataM : in std_logic_vector(31 downto 0);
         writeRegM : in std_logic_vector(4 downto 0);
         
         ctrlRegWriteWB : out std_logic;
         ctrlMemtoRegWB : out std_logic;
         ctrlALUopWB : out std_logic_vector(6 downto 0);
         ALUoutWB : out std_logic_vector(31 downto 0);
         readDataWB : out std_logic_vector(31 downto 0);
         writeRegWB : out std_logic_vector(4 downto 0));

end FWRegMEMtoWB;


architecture structure of FWRegMEMtoWB is

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

   fCtrlRegWrite : FWReg1 port map(ctrlRegWriteM,clk,we,reset,ctrlRegWriteWB);
   fCtrlMemtoReg : FWReg1 port map(ctrlMemtoRegM,clk,we,reset,ctrlMemtoRegWB);
   fCtrlALUop: FWReg Generic map(7) port map(ctrlALUopM,clk,we,reset,ctrlALUopWB);
   fALUout : FWReg Generic map(32) port map(ALUoutM,clk,we,reset,ALUoutWB);
   fReadData : FWReg Generic map(32) port map(readDataM,clk,we,reset,readDataWB);
   fWriteReg : FWReg Generic map(5) port map(writeRegM,clk,we,reset,writeRegWB);



end;
