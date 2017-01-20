library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

entity Cache_Test is
end Cache_Test;

architecture behaviour of Cache_Test is
	
	component Cache
	port(ADDR: in  std_logic_vector(31 downto 0);
     RW : in std_logic; --- 0=READ / 1=WRITE
     RW_CONTROL: in std_logic; --- 0=Not Permission / 1 = Permission
     DATA_IN: in std_logic_vector(127 downto 0);
     data_out: out std_logic_vector(31 downto 0);
     hit: out std_logic); ----0=miss / 1=hit
	end component;

	for Cache_0: Cache use entity work.Cache;
		signal ADDR_in :  std_logic_vector(31 downto 0);
		signal RW_in : std_logic;
    signal RAW_CONTROL_in :  std_logic;
    signal DATA_IN_in: std_logic_vector(127 downto 0);
    signal data_out_in :  std_logic_vector(31 downto 0);
    signal hit_in: std_logic;

    begin
    	Cache_0: Cache port map(ADDR => ADDR_in,
    							            RW => RW_in,
                              RW_CONTROL => RAW_CONTROL_in,
    							            DATA_IN => DATA_IN_in,
    							            data_out => data_out_in,
                              hit => hit_in);


  test_process: process begin
        loop
            wait for 1 ns;
            ADDR_in <= x"00000000";
            RW_in <= '1';
            RAW_CONTROL_in <='1';
            DATA_IN_in <= x"11111111000000000000000000000000";
            wait for 2 ns;
            ADDR_in <= x"00000008";
            RAW_CONTROL_in <='0';
            wait for 1 ns;
            RW_in <= '1';
            RAW_CONTROL_in <='1';
            DATA_IN_in <= x"11111111111111110000000000000000";
            wait for 2 ns;
            ADDR_in <= x"00000010";
            RAW_CONTROL_in <='0';
            wait for 1 ns;
            RW_in <= '1';
            RAW_CONTROL_in <='1';
            DATA_IN_in <= x"11111111111111111111111100000000";
            wait for 2 ns;
            ADDR_in <= x"00000018";
            RAW_CONTROL_in <='0';
            wait for 1 ns;
            RW_in <= '1';
            RAW_CONTROL_in <='1';
            DATA_IN_in <= x"11111111111111111111111122222222";
            wait for 2 ns;
            ADDR_in <= x"00000010";
            RW_in <= '0';
            --RAW_CONTROL_in <='1';
        end loop;
  end process;

  end behaviour;