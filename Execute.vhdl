library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Execute is
   port (clk : in std_logic;
         ctrlRegWriteEX : in std_logic;
         ctrlMemtoRegEX : in std_logic;
         ctrlMemWriteEX : in std_logic;
         ctrlALUopEX : in std_logic_vector(6 downto 0);
         ctrlALUsrcEX : in std_logic;
         ctrlRegDestEX : in std_logic;
         ctrlByteEX : in std_logic;
         
         srcAEX : in std_logic_vector(31 downto 0);
         srcBEX : in std_logic_vector(31 downto 0);
         rtEX : in std_logic_vector(4 downto 0);
         rdEX : in std_logic_vector(4 downto 0);
         signImmEX : in std_logic_vector(31 downto 0);
         --jumpImmEX : in std_logic_vector(31 downto 0);
         
         ctrlRegWriteM : out std_logic;
         ctrlMemtoRegM : out std_logic;
         ctrlMemWriteM  : out std_logic;
         ctrlByteM : out std_logic;

         ALUoutM : out std_logic_vector(31 downto 0);
         writeDataM : out std_logic_vector(31 downto 0);
         writeRegM : out std_logic_vector(4 downto 0));

end Execute;



architecture structure of Execute is

   component alu is 
      PORT (x : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            y : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
            op : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
            w : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));
   end component;
   
   signal prvSrcBEX : std_logic_vector(31 downto 0);
   signal prvALUoutEX : std_logic_vector(31 downto 0);
   

begin

   alu0 : alu
   Port Map(x => srcAEX,
            y => prvSrcBEX,
            op => ctrlALUopEX,
            w =>  prvALUoutEX);


   prvSrcBEX(31 downto 0) <= srcBEX(31 downto 0) when ctrlALUsrcEX = '0' else
                             signImmEX(31 downto 0);

   writeRegM(4 downto 0) <= rtEX(4 downto 0) when ctrlRegDestEX = '0' else
                            rdEX(4 downto 0);
    
   writeDataM(31 downto 0) <= srcBEX(31 downto 0);

   ALUoutM(31 downto 0) <= prvALUoutEX(31 downto 0);


   
   ctrlRegWriteM <= ctrlRegWriteEX;
   ctrlMemtoRegM <= ctrlMemtoRegEX;
   ctrlMemWriteM <= ctrlMemWriteEX;
   ctrlByteM <= ctrlByteEX;




end structure;
         
