library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

entity Fetch_Test is
end Fetch_Test;

architecture behaviour of Fetch_Test is
	
	component Fetch
	port (clk : in std_logic;
          muxIF : in std_logic;
          reset : in std_logic;
          PCPlus4F : in std_logic_vector(31 downto 0);
          PCLocation : in std_logic_vector(31 downto 0);
          inst, PC : out std_logic_vector(31 downto 0));
	end component;

	for Fetch_0: Fetch use entity work.Fetch;
		signal clk_in :  std_logic;
		signal muxIF_in : std_logic;
        signal boot_in :  std_logic;
        signal PCLocation_in, inst_in : std_logic_vector(31 downto 0);
        signal PC_out :  std_logic_vector(31 downto 0);

    begin
    	Fetch_0: Fetch port map(clk => clk_in,
    							muxIF => muxIF_in,
                                reset => boot_in,
    							PCPlus4F => PC_out,
    							PCLocation => PCLocation_in,
                                inst => inst_in,
    							PC => PC_out
                                );

    clock: process begin
        loop
            clk_in <= '0'; 
            wait for 1 ns;
            clk_in <= '1';
			wait for 1 ns;
		end loop;
	end process;


    muxIF_in <= '1';

  --PCPlus4F_in<=PC_out;

  boot_process: process begin
        loop
            wait for 2 ns;
            boot_in <= '1';
            --PCPlus4F_in <= X"00001000";
            --PC_out <= X"00001000";
            wait for 2 ns;
            boot_in<='0';
            wait for 10 ns;
        end loop;
  end process;

  end behaviour;