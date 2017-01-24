library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Decoder is
   port (clk : in std_logic;
         cacheIHitIF : in std_logic;
         cacheDHitM : in std_logic;
         InstID : in std_logic_vector(31 downto 0);
         PCplus4ID : in std_logic_vector(31 downto 0);
         
         --register write-back
         weWB : in std_logic;
         resultWB : in std_logic_vector(31 downto 0);
         writeRegWB : in std_logic_vector(4 downto 0);         
   
         --bypasses
         ALUoutEX : in std_logic_vector(31 downto 0);
         ALUoutM : in std_logic_vector(31 downto 0);
         --ALUoutWB : in std_logic_vector(31 downto 0);
         readDataM : in std_logic_vector(31 downto 0);
         writeRegEX : in std_logic_vector(4 downto 0);
         writeRegM : in std_logic_vector(4 downto 0);
         ALUopOldEX : in std_logic_vector(6 downto 0);
         ALUopOldM : in std_logic_vector(6 downto 0);
         ALUopOldWB : in std_logic_vector(6 downto 0);
         
                  
         
         ctrlRegWriteEX : out std_logic;
         ctrlMemtoRegEX : out std_logic;
         ctrlMemWriteEX : out std_logic;
         ctrlALUopEX : out std_logic_vector(6 downto 0);
         ctrlALUsrcEX : out std_logic;
         ctrlRegDestEX : out std_logic;
         ctrlByteEX : out std_logic;
         ctrlBypassAEX : out std_logic;
         ctrlBypassBEX : out std_logic;
         srcAEX : out std_logic_vector(31 downto 0);
         srcBEX : out std_logic_vector(31 downto 0);
         rtEX : out std_logic_vector(4 downto 0);
         rdEX : out std_logic_vector(4 downto 0);
         signImmEX : out std_logic_vector(31 downto 0);
         ctrlJumpIF : out std_logic
         PClocationIF : out std_logic_vector(31 downto 0);
         forwardingWE : out std_logic);
         

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


   signal ctrlBranchID : std_logic;
   signal ctrlBEQID : std_logic;
   
   signal srcAID : std_logic_vector(31 downto 0);
   signal srcBID : std_logic_vector(31 downto 0);
   signal rtID : std_logic_vector(4 downto 0);
   signal rdID : std_logic_vector(4 downto 0);
   signal signImmID : std_logic_vector(31 downto 0);
   signal branchImmID : std_logic_vector(31 downto 0);
   signal jumpImmID : std_logic_vector(31 downto 0);
   signal branchLocID : std_logic_vector(31 downto 0);
   signal jumpLocID : std_logic_vector(31 downto 0);
   signal PClocationID : std_logic_vector(31 downto 0));
    

   
   signal ALUopID : std_logic_vector (6 downto 0);
   signal addrA : std_logic_vector(4 downto 0); 
   signal addrB : std_logic_vector(4 downto 0);
   signal regA : std_logic_vector(31 downto 0);
   signal regB : std_logic_vector(31 downto 0);

   signal opValidEX : std_logic;
   signal opValidM : std_logic;
   signal opValidWB : std_logic;
   
   signal isLDEX : std_logic;
   signal isLDM : std_logic;
   signal isLDWB : std_logic;
   
   




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
   --001 0101   MOVI
        
	--011 0000   BEQ
   --011 0001   JUMP
   --011 0010   TLBWRITE  // Not supported as for now
   --011 0011   IRET      // Not supported as for now
       




   --------------------------------control unit signals--------------------------------------
   ctrlRegWriteEX <= '1' when ALUopID="0000000" or ALUopID="0000001" or ALUopID="0000010"  --ALU ops
                           or ALUopID="0010000" or ALUopID="0010001"                       --LDs
                           or ALUopID="0010100" or ALUopID="0010101" else                  --MOVs
                     '0';

   ctrlMemtoRegEX <= '1' when ALUopID="0010000" or ALUopID="0010001" else
                     '0';
   
   ctrlMemWriteEX <= '1' when ALUopID="0010010" or ALUopID="0010011" else
                     '0';

   ctrlBEQID <= '1' when (signed(srcAID) = signed(srcBEX)) else
                '0'; 
   ctrlBranchID <= '1' when ALUopID="0110000" and ctrlBEQID = '1' else
                   '0';

   ctrlJumpIF <= '1' when ALUopID="0110001" or ctrlBranchID = '1' else
                 '0';


   ctrlALUopEX <= ALUopID;

   ctrlALUsrcEX <= '1' when ALUopID >= "0010000" else
                   '0';

   ctrlRegDestEX <= '1' when ALUopID="0010000" or ALUopID="0010000" else
                    '0';

   ctrlByteEX <= '1' when ALUopID="0010000" or ALUopID="0010010" else
                 '0';

   ctrlBypassAEX <= '1' when isLDEX='1' and addrA=writeRegEX else
                    '0';
   ctrlBypassBEX <= '1' when isLDEX='1' and addrB=writeRegEX else
                    '0';

   forwardingWE <= '1' when cacheIhitIF = '1' and cacheDhitM='1' else
                   '0'; --CACHE MISS CONTROL AND THAT

   --TODO: PROCESS FOR MUL OPERATIONS AND THAT
   
   --------------------------end control unit-----------------------------------

   
   --------------------------   bypasses-------------------------------------
   isLDEX <= '1' when ALUopOldEX="0010000" or ALUopOldEX="0010001" else
             '0';
   isLDM  <= '1' when ALUopOldM="0010000" or ALUopOldM="0010001" else
             '0';
   isLDWB <= '1' when ALUopOldWB="0010000" or ALUopOldWB="0010001" else
             '0';


   opValidEX <= '1' when ALUopOldEX<"0010000"                              --ALUs
                    or ALUopOldEX="0010100" or ALUopOldEX="0010101" else   --MOVs
                '0';
   opValidM  <= '1' when ALUopOldM<"0010000"                                --ALUs
                    or ALUopOldM="0010100" or ALUopOldM="0010101"           --MOVs
                    or ALUopOldM="0010000" or ALUopOldM="0010001" else      --LDs
                '0';
   opValidWB <= '1' when ALUopOldWB<"0010000"                              --ALUs
                    or ALUopOldWB="0010100" or ALUopOldWB="0010101"        --MOVs
                    or ALUopOldWB="0010000" or ALUopOldWB="0010001" else   --LDs
                '0';         
                  
   srcAID <= ALUoutEX when opValidEX='1' and addrA=writeRegEX else
             ALUoutM when opValidM='1' and addrA=writeRegM and isLDM='0' else
             readDataM when opValidM='1' and addrA=writeRegM and isLDM='1' else
             resultWB when opValidWB='1' and addrA=writeRegWB else
             regA;
   
   srcBID <= ALUoutEX when opValidEX='1' and addrB=writeRegEX else
             ALUoutM  when opValidM='1' and addrB=writeRegM and isLDM='0' else
             readDataM when opValidM='1' and addrB=writeRegM and isLDM='1' else
             resultWB when opValidWB='1' and addrB=writeRegWB else
             regB;
   ------------------------------end bypasses------------------------------------

   ALUopID <= InstID(31 downto 25);
   addrA <= InstID(19 downto 15);
   addrB <= InstID(14 downto 10);
   --srcAID <= regA; --DONE ALREADY ON BYPASSES
   --srcBID <= regB; --DONE ALREADY ON BYPASSES

   signImmID(14 downto 0) <= InstID(14 downto 0);
   signImmID(31 downto 15) <= (others = InstID(14));
   
   branchImmID(9 downto 0) <= InstID(9 downto 0);
   branchImmID(14 downto 10) <= InstID(24 downto 20);
   branchImmID(31 downto 15) <= (others = InstID(24));

   jumpImmID(14 downto 0) <= InstID(14 downto 0);
   jumpImmID(19 downto 15) <= InstID(24 downto 20);
   jumpImmID(31 downto 25) <= (others = InstID(24));  

   branchLocID <= (std_logic_vector(signed(shift_left(signed(branchImmID),2)) + signed(PCplus4ID));   
   jumpLocID <= (std_logic_vector(signed(shift_left(signed(jumpImmID),2)) + signed(PCplus4ID));
   
   PClocationID <= jumpLocID when ALUopID="0110001" else
                   branchLocID;                          --std_logic_vector(signed(jumpImm) + signed(PCplus4ID));

   rtID <= InstID(24 downto 20);
   rdID <= InstID(19 downto 15);


   --Final signals forwarding
   srcAEX <= srcAID;
   srcBEX <= srcBID;
   rtEX <= rtID;
   rdEX <= rdID;
   signImmEX <= signImmID;
   PClocationIF <= PClocationID; 











end structure;
