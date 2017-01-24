library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;



entity FWRegEXtoMEM is
   port (clk : in std_logic;
         we : in std_logic;
         reset : in std_logic;
         
         ctrlRegWriteEX : in std_logic;
         ctrlMemtoRegEX : in std_logic;
         ctrlMemWriteEX : in std_logic;
         ctrlALUopEX : in std_logic_vector(6 downto 0);
         ctrlByteEX : in std_logic;
         ALUoutEX : in std_logic_vector(31 downto 0);
         writeDataEX : in std_logic_vector(31 downto 0);
         writeRegEX : in std_logic_vector(4 downto 0);
         
         ctrlRegWriteM : out std_logic;
         ctrlMemtoRegM : out std_logic;
         ctrlMemWriteM : out std_logic;
         ctrlALUopM : out std_logic_vector(6 downto 0);
         ctrlByteM : out std_logic;
         ALUoutM : out std_logic_vector(31 downto 0);
         writeDataM : out std_logic_vector(31 downto 0);
         writeRegM : out std_logic_vector(4 downto 0));

end FWRegEXtoMEM;


architecture structure of FWRegEXtoMEM is
   
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

   
   fCtrlRegWrite : FWReg1 port map(ctrlRegWriteEX,clk,we,reset,ctrlRegWriteM);
   fCtrlMemtoReg : FWReg1 port map(ctrlMemtoRegEX,clk,we,reset,ctrlMemtoRegM);
   fCtrlMemWrite : FWReg1 port map(ctrlMemWriteEX,clk,we,reset,ctrlMemWriteM);
   fCtrlALUop: FWReg Generic map(7) port map(ctrlALUopEX,clk,we,reset,ctrlALUopM);
   fCtrlByte : FWReg1 port map(ctrlByteEX,clk,we,reset,ctrlByteM);
   fALUout : FWReg Generic map(32) port map(ALUoutEX,clk,we,reset,ALUoutM);
   fWriteData : FWReg Generic map(32) port map(writeDataEX,clk,we,reset,writeDataM);
   fWriteReg : FWReg Generic map(5) port map(writeRegEX,clk,we,reset,writeRegM);


end;   
