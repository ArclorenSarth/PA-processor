LIBRARY ieee;
USE ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

ENTITY alu IS
        PORT (x : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
              y : IN  STD_LOGIC_VECTOR(31 DOWNTO 0);
              op : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
              w : OUT STD_LOGIC_VECTOR(32 DOWNTO 0);
              z : OUT STD_LOGIC);
END alu;



ARCHITECTURE Structure OF alu IS

signal aritReg : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal memReg : STD_LOGIC_VECTOR(31 DOWNTO 0);
signal branchReg : STD_LOGIC_VECTOR(31 DOWNTO 0);

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
       




BEGIN
	
	aritReg <= std_logic_vector(signed(x) * signed(y)) when op = "0000010" else
                   std_logic_vector(signed(x) - signed(y)) when op = "0000001" else
                   std_logic_vector(signed(x) + signed(y));	
	
	memReg <= std_logic_vector(signed(x) + signed(y));
	branchReg <= std_logic_vector(signed(x) + signed(y));

	w(31 downto 0) <= aritReg(31 downto 0) when op <= "0000010" and op >= "0000000" else
                          memReg(31 downto 0) when op <= "0010100" and op >= "0010000" else
                          branchReg(31 downto 0);

	z <= '1' when y = x"0000" else
             '0';


END Structure;
