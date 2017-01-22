library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;


entity Execute_Test is
end Execute_Test;


architecture structure of Execute_Test is


component Execute is
   port (clk : in std_logic;
         ctrlRegWriteEX : in std_logic;
         ctrlMemtoRegEX : in std_logic;
         ctrlMemWriteEX : in std_logic;
         ctrlALUopEX : in std_logic_vector(6 downto 0);
         ctrlALUsrcEX : in std_logic;
         ctrlRegDestEX : in std_logic;
         ctrlJalEX : in std_logic;
         
         srcAEX : in std_logic_vector(31 downto 0);
         srcBEX : in std_logic_vector(31 downto 0);
         rtEX : in std_logic_vector(4 downto 0);
         rdEX : in std_logic_vector(4 downto 0);
         signImmEX : in std_logic_vector(31 downto 0);
         jumpImmEX : in std_logic_vector(31 downto 0);
         
         ctrlRegWriteM : out std_logic;
         ctrlMemtoRegM : out std_logic;
         ctrlMemWriteM  : out std_logic;

         ALUoutM : out std_logic_vector(31 downto 0);
         writeDataM : out std_logic_vector(31 downto 0);
         writeRegM : out std_logic_vector(4 downto 0));

end component;


component FWRegEXtoMEM is
   port (clk : in std_logic;
         we : in std_logic;
         reset : in std_logic;
         
         ctrlRegWriteEX : in std_logic;
         ctrlMemtoRegEX : in std_logic;
         ctrlMemWriteEX : in std_logic;
         ALUoutEX : in std_logic_vector(31 downto 0);
         writeDataEX : in std_logic_vector(31 downto 0);
         writeRegEX : in std_logic_vector(4 downto 0);
         
         ctrlRegWriteM : out std_logic;
         ctrlMemtoRegM : out std_logic;
         ctrlMemWriteM : out std_logic;
         ALUoutM : out std_logic_vector(31 downto 0);
         writeDataM : out std_logic_vector(31 downto 0);
         writeRegM : out std_logic_vector(4 downto 0));

end component;


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

end component;

   --signals between ID and FW
   signal ctrlRegWrite : std_logic;
   signal ctrlMemtoReg : std_logic;
   signal ctrlMemWrite : std_logic;
   signal ctrlALUop : std_logic_vector(6 downto 0);
   signal ctrlALUsrc : std_logic;
   signal ctrlRegDest : std_logic;
   signal ctrlJal : std_logic;
   signal srcA : std_logic_vector(31 downto 0);
   signal srcB : std_logic_vector(31 downto 0);
   signal rt : std_logic_vector(4 downto 0);
   signal rd : std_logic_vector(4 downto 0);
   signal signImm : std_logic_vector(31 downto 0);
   signal jumpImm : std_logic_vector(31 downto 0);

   signal clk : std_logic;
   signal we : std_logic;
   signal reset : std_logic;


   --signals tmp between FW and Execute
   signal ctrlRegWriteFWtoEX : std_logic;
   signal ctrlMemtoRegFWtoEX : std_logic;
   signal ctrlMemWriteFWtoEX : std_logic;
   signal ctrlALUopFWtoEX : std_logic_vector(6 downto 0);
   signal ctrlALUsrcFWtoEX : std_logic;
   signal ctrlRegDestFWtoEX : std_logic;
   signal ctrlJalFWtoEX : std_logic;
   signal srcAFWtoEX : std_logic_vector(31 downto 0);
   signal srcBFWtoEX : std_logic_vector(31 downto 0);
   signal rtFWtoEX : std_logic_vector(4 downto 0);
   signal rdFWtoEX : std_logic_vector(4 downto 0);
   signal signImmFWtoEX : std_logic_vector(31 downto 0);
   signal jumpImmFWtoEX : std_logic_vector(31 downto 0);

 
   --signals tmp betweent Execute and FW
   signal ctrlRegWriteEXtoFW : std_logic;
   signal ctrlMemtoRegEXtoFW : std_logic;
   signal ctrlMemWriteEXtoFW  : std_logic;
   signal ALUoutEXtoFW : std_logic_vector(31 downto 0);
   signal writeDataEXtoFW : std_logic_vector(31 downto 0);
   signal writeRegEXtoFW : std_logic_vector(4 downto 0);
   
   --signals tmp between FW and MEM
   signal ctrlRegWriteFWtoM : std_logic;
   signal ctrlMemtoRegFWtoM : std_logic;
   signal ctrlMemWriteFWtoM  : std_logic;
   signal ALUoutFWtoM : std_logic_vector(31 downto 0);
   signal writeDataFWtoM : std_logic_vector(31 downto 0);
   signal writeRegFWtoM : std_logic_vector(4 downto 0);


   


   


begin

   
   FWRegIDtoEX0 : FWRegIDtoEX
   port map(clk => clk,
            we => we,
            reset => reset,
            ctrlRegWriteID => ctrlRegWrite,
            ctrlMemtoRegID => ctrlMemtoReg,
            ctrlMemWriteID => ctrlMemWrite,
            ctrlALUopID =>ctrlALUop,
            ctrlALUsrcID => ctrlALUsrc,
            ctrlRegDestID => ctrlRegDest,
            ctrlJalID => ctrlJal,
            srcAID => srcA,
            srcBID => srcB,
            rtID => rt,
            rdID => rd,
            signImmID => signImm,
            jumpImmID => jumpImm,
            ctrlRegWriteEX => ctrlRegWriteFWtoEX,
            ctrlMemtoRegEX => ctrlMemtoRegFWtoEX,
            ctrlMemWriteEX => ctrlMemWriteFWtoEX,
            ctrlALUopEX => ctrlALUopFWtoEX,
            ctrlALUsrcEX => ctrlALUsrcFWtoEX,
            ctrlRegDestEX => ctrlRegDestFWtoEX,
            ctrlJalEX => ctrlJalFWtoEX,
            srcAEX => srcAFWtoEX,
            srcBEX => srcBFWtoEX,
            rtEX => rtFWtoEX,
            rdEX => rdFWtoEX,
            signImmEX => signImmFWtoEX,
            jumpImmEX => jumpImmFWtoEX);


   Execute0 : Execute
   port map(clk => clk,
            ctrlRegWriteEX => ctrlRegWriteFWtoEX,
            ctrlMemtoRegEX => ctrlMemtoRegFWtoEX,
            ctrlMemWriteEX => ctrlMemWriteFWtoEX,
            ctrlALUopEX => ctrlALUopFWtoEX,
            ctrlALUsrcEX => ctrlALUsrcFWtoEX,
            ctrlRegDestEX => ctrlRegDestFWtoEX,
            ctrlJalEX => ctrlJalFWtoEX,
            srcAEX => srcAFWtoEX,
            srcBEX => srcBFWtoEX,
            rtEX => rtFWtoEX,
            rdEX => rdFWtoEX,
            signImmEX => signImmFWtoEX,
            jumpImmEX => jumpImmFWtoEX,
            ctrlRegWriteM => ctrlRegWriteEXtoFW,
            ctrlMemtoRegM => ctrlMemtoRegEXtoFW,
            ctrlMemWriteM => ctrlMemWriteEXtoFW,
            ALUoutM => ALUoutEXtoFW,
            writeDataM => writeDataEXtoFW,
            writeRegM => writeRegEXtoFW);

   FWRegEXtoMEM0 : FWRegEXtoMEM
   port map(clk => clk,
         we => we,
         reset => reset,
         ctrlRegWriteEX => ctrlRegWriteEXtoFW,
         ctrlMemtoRegEX => ctrlMemtoRegEXtoFW,
         ctrlMemWriteEX => ctrlMemWriteEXtoFW,
         ALUoutEX => ALUoutEXtoFW,
         writeDataEX => writeDataEXtoFW,
         writeRegEX => writeRegEXtoFW,
         ctrlRegWriteM => ctrlRegWriteFWtoM,
         ctrlMemtoRegM => ctrlMemtoRegFWtoM,
         ctrlMemWriteM => ctrlMemWriteFWtoM,
         ALUoutM => ALUoutFWtoM,
         writeDataM => writeDataFWtoM,
         writeRegM =>writeRegFWtoM);



   
   test_execute: process 
   begin
   loop
      wait for 2 ns;
      reset <= '1';
      wait for 2 ns;
      ctrlRegWrite <= '0';
      ctrlMemtoReg <= '0';
      ctrlMemWrite <= '0';
      ctrlALUop <= "0000000";
      ctrlALUsrc <= '0';
      ctrlRegDest <= '0';
      ctrlJal <= '0';
      srcA <= x"00000000";
      srcB <= x"00000001";
      rt <= "00001";
      rd <= "00010";
      signImm <= x"00000010";
      jumpImm <= x"00000020";

      we <= '0';
      reset <= '0';
      wait for 2 ns;
      ctrlRegWrite <= '1';
      ctrlMemtoReg <= '1';
      ctrlMemWrite <= '1';
      ctrlALUop <= "0000001";
      ctrlALUsrc <= '1';
      ctrlRegDest <= '1';
      ctrlJal <= '1';
      srcA <= x"00000003";
      srcB <= x"00000004";
      rt <= "00011";
      rd <= "00100";
      signImm <= x"00000000";
      jumpImm <= x"00000010";

      we <= '1';
      reset <= '0';
      wait for 2 ns;
      ctrlRegWrite <= '0';
      ctrlMemtoReg <= '0';
      ctrlMemWrite <= '0';
      ctrlALUop <= "0000000";
      ctrlALUsrc <= '0';
      ctrlRegDest <= '0';
      ctrlJal <= '0';
      srcA <= x"00000000";
      srcB <= x"00000001";
      rt <= "00001";
      rd <= "00010";
      signImm <= x"00000010";
      jumpImm <= x"00000020";

      we <= '1';
      reset <= '0';
   
   end loop;
   end process;




   clock: process 
   begin
   loop
      clk <= '0'; 
      wait for 1 ns;
      clk <= '1';
      wait for 1 ns;
   end loop;
   end process;


end structure;




