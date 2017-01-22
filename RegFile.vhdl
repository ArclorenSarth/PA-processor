library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;        


entity RegFile is 
	port (clk : in std_logic; 
			wrd : in std_logic; 
			d : in std_logic_vector(31 downto 0); 
			addr_a : in std_logic_vector(4 downto 0); 
			addr_b : in std_logic_vector(4 downto 0); 
			addr_d : in std_logic_vector(4 downto 0); 
			a : out std_logic_vector(31 downto 0); 
			b : out std_logic_vector(31 downto 0)); 

end RegFile;


architecture structure of RegFile is
	type RegistersBank is array (31 downto 0) of std_logic_vector(31 downto 0);
   signal RegBank        : RegistersBank;

begin
	
	a <= RegBank(conv_integer(addr_a));
	b <= RegBank(conv_integer(addr_b));
	reg_rw : process (clk)
	begin
		RegBank <= RegBank;
		if rising_edge(clk) and wrd = '1' then
			RegBank(conv_integer(addr_d)) <= d;
		end if;
	end process;											
	
	
end structure;
