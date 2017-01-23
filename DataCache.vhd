library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
USE ieee.std_logic_unsigned.all;
use std.textio.all;

--- NON GENERIC CACHE -- 4 lines of 128 bits each = 512 bits
entity DataCache is 
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

end DataCache;

architecture behav of DataCache is
	
	type data_store_type is array (3 downto 0) of std_logic_vector(127 downto 0);
	type tag_store_type is array (3 downto 0) of std_logic_vector(25 downto 0);
	type valid_store_type is array (3 downto 0) of std_logic;
	type dirt_store_type is array (3 downto 0) of std_logic;

	signal tag_eq: std_logic;
	signal tag: std_logic_vector(25 downto 0);
	signal set: std_logic_vector(1 downto 0);
	signal block_offset: std_logic_vector(1 downto 0);
	signal byte_ofset : std_logic_vector(1 downto 0);

	signal data_store: data_store_type;
	signal tag_store: tag_store_type;
	signal valid_store: valid_store_type := "0000";
	signal dirty_store: dirt_store_type := "0000";

	signal writing_from_memory: std_logic;
	signal writing_from_cpu: std_logic;
	signal reading_from_memory: std_logic;
	signal reading_from_cpu:std_logic;

	signal word_out: std_logic_vector(31 downto 0);
	signal byte_out: std_logic_vector(31 downto 0);



	begin
		tag <= ADDR(31 downto 6);
		set <= ADDR(5 downto 4);
		block_offset <= ADDR(3 downto 2);
		byte_ofset <= ADDR(1 downto 0);

		writing_from_memory<= RW and RW_CONTROL and not CPU_OR_MEM;
		writing_from_cpu <= RW and RW_CONTROL and CPU_OR_MEM;
		reading_from_memory<=not RW and RW_CONTROL and not CPU_OR_MEM;
		reading_from_cpu<= not RW and RW_CONTROL and CPU_OR_MEM;
		--ON READ
		tag_eq <= '1' when to_integer(unsigned(tag_store(to_integer(unsigned(set)))))= to_integer(unsigned(tag)) and RW_CONTROL='1' else '0';
		hit <= '1' when (tag_eq='1' and valid_store(to_integer(unsigned(set)))='1') else '0';


		word_out <= data_store(to_integer(unsigned(set)))(127 downto 96) when reading_from_cpu='1'  and  block_offset="11" else
				data_store(to_integer(unsigned(set)))(95 downto 64) when reading_from_cpu='1' and block_offset="10" else
				data_store(to_integer(unsigned(set)))(63 downto 32) when reading_from_cpu='1' and block_offset="01" else
				data_store(to_integer(unsigned(set)))(31 downto 0) when reading_from_cpu='1' and block_offset="00" else
				"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

		byte_out <= X"000000" & word_out(31 downto 24) when byte_ofset="11" else
					X"000000" & word_out(23 downto 16) when byte_ofset="10" else
					X"000000" & word_out(15 downto 8) when byte_ofset="01" else
					X"000000" & word_out(7 downto 0) when byte_ofset="00" else
					"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

		data_out_to_path<= word_out when BYTE_OR_WORD='0' else 
							byte_out when BYTE_OR_WORD='1' else
							"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

		data_out_to_memory<=data_store(to_integer(unsigned(set))) when (tag_eq='0' or valid_store(to_integer(unsigned(set)))='0') and dirty_store(to_integer(unsigned(set)))='1';




		--ON WRITE
		data_store(to_integer(unsigned(set))) <= DATA_IN_FROM_MEMORY when writing_from_memory='1' and writing_from_cpu='0' else
												 DATA_IN_FROM_DATAPATH & data_store(to_integer(unsigned(set)))(95 downto 0) when writing_from_cpu='1' and  block_offset="11" else
												 data_store(to_integer(unsigned(set)))(127 downto 96) & DATA_IN_FROM_DATAPATH & data_store(to_integer(unsigned(set)))(63 downto 0) when writing_from_cpu='1' and  block_offset="10" else
												 data_store(to_integer(unsigned(set)))(127 downto 64) & DATA_IN_FROM_DATAPATH & data_store(to_integer(unsigned(set)))(31 downto 0) when writing_from_cpu='1' and  block_offset="01" else
												 data_store(to_integer(unsigned(set)))(127 downto 32) & DATA_IN_FROM_DATAPATH  when writing_from_cpu='1' and  block_offset="00" else
												 data_store(to_integer(unsigned(set)));			
			
		--data_store(to_integer(unsigned(set)))(127 downto 96) <= DATA_IN_FROM_DATAPATH when writing_from_cpu='1' and  block_offset="11" else data_store(to_integer(unsigned(set)));
		--data_store(to_integer(unsigned(set)))(95 downto 64) <= DATA_IN_FROM_DATAPATH when writing_from_cpu='1' and block_offset="10" else data_store(to_integer(unsigned(set)));
		--data_store(to_integer(unsigned(set)))(63 downto 32) <= DATA_IN_FROM_DATAPATH when writing_from_cpu='1' and block_offset="01" else data_store(to_integer(unsigned(set))); 
		--data_store(to_integer(unsigned(set)))(31 downto 0) <= DATA_IN_FROM_DATAPATH when writing_from_cpu='1' and block_offset="00" else data_store(to_integer(unsigned(set)));

		valid_store(to_integer(unsigned(set))) <= '1' when writing_from_memory='1';

		tag_store(to_integer(unsigned(set))) <= tag when writing_from_memory='1'; 

		dirty_store(to_integer(unsigned(set))) <='1' when writing_from_cpu='1' else
												  '0' when reading_from_memory='1' else
												  dirty_store(to_integer(unsigned(set)));	


end behav;