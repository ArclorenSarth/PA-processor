library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Decoder is
   port (clk : in std_logic;
         InstID : in std_logic_vector(31 downto 0);
         PCplus4ID : in std_logic_vector(31 downto 0);
         
         --register write-back
         weWB : in std_logic;
         resultWB : in std_logic_vector(31 downto 0);
         writeRegWB : in std_logic_vector(4 downto 0);         
   
         --bypasses
         ALUoutEX : in std_logic_vector(31 downto 0);
         ALUoutM : in std_logic_vector(31 downto 0);
         ALUoutWB : in std_logic_vector(31 downto 0);
         writeRegEX : in std_logic_vector(4 downto 0);
         writeRegM : in std_logic_vector(4 downto 0);
         
         
         
         ctrlRegWriteEX : out std_logic;
         ctrlMemtoRegEX : out std_logic;
         ctrlMemWriteEX : out std_logic;
         ctrlALUopEX : out std_logic_vector(6 downto 0);
         ctrlALUsrcEX : out std_logic;
         ctrlRegDestEX : out std_logic;
         ctrlByteEX : out std_logic;
         srcAEX : out std_logic_vector(31 downto 0);
         srcBEX : out std_logic_vector(31 downto 0);
         rtEX : out std_logic_vector(4 downto 0);
         rdEX : out std_logic_vector(4 downto 0);
         signImmEX : out std_logic_vector(31 downto 0);
         jumpImmEX : out std_logic_vector(31 downto 0);
         PClocationEX : out std_logic_vector(31 downto 0));

end Decoder;



architecture structure of Decoder is

   component RegFile is 
	   port (clk : in std_logic; 
			   wrd : in std_logic; 
			   d : in std_logic_vector(31 downto 0); 
			   addr_a : in std_logic_vector(4 downto 0); 
			   addr_b : in std_logic_vector(4 downto 0); 
			   addr_d : in std_logic_vector(4 downto 0); 
			   a : out std_logic_vector(31 downto 0); 
			   b : out std_logic_vector(31 downto 0)); 
   end component;

   signal ctrlRegWriteID : std_logic;
   signal ctrlMemtoRegID : std_logic;
   signal ctrlMemWriteID : std_logic;
   signal ctrlALUopID : std_logic_vector(6 downto 0);
   signal ctrlALUsrcID : std_logic;
   signal ctrlRegDestID : std_logic;
   signal ctrlByteID : std_logic;
   signal srcAID : std_logic_vector(31 downto 0);
   signal srcBID : std_logic_vector(31 downto 0);
   signal rtID : std_logic_vector(4 downto 0);
   signal rdID : std_logic_vector(4 downto 0);
   signal signImmID : std_logic_vector(31 downto 0);
   signal jumpImmID : std_logic_vector(31 downto 0);
   signal PClocationID : std_logic_vector(31 downto 0));

   signal addrA : std_logic_vector(4 downto 0); 
   signal addrB : std_logic_vector(4 downto 0);
   signal regA : std_logic_vector(31 downto 0);
   signal regB : std_logic_vector(31 downto 0);
   signal signExt : std_logic_vector(31 downto 0);




begin

   RegFile0 : RegFile 
   port map(clk => clk, 
			   wrd => weWB, 
			   d => resultWB, 
			   addr_a => addrA, 
			   addr_b => addrB, 
			   addr_d => writeRegWB, 
			   a => regA, 
			   b => regB);

   

   --ALU Operations Encoding: 
   --000 0000   ADD 
   --000 0001   SUB  
   --000 0010   MUL
      
	--001 0000   LDB 
   --001 0001   LDW
   --001 0010   STB 
   --001 0011   STW
   --001 0100   MOV
        
	--011 0000   BEQ
   --011 0001   JUMP
   --011 0010   TLBWRITE
   --011 0011   IRET
       




   --control unit signals









   --end control unit

   
   --bypasses
   
   --end bypasses


   addrA <= InstID(24 downto 20);
   addrB <= InstID(19 downto 15);
   srcAID <= regA; --TODO: or Bypasses comp with rtID/rdID
   srcBID <= regB; --TODO: or Bypasses comp with rtID/rdID

   signExt(14 downto 0) <= InstID(14 downto 0);
   signExt(31 downto 15) <= (others = InstID(14));
   jumpImm <= std_logic_vector(shift_left(signed(signExt),2);
   PClocationID <= std_logic_vector(signed(jumpImm) + signed(PCplus4ID));

   rtID <= InstID(24 downto 20);
   rdID <= InstID(19 downto 15);


   --Final signals forwarding
   srcAEX <= srcAID;
   srcBEX <= srcBID;
   rtEX <= rtID;
   rdEX <= rdID;
   signImmEX <= signExt; 











end structure;
