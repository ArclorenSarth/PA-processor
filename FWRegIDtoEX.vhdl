library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;


entity FWRegIDtoEX is

   port (clk : in std_logic;
         we : in std_logic;
         reset : in std_logic;
         
         ctrlRegWriteID : in std_logic;
         ctrlMemtoRegID : in std_logic;
         ctrlMemWriteID : in std_logic;
         ctrlALUopID : in std_logic_vector(6 downto 0);
         ctrlALUsrcID : in std_logic;
         ctrlRegDestID : in std_logic;
         ctrlJalID : in std_logic;

         srcAID : in std_logic_vector(31 downto 0);
         srcBID : in std_logic_vector(31 downto 0);
         rtID : in std_logic_vector(4 downto 0);
         rdID : in std_logic_vector(4 downto 0);
         signImmID : in std_logic_vector(31 downto 0);
         jumpImmID : in std_logic_vector(31 downto 0);

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
         jumpImmEX : out std_logic_vector(31 downto 0));

end FWRegIDtoEX;


architecture structure of FWRegIDtoEX is
   
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

   fCtrlRegWrite : FWReg1 port map(ctrlRegWriteID,clk,we,reset,ctrlRegWriteEX);
   fCtrlMemtoReg : FWReg1 port map(ctrlMemtoRegID,clk,we,reset,ctrlMemtoRegEX);
   fCtrlMemWrite : FWReg1 port map(ctrlMemWriteID,clk,we,reset,ctrlMemWriteEX);
   fCtrlALUop : FWReg Generic map(7) port map(ctrlALUopID,clk,we,reset,ctrlALUopEX);
   fCtrlALUsrc : FWReg1 port map(ctrlALUsrcID,clk,we,reset,ctrlALUsrcEX);
   fCtrlRegDest : FWReg1 port map(ctrlRegDestID,clk,we,reset,ctrlRegDestEX);
   fCtrlJal : FWReg1 port map(ctrlJalID,clk,we,reset,ctrlJalEX);

   fSrcA : FWReg Generic map(32) port map(srcAID,clk,we,reset,srcAEX);
   fSrcB : FWReg Generic map(32) port map(srcBID,clk,we,reset,srcBEX);
   fRt : FWReg Generic map(5) port map(rtID,clk,we,reset,rtEX);
   fRd : FWReg Generic map(5) port map(rdID,clk,we,reset,rdEX);
   fSignImm : FWReg Generic map(32) port map(signImmID,clk,we,reset,signImmEX);
   fJumpImm : FWReg Generic map(32) port map(jumpImmID,clk,we,reset,jumpImmEX);




end structure;

