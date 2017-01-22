library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity alu IS
   port (x : in  std_logic_vector(31 downto 0);
         y : in  std_logic_vector(31 downto 0);
         op : in std_logic_vector(6 downto 0);
         w : out std_logic_vector(31 downto 0));
end alu;



architecture structure of alu is

   signal aritReg : std_logic_vector(31 downto 0);
   signal memReg : std_logic_vector(31 downto 0);
   signal branchReg : std_logic_vector(31 downto 0);

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
       




begin
	
   aritReg <= std_logic_vector(signed(x) * signed(y)) when op = "0000010" else
              std_logic_vector(signed(x) - signed(y)) when op = "0000001" else
              std_logic_vector(signed(x) + signed(y));	
	
   memReg <= std_logic_vector(signed(x) + signed(y));

   branchReg <= std_logic_vector(signed(x) + signed(y));

   w(31 downto 0) <= aritReg(31 downto 0) when op <= "0000010" and op >= "0000000" else
                     memReg(31 downto 0) when op <= "0010100" and op >= "0010000" else
                     branchReg(31 downto 0);


end structure;
