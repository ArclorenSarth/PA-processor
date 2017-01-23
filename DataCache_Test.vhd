library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

entity DataCache_Test is
end DataCache_Test;

architecture behaviour of DataCache_Test is
	
	component DataCache
	port(ADDR: in  std_logic_vector(31 downto 0);
     RW : in std_logic; --- 0=READ / 1=WRITE
     RW_CONTROL: in std_logic; --- 0=Read permision / 1 = write permision
     BYTE_OR_WORD: in std_logic;
     CPU_OR_MEM: in std_logic; --- 0=MEMORY / 1=CPU
     DATA_IN_FROM_MEMORY: in std_logic_vector(127 downto 0);
     DATA_IN_FROM_DATAPATH: in std_logic_vector(31 downto 0);
     data_out_to_memory: out std_logic_vector(127 downto 0);
     data_out_to_path: out std_logic_vector(31 downto 0);
     hit: out std_logic); ----0=miss / 1=hit
	end component;

	for DCache: DataCache use entity work.DataCache;
		 signal ADDR_in: std_logic_vector(31 downto 0);
     signal RW_in : std_logic; --- 0=READ / 1=WRITE
     signal RW_CONTROL_in: std_logic; --- 0=Read permision / 1 = write permision
     signal BYTE_OR_WORD_in: std_logic;
     signal CPU_OR_MEM_in: std_logic; --- 0=MEMORY / 1=CPU
     signal DATA_IN_FROM_MEMORY_in: std_logic_vector(127 downto 0);
     signal DATA_IN_FROM_DATAPATH_in:  std_logic_vector(31 downto 0);
     signal data_out_to_memory_in:  std_logic_vector(127 downto 0);
     signal data_out_to_path_in:  std_logic_vector(31 downto 0);
     signal hit_in: std_logic; ----0=miss / 1=hit
     signal good_data: std_logic_vector(31 downto 0);

    begin
    	DCache: DataCache port map(ADDR => ADDR_in,
    							            RW => RW_in,
                              RW_CONTROL => RW_CONTROL_in,
                              CPU_OR_MEM => CPU_OR_MEM_in,
                              BYTE_OR_WORD=>BYTE_OR_WORD_in,
    							            DATA_IN_FROM_MEMORY => DATA_IN_FROM_MEMORY_in,
                              DATA_IN_FROM_DATAPATH=>DATA_IN_FROM_DATAPATH_in,
    							            data_out_to_memory => data_out_to_memory_in,
                              data_out_to_path => data_out_to_path_in,
                              hit => hit_in);


  test_process: process begin
        loop
            wait for 4 ns;
            ADDR_in<=X"00002000";
            RW_in<='0';
            RW_CONTROL_in<='1';
            CPU_OR_MEM_in<='1';
            BYTE_OR_WORD_in<='0';
            DATA_IN_FROM_MEMORY_in<=X"00000003000000020000000100000000";
            DATA_IN_FROM_DATAPATH_in<=X"88888888";
            wait for 4 ns;
            ADDR_in<=X"00002000";
            RW_in<='0';
            RW_CONTROL_in<='1';
            CPU_OR_MEM_in<='0';
            BYTE_OR_WORD_in<='0';
            DATA_IN_FROM_MEMORY_in<=X"00000003000000020000000100000000";
            DATA_IN_FROM_DATAPATH_in<=X"88888888";
            wait for 2 ns;
            ADDR_in<=X"00002000";
            RW_in<='1';
            RW_CONTROL_in<='1';
            CPU_OR_MEM_in<='0';
            BYTE_OR_WORD_in<='0';
            DATA_IN_FROM_MEMORY_in<=X"00000003000000020000000100000000";
            DATA_IN_FROM_DATAPATH_in<=X"88888888";
            wait for 2 ns;
            ADDR_in<=X"00002000";
            RW_in<='0';
            RW_CONTROL_in<='1';
            CPU_OR_MEM_in<='1';
            BYTE_OR_WORD_in<='0';
            DATA_IN_FROM_MEMORY_in<=X"00000003000000020000000100000000";
            DATA_IN_FROM_DATAPATH_in<=X"88888888";
            wait for 2 ns;
            ADDR_in<=X"00002004";
            RW_in<='0';
            RW_CONTROL_in<='1';
            CPU_OR_MEM_in<='1';
            BYTE_OR_WORD_in<='0';
            DATA_IN_FROM_MEMORY_in<=X"00000003000000020000000100000000";
            DATA_IN_FROM_DATAPATH_in<=X"88888888";
            wait for 2 ns;
            ADDR_in<=X"00002008";
            RW_in<='0';
            RW_CONTROL_in<='1';
            CPU_OR_MEM_in<='1';
            BYTE_OR_WORD_in<='0';
            DATA_IN_FROM_MEMORY_in<=X"00000003000000020000000100000000";
            DATA_IN_FROM_DATAPATH_in<=X"88888888";
            wait for 2 ns;
            ADDR_in<=X"00002010";
            RW_in<='0';
            RW_CONTROL_in<='1';
            CPU_OR_MEM_in<='1';
            BYTE_OR_WORD_in<='0';
            DATA_IN_FROM_MEMORY_in<=X"00000003000000020000000100000000";
            DATA_IN_FROM_DATAPATH_in<=X"88888888";
            wait for 2 ns;
            ADDR_in<=X"00002010";
            RW_in<='0';
            RW_CONTROL_in<='0';
            CPU_OR_MEM_in<='0';
            BYTE_OR_WORD_in<='0';
            DATA_IN_FROM_MEMORY_in<=X"00000007000000060000000500000004";
            DATA_IN_FROM_DATAPATH_in<=X"88888888";
            wait for 2 ns;
            ADDR_in<=X"00002010";
            RW_in<='0';
            RW_CONTROL_in<='1';
            CPU_OR_MEM_in<='0';
            BYTE_OR_WORD_in<='0';
            DATA_IN_FROM_MEMORY_in<=X"00000007000000060000000500000004";
            DATA_IN_FROM_DATAPATH_in<=X"88888888";
            wait for 2 ns;
            ADDR_in<=X"00002010";
            RW_in<='1';
            RW_CONTROL_in<='1';
            CPU_OR_MEM_in<='0';
            BYTE_OR_WORD_in<='0';
            DATA_IN_FROM_MEMORY_in<=X"00000007000000060000000500000004";
            DATA_IN_FROM_DATAPATH_in<=X"88888888";
            wait for 2 ns;
            ADDR_in<=X"00002010";
            RW_in<='0';
            RW_CONTROL_in<='1';
            CPU_OR_MEM_in<='1';
            BYTE_OR_WORD_in<='0';
            DATA_IN_FROM_MEMORY_in<=X"00000007000000060000000500000004";
            DATA_IN_FROM_DATAPATH_in<=X"88888888";
            wait for 2 ns;
            ADDR_in<=X"00002014";
            RW_in<='0';
            RW_CONTROL_in<='1';
            CPU_OR_MEM_in<='1';
            BYTE_OR_WORD_in<='0';
            DATA_IN_FROM_MEMORY_in<=X"00000007000000060000000500000004";
            DATA_IN_FROM_DATAPATH_in<=X"88888888";
        end loop;
  end process;

  good_data <= data_out_to_path_in when hit_in='1' else "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU";


  end behaviour;