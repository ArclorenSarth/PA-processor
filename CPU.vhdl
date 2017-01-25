library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;


entity CPU is
end CPU;


architecture structure of CPU is

component Fetch_Full is
    port (clk : in std_logic;
          muxIF : in std_logic;
          reset : in std_logic;
          FWWE : in std_logic;
          PCLocation : in std_logic_vector(31 downto 0);
          inst, PC : out std_logic_vector(31 downto 0);
          cacheIhitID: out std_logic);
end component;

   signal ctrlJumpIDtoIF : std_logic;
   signal PCLocationIDtoIF : std_logic_vector(31 downto 0);
   signal instIFtoFW : std_logic_vector(31 downto 0);
   signal PCplus4IFtoFW : std_logic_vector(31 downto 0);
   signal cacheIhitIFtoID : std_logic;

component FWRegIFtoID is
   port (clk : in std_logic;
         we : in std_logic;
         reset : in std_logic;
         
         instIF : in std_logic_vector(31 downto 0);
         PCplus4IF : in std_logic_vector(31 downto 0);
         instID : out std_logic_vector(31 downto 0);
         PCplus4ID : out std_logic_vector(31 downto 0));
end component;

   signal instFWtoID : std_logic_vector(31 downto 0);
   signal PCplus4FWtoID : std_logic_vector(31 downto 0);

component Decoder is
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
         ctrlJumpIF : out std_logic;
         PClocationIF : out std_logic_vector(31 downto 0);
         forwardingWE : out std_logic);
         

end component;

   signal cacheDhitMtoID : std_logic;

-- SIGNALS between ID and FW
   signal ctrlRegWriteIDtoFW : std_logic;
   signal ctrlMemtoRegIDtoFW : std_logic;
   signal ctrlMemWriteIDtoFW : std_logic;
   signal ctrlALUopIDtoFW : std_logic_vector(6 downto 0);
   signal ctrlALUsrcIDtoFW : std_logic;
   signal ctrlRegDestIDtoFW : std_logic;
   signal ctrlByteIDtoFW : std_logic;
   signal ctrlBypassAIDtoFW : std_logic;
   signal ctrlBypassBIDtoFW : std_logic;
   signal srcAIDtoFW : std_logic_vector(31 downto 0);
   signal srcBIDtoFW : std_logic_vector(31 downto 0);
   signal rtIDtoFW : std_logic_vector(4 downto 0);
   signal rdIDtoFW : std_logic_vector(4 downto 0);
   signal signImmIDtoFW : std_logic_vector(31 downto 0);
  
component FWRegIDtoEX is
   port (clk : in std_logic;
         we : in std_logic;
         reset : in std_logic;
         
         ctrlRegWriteID : in std_logic;
         ctrlMemtoRegID : in std_logic;
         ctrlMemWriteID : in std_logic;
         ctrlALUopID : in std_logic_vector(6 downto 0);
         ctrlALUsrcID : in std_logic;
         ctrlRegDestID : in std_logic;
         ctrlByteID : in std_logic;
         ctrlBypassAID : in std_logic;
         ctrlBypassBID : in std_logic;

         srcAID : in std_logic_vector(31 downto 0);
         srcBID : in std_logic_vector(31 downto 0);
         rtID : in std_logic_vector(4 downto 0);
         rdID : in std_logic_vector(4 downto 0);
         signImmID : in std_logic_vector(31 downto 0);
         --jumpImmID : in std_logic_vector(31 downto 0);

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
         signImmEX : out std_logic_vector(31 downto 0));
         
end component;

--signals tmp between FW and Execute
   signal ctrlRegWriteFWtoEX : std_logic;
   signal ctrlMemtoRegFWtoEX : std_logic;
   signal ctrlMemWriteFWtoEX : std_logic;
   signal ctrlALUopFWtoEX : std_logic_vector(6 downto 0);
   signal ctrlALUsrcFWtoEX : std_logic;
   signal ctrlRegDestFWtoEX : std_logic;
   signal ctrlByteFWtoEX : std_logic;
   signal ctrlBypassAFWtoEX : std_logic;
   signal ctrlBypassBFWtoEX : std_logic;
   signal srcAFWtoEX : std_logic_vector(31 downto 0);
   signal srcBFWtoEX : std_logic_vector(31 downto 0);
   signal rtFWtoEX : std_logic_vector(4 downto 0);
   signal rdFWtoEX : std_logic_vector(4 downto 0);
   signal signImmFWtoEX : std_logic_vector(31 downto 0);

component Execute is
   port (clk : in std_logic;
         ctrlRegWriteEX : in std_logic;
         ctrlMemtoRegEX : in std_logic;
         ctrlMemWriteEX : in std_logic;
         ctrlALUopEX : in std_logic_vector(6 downto 0);
         ctrlALUsrcEX : in std_logic;
         ctrlRegDestEX : in std_logic;
         ctrlByteEX : in std_logic;
         ctrlBypassAEX : in std_logic;
         ctrlBypassBEX : in std_logic;
         
         srcAEX : in std_logic_vector(31 downto 0);
         srcBEX : in std_logic_vector(31 downto 0);
         rtEX : in std_logic_vector(4 downto 0);
         rdEX : in std_logic_vector(4 downto 0);
         signImmEX : in std_logic_vector(31 downto 0);
         readDataM : in std_logic_vector(31 downto 0);
         
         ctrlRegWriteM : out std_logic;
         ctrlMemtoRegM : out std_logic;
         ctrlMemWriteM  : out std_logic;
         ctrlALUopM : out std_logic_vector(6 downto 0);
         ctrlByteM : out std_logic;

         ALUoutM : out std_logic_vector(31 downto 0);
         writeDataM : out std_logic_vector(31 downto 0);
         writeRegM : out std_logic_vector(4 downto 0));

end component;
   
   signal readDataMtoEX : std_logic_vector(31 downto 0);
   --signals tmp betweent Execute and FW
   signal ctrlRegWriteEXtoFW : std_logic;
   signal ctrlMemtoRegEXtoFW : std_logic;
   signal ctrlMemWriteEXtoFW  : std_logic;
   signal ctrlALUopEXtoFW : std_logic_vector(6 downto 0);
   signal ctrlByteEXtoFW : std_logic;
   signal ALUoutEXtoFW : std_logic_vector(31 downto 0);
   signal writeDataEXtoFW : std_logic_vector(31 downto 0);
   signal writeRegEXtoFW : std_logic_vector(4 downto 0);
   

component FWRegEXtoMEM is
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

end component;

--signals tmp between FW and MEM
   signal ctrlRegWriteFWtoM : std_logic;
   signal ctrlMemtoRegFWtoM : std_logic;
   signal ctrlMemWriteFWtoM  : std_logic;
   signal ctrlALUopFWtoM : std_logic_vector(6 downto 0);
   signal ctrlByteFWtoM : std_logic;
   signal ALUoutFWtoM : std_logic_vector(31 downto 0);
   signal writeDataFWtoM : std_logic_vector(31 downto 0);
   signal writeRegFWtoM : std_logic_vector(4 downto 0);

component Memory is
    port (ALUOUTM : in std_logic_vector(31 downto 0);
    	  WRITEDATAM : in std_logic_vector(31 downto 0);
          MEMWRITEM : in std_logic;
          MEMTOREGM : in std_logic;
          ctrlALUopEX : in std_logic_vector(6 downto 0);
          ctrlByteEX : in std_logic;
          REGWRITEM : in std_logic;
          WRITEREGM : in std_logic_vector(4 downto 0);
          reset : in std_logic;
          clk : in std_logic;
          ctrlRegWriteM : out std_logic;
          ctrlMemtoRegM : out std_logic;
          ctrlALUopM : out std_logic_vector(6 downto 0);
          ALUoutMFW : out std_logic_vector(31 downto 0);
          WRITEREGMFW : out std_logic_vector(4 downto 0);
          hit_m : out std_logic;
          ReadData : out std_logic_vector(31 downto 0));
end component;


   signal ALUoutMtoFW : std_logic_vector(31 downto 0);
   signal readDataMtoFW : std_logic_vector(31 downto 0);
   signal writeRegMtoFW : std_logic_vector(4 downto 0);
   signal ctrlALUopMtoFW : std_logic_vector(6 downto 0);
   signal ctrlRegWriteMtoFW : std_logic;
   signal ctrlMemtoRegMtoFW : std_logic;

component FWRegMEMtoWB is
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
end component;

   signal ctrlMemtoRegFWtoWB : std_logic;
   signal ctrlALUopFWtoWB : std_logic_vector(6 downto 0);
   signal ALUoutFWtoWB : std_logic_vector(31 downto 0);
   signal readDataFWtoWB : std_logic_vector(31 downto 0);
   
   signal weWBtoID : std_logic;
   signal resultWBtoID : std_logic_vector(31 downto 0);
   signal writeRegWBtoID : std_logic_vector(4 downto 0);
   signal ctrlALUopWBtoID : std_logic_vector(6 downto 0);
   



   signal clk : std_logic := '0';
   signal weFW : std_logic := '0';
   signal reset : std_logic := '0';



   


begin


   Fetch0 : Fetch_Full
   port map(clk => clk,
          muxIF => ctrlJumpIDtoIF,
          reset => reset,
          FWWE => weFW,
          PCLocation => PCLocationIDtoIF,
          inst => instIFtoFW, 
          PC => PCplus4IFtoFW,
          cacheIhitID => cacheIhitIFtoID);

   FWRegIFtoID0 : FWRegIFtoID
   port map (clk => clk,
         we => weFW,
         reset => reset,
         instIF => instIFtoFW,
         PCplus4IF => PCplus4IFtoFW,
         instID => instFWtoID,
         PCplus4ID => PCplus4FWtoID);

   Decoder0 : Decoder
   port map(clk => clk,
         cacheIHitIF => cacheIhitIFtoID,
         cacheDHitM => cacheDhitMtoID,
         InstID => instFWtoID,
         PCplus4ID => PCplus4FWtoID,
         
         --register write-back
         weWB => weWBtoID,
         resultWB => resultWBtoID,
         writeRegWB => writeRegWBtoID,         
   
         --bypasses
         ALUoutEX => ALUoutEXtoFW,
         ALUoutM => ALUoutMtoFW,
         readDataM => readDataMtoFW,
         writeRegEX => writeRegEXtoFW,
         writeRegM => writeRegMtoFW,
         ALUopOldEX => ctrlALUopEXtoFW,
         ALUopOldM => ctrlALUopMtoFW,
         ALUopOldWB => ctrlALUopWBtoID,
                 
         ctrlRegWriteEX => ctrlRegWriteIDtoFW,
         ctrlMemtoRegEX => ctrlMemtoRegIDtoFW,
         ctrlMemWriteEX => ctrlMemWriteIDtoFW,
         ctrlALUopEX => ctrlALUopIDtoFW,
         ctrlALUsrcEX => ctrlALUsrcIDtoFW,
         ctrlRegDestEX => ctrlRegDestIDtoFW,
         ctrlByteEX => ctrlByteIDtoFW,
         ctrlBypassAEX => ctrlBypassAIDtoFW,
         ctrlBypassBEX => ctrlBypassBIDtoFW,
         srcAEX => srcAIDtoFW,
         srcBEX => srcBIDtoFW,
         rtEX => rtIDtoFW,
         rdEX => rdIDtoFW,
         signImmEX => signImmIDtoFW,
         ctrlJumpIF => ctrlJumpIDtoIF, 
         PClocationIF => PClocationIDtoIF,
         forwardingWE => weFW);

   
   FWRegIDtoEX0 : FWRegIDtoEX
   port map(clk => clk,
            we => weFW,
            reset => reset,
            ctrlRegWriteID => ctrlRegWriteIDtoFW,
            ctrlMemtoRegID => ctrlMemtoRegIDtoFW,
            ctrlMemWriteID => ctrlMemWriteIDtoFW,
            ctrlALUopID =>ctrlALUopIDtoFW,
            ctrlALUsrcID => ctrlALUsrcIDtoFW,
            ctrlRegDestID => ctrlRegDestIDtoFW,
            ctrlByteID => ctrlByteIDtoFW,
            ctrlBypassAID => ctrlBypassAIDtoFW,
            ctrlBypassBID => ctrlBypassBIDtoFW,
            srcAID => srcAIDtoFW,
            srcBID => srcBIDtoFW,
            rtID => rtIDtoFW,
            rdID => rdIDtoFW,
            signImmID => signImmIDtoFW,

            ctrlRegWriteEX => ctrlRegWriteFWtoEX,
            ctrlMemtoRegEX => ctrlMemtoRegFWtoEX,
            ctrlMemWriteEX => ctrlMemWriteFWtoEX,
            ctrlALUopEX => ctrlALUopFWtoEX,
            ctrlALUsrcEX => ctrlALUsrcFWtoEX,
            ctrlRegDestEX => ctrlRegDestFWtoEX,
            ctrlByteEX => ctrlByteFWtoEX,
            ctrlBypassAEX => ctrlBypassAFWtoEX,
            ctrlBypassBEX => ctrlBypassBFWtoEX,
            srcAEX => srcAFWtoEX,
            srcBEX => srcBFWtoEX,
            rtEX => rtFWtoEX,
            rdEX => rdFWtoEX,
            signImmEX => signImmFWtoEX);
 


   Execute0 : Execute
   port map(clk => clk,
            ctrlRegWriteEX => ctrlRegWriteFWtoEX,
            ctrlMemtoRegEX => ctrlMemtoRegFWtoEX,
            ctrlMemWriteEX => ctrlMemWriteFWtoEX,
            ctrlALUopEX => ctrlALUopFWtoEX,
            ctrlALUsrcEX => ctrlALUsrcFWtoEX,
            ctrlRegDestEX => ctrlRegDestFWtoEX,
            ctrlByteEX => ctrlByteFWtoEX,
            ctrlBypassAEX => ctrlBypassAFWtoEX,
            ctrlBypassBEX => ctrlBypassBFWtoEX,
            srcAEX => srcAFWtoEX,
            srcBEX => srcBFWtoEX,
            rtEX => rtFWtoEX,
            rdEX => rdFWtoEX,
            signImmEX => signImmFWtoEX,
            readDataM => readDataMtoEX,
            ctrlRegWriteM => ctrlRegWriteEXtoFW,
            ctrlMemtoRegM => ctrlMemtoRegEXtoFW,
            ctrlMemWriteM => ctrlMemWriteEXtoFW,
            ctrlALUopM => ctrlALUopEXtoFW,
            ctrlByteM => ctrlByteEXtoFW,
            ALUoutM => ALUoutEXtoFW,
            writeDataM => writeDataEXtoFW,
            writeRegM => writeRegEXtoFW);

   FWRegEXtoMEM0 : FWRegEXtoMEM
   port map(clk => clk,
         we => weFW,
         reset => reset,
         ctrlRegWriteEX => ctrlRegWriteEXtoFW,
         ctrlMemtoRegEX => ctrlMemtoRegEXtoFW,
         ctrlMemWriteEX => ctrlMemWriteEXtoFW,
         ctrlALUopEX => ctrlALUopEXtoFW,
         ctrlByteEX => ctrlByteEXtoFW,
         ALUoutEX => ALUoutEXtoFW,
         writeDataEX => writeDataEXtoFW,
         writeRegEX => writeRegEXtoFW,
         ctrlRegWriteM => ctrlRegWriteFWtoM,
         ctrlMemtoRegM => ctrlMemtoRegFWtoM,
         ctrlMemWriteM => ctrlMemWriteFWtoM,
         ctrlALUopM => ctrlALUopFWtoM,
         ctrlByteM => ctrlByteFWtoM,
         ALUoutM => ALUoutFWtoM,
         writeDataM => writeDataFWtoM,
         writeRegM => writeRegFWtoM);

    Memory1 : Memory
    port map(ALUOUTM => ALUoutFWtoM,
    	  WRITEDATAM => writeDataFWtoM,
          MEMWRITEM => ctrlMemWriteFWtoM,
          MEMTOREGM => ctrlMemtoRegFWtoM,
          ctrlALUopEX => ctrlALUopFWtoM,
          ctrlByteEX => ctrlByteFWtoM,
          REGWRITEM => ctrlRegWriteFWtoM,
          WRITEREGM => writeRegFWtoM,
          reset => reset,
          clk => clk,
          ctrlRegWriteM => ctrlRegWriteMtoFW,
          ctrlMemtoRegM => ctrlMemtoRegMtoFW,
          ctrlALUopM => ctrlALUopMtoFW,
          ALUoutMFW => ALUoutMtoFW,
          WRITEREGMFW => writeRegMtoFW,
          hit_m => cacheDhitMtoID,
          ReadData => readDataMtoFW);


   FWRegMEMtoWB0 : FWRegMEMtoWB 
   port map(clk => clk,
         we => weFW,
         reset => reset,
         
         ctrlRegWriteM => ctrlRegWriteMtoFW,
         ctrlMemtoRegM => ctrlMemtoRegMtoFW,
         ctrlALUopM => ctrlALUopMtoFW,
         ALUoutM => ALUoutMtoFW,
         readDataM => readDataMtoFW,
         writeRegM => writeRegMtoFW,
         
         ctrlRegWriteWB => weWBtoID,
         ctrlMemtoRegWB => ctrlMemtoRegFWtoWB,
         ctrlALUopWB => ctrlALUopWBtoID,
         ALUoutWB => ALUoutFWtoWB,
         readDataWB => readDataFWtoWB,
         writeRegWB => writeRegWBtoID);




   resultWBtoID <= readDataFWtoWB when ctrlMemtoRegFWtoWB='1' else
                   ALUoutFWtoWB;

   
   test_execute: process 
   begin
      reset <= '1';
      wait until rising_edge(clk); 
      reset <= '0';
      wait;
   end process;

   --reset <= '1' after 4 ns, '0' after 4 ns;
   clk <= not clk after 2 ns;

   --clock: process 
   --begin
   --loop
     -- clk <= '0'; 
      --wait for 1 ns;
      --clk <= '1';
     -- wait for 1 ns;
   --end loop;
   --end process;


end structure;




