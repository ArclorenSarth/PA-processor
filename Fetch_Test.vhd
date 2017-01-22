library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

entity Fetch_Test is
end Fetch_Test;

architecture behaviour of Fetch_Test is
	
	component Fetch_Full
	port (clk : in std_logic;
          muxIF : in std_logic;
          reset : in std_logic;
          FWWE: in std_logic;
          PCLocation : in std_logic_vector(31 downto 0);
          inst, PC : out std_logic_vector(31 downto 0));
	end component;

	for Fetch_0: Fetch_Full use entity work.Fetch_Full;
		signal clk_in :  std_logic;
		signal muxIF_in : std_logic;
        signal boot_in :  std_logic;
        signal fwwe_in : std_logic;
        signal PCLocation_in, inst_in : std_logic_vector(31 downto 0);
        signal PC_out :  std_logic_vector(31 downto 0);

    begin
    	Fetch_0: Fetch_Full port map(clk => clk_in,
    							muxIF => muxIF_in,
                                reset => boot_in,
                                FWWE => fwwe_in,
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


    --muxIF_in <= '1';


  --PCPlus4F_in<=PC_out;

  boot_process: process begin
        loop
            --if rising_edge(clk_in) then
                boot_in <= '1';
                muxIF_in <='1';
                --fwwe_in <= '0';
                wait for 1 ns;
            --end if ;
            --if rising_edge(clk_in) then

                wait for 1 ns;
                boot_in <= '0';
                --fwwe_in <= '0';

                wait for 1 ns;
                --fwwe_in <= '1';

            --end if ;
            wait for 20 ns;
            PCLocation_in<=X"00001008";
            muxIF_in <='0';
            wait for 4 ns;
            muxIF_in <='1';
            wait for 20 ns;
        end loop;
  end process;

  end behaviour;