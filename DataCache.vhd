library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
USE ieee.std_logic_unsigned.all;
use std.textio.all;

--- NON GENERIC CACHE -- 4 lines of 128 bits each = 512 bits
entity DataCache is 
	port(ADDR: in  std_logic_vector(31 downto 0);
		 RW_Cache : in std_logic; --- 0=READ / 1=WRITE
		 RW_CONTROL_Cache: in std_logic; --- 0=Read permision / 1 = write permision
		 RW_MEM: in std_logic;
		 RW_CONTROL_MEM: in std_logic; 
		 BYTE: in std_logic;
		 WORD: in std_logic;
		 DATA_IN_FROM_MEMORY: in std_logic_vector(127 downto 0);			
		 DATA_IN_FROM_DATAPATH: in std_logic_vector(31 downto 0);
		 data_out_to_memory: out std_logic_vector(127 downto 0);
		 data_out_to_path: out std_logic_vector(31 downto 0);
		 adress_to_memory: out std_logic_vector(31	downto 0);
		 dirty: out std_logic;
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
	signal reading_from_cache:std_logic;

	signal word_out: std_logic_vector(31 downto 0);
	signal byte_out: std_logic_vector(31 downto 0);

	signal input_byte: std_logic_vector(7 downto 0);

	signal byte_0_0: std_logic_vector(7 downto 0);
	signal byte_0_1: std_logic_vector(7 downto 0);
	signal byte_0_2: std_logic_vector(7 downto 0);
	signal byte_0_3: std_logic_vector(7 downto 0);

	signal byte_1_0: std_logic_vector(7 downto 0);
	signal byte_1_1: std_logic_vector(7 downto 0);
	signal byte_1_2: std_logic_vector(7 downto 0);
	signal byte_1_3: std_logic_vector(7 downto 0);

	signal byte_2_0: std_logic_vector(7 downto 0);
	signal byte_2_1: std_logic_vector(7 downto 0);
	signal byte_2_2: std_logic_vector(7 downto 0);
	signal byte_2_3: std_logic_vector(7 downto 0);

	signal byte_3_0: std_logic_vector(7 downto 0);
	signal byte_3_1: std_logic_vector(7 downto 0);
	signal byte_3_2: std_logic_vector(7 downto 0);
	signal byte_3_3: std_logic_vector(7 downto 0);

	signal word_0: std_logic_vector(31 downto 0);
	signal word_1: std_logic_vector(31 downto 0);
	signal word_2: std_logic_vector(31 downto 0);
	signal word_3: std_logic_vector(31 downto 0);

	signal eviction: std_logic;


	begin
		tag <= ADDR(31 downto 6);
		set <= ADDR(5 downto 4);
		block_offset <= ADDR(3 downto 2);
		byte_ofset <= ADDR(1 downto 0);
		eviction<= (not tag_eq or not valid_store(to_integer(unsigned(set)))) and dirty_store(to_integer(unsigned(set)));
		writing_from_memory<= RW_MEM and RW_CONTROL_MEM;
		writing_from_cpu <= RW_Cache and RW_CONTROL_Cache;
		reading_from_memory<=not RW_MEM and RW_CONTROL_MEM; 
		reading_from_cache<= not RW_Cache and RW_CONTROL_Cache;
		--ON READ
		tag_eq <= '1' when to_integer(unsigned(tag_store(to_integer(unsigned(set)))))= to_integer(unsigned(tag)) else '0';
		hit <= '1' when (tag_eq='1' and valid_store(to_integer(unsigned(set)))='1') else '0';
		input_byte<=DATA_IN_FROM_DATAPATH(7 downto 0);
		dirty<=dirty_store(to_integer(unsigned(set)));

		byte_0_0 <= data_store(to_integer(unsigned(set)))(7 downto 0);
		byte_0_1 <= data_store(to_integer(unsigned(set)))(15 downto 8);
		byte_0_2 <= data_store(to_integer(unsigned(set)))(23 downto 16);
		byte_0_3 <= data_store(to_integer(unsigned(set)))(31 downto 24);

		byte_1_0 <= data_store(to_integer(unsigned(set)))(39 downto 32);
		byte_1_1 <= data_store(to_integer(unsigned(set)))(47 downto 40);
		byte_1_2 <= data_store(to_integer(unsigned(set)))(55 downto 48);
		byte_1_3 <= data_store(to_integer(unsigned(set)))(63 downto 56);

		byte_2_0 <= data_store(to_integer(unsigned(set)))(71 downto 64);
		byte_2_1 <= data_store(to_integer(unsigned(set)))(79 downto 72);
		byte_2_2 <= data_store(to_integer(unsigned(set)))(87 downto 80);
		byte_2_3 <= data_store(to_integer(unsigned(set)))(95 downto 88);

		byte_3_0 <= data_store(to_integer(unsigned(set)))(103 downto 96);
		byte_3_1 <= data_store(to_integer(unsigned(set)))(111 downto 104);
		byte_3_2 <= data_store(to_integer(unsigned(set)))(119 downto 112);
		byte_3_3 <= data_store(to_integer(unsigned(set)))(127 downto 120);

		word_0 <= data_store(to_integer(unsigned(set)))(31 downto 0);
		word_1 <= data_store(to_integer(unsigned(set)))(63 downto 32);
		word_2 <= data_store(to_integer(unsigned(set)))(95 downto 64);
		word_3 <= data_store(to_integer(unsigned(set)))(127 downto 96);


		word_out <= data_store(to_integer(unsigned(set)))(127 downto 96) when reading_from_cache='1'  and  block_offset="11" else
				data_store(to_integer(unsigned(set)))(95 downto 64) when reading_from_cache='1' and block_offset="10" else
				data_store(to_integer(unsigned(set)))(63 downto 32) when reading_from_cache='1' and block_offset="01" else
				data_store(to_integer(unsigned(set)))(31 downto 0) when reading_from_cache='1' and block_offset="00" else
				"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

		byte_out <= X"000000" & word_out(31 downto 24) when byte_ofset="11" else
					X"000000" & word_out(23 downto 16) when byte_ofset="10" else
					X"000000" & word_out(15 downto 8) when byte_ofset="01" else
					X"000000" & word_out(7 downto 0) when byte_ofset="00" else
					"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

		data_out_to_path<= word_out when BYTE='0' and WORD='1' else 
							byte_out when BYTE='1' and WORD='0' else
							"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX";

		data_out_to_memory<=data_store(to_integer(unsigned(set))) when eviction='1' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
		adress_to_memory<= tag_store(to_integer(unsigned(set)))&set&block_offset&"00" when eviction='1' else
							ADDR;




		--ON WRITE
		
		data_store(to_integer(unsigned(set))) <= DATA_IN_FROM_MEMORY when writing_from_memory='1' else

												 DATA_IN_FROM_DATAPATH & data_store(to_integer(unsigned(set)))(95 downto 0) when WORD='1' and writing_from_cpu='1' and  block_offset="11" else
												 	input_byte & data_store(to_integer(unsigned(set)))(119 downto 0) when BYTE='1' and writing_from_cpu='1' and  block_offset="11" and byte_ofset="11" else
												 	byte_3_3 & input_byte & data_store(to_integer(unsigned(set)))(111 downto 0) when BYTE='1' and writing_from_cpu='1' and  block_offset="11" and byte_ofset="10" else
												 	byte_3_3 & byte_3_2 & input_byte & data_store(to_integer(unsigned(set)))(103 downto 0) when BYTE='1' and writing_from_cpu='1' and  block_offset="11" and byte_ofset="01" else
												 	byte_3_3 & byte_3_2 & byte_3_1 & input_byte & data_store(to_integer(unsigned(set)))(95 downto 0) when BYTE='1' and writing_from_cpu='1' and  block_offset="11" and byte_ofset="00" else

												 data_store(to_integer(unsigned(set)))(127 downto 96) & DATA_IN_FROM_DATAPATH & data_store(to_integer(unsigned(set)))(63 downto 0) when WORD='1' and writing_from_cpu='1' and  block_offset="10" else
												 	word_3 & input_byte & data_store(to_integer(unsigned(set)))(87 downto 0) when BYTE='1' and writing_from_cpu='1' and  block_offset="10" and byte_ofset="11" else
												 	word_3 & byte_2_3 & input_byte & data_store(to_integer(unsigned(set)))(79 downto 0) when BYTE='1' and writing_from_cpu='1' and  block_offset="10" and byte_ofset="10" else
												 	word_3 & byte_2_3 & byte_2_2 & input_byte & data_store(to_integer(unsigned(set)))(71 downto 0) when BYTE='1' and writing_from_cpu='1' and  block_offset="10" and byte_ofset="01" else
												 	word_3 & byte_2_3 & byte_2_2 & byte_2_1 & input_byte & data_store(to_integer(unsigned(set)))(63 downto 0) when BYTE='1' and writing_from_cpu='1' and  block_offset="10" and byte_ofset="00" else

												 data_store(to_integer(unsigned(set)))(127 downto 64) & DATA_IN_FROM_DATAPATH & data_store(to_integer(unsigned(set)))(31 downto 0) when WORD='1' and writing_from_cpu='1' and  block_offset="01" else
												 	word_3 & word_2 & input_byte & data_store(to_integer(unsigned(set)))(55 downto 0) when BYTE='1' and writing_from_cpu='1' and  block_offset="01" and byte_ofset="11" else
												 	word_3 & word_2 & byte_1_3 & input_byte & data_store(to_integer(unsigned(set)))(47 downto 0) when BYTE='1' and writing_from_cpu='1' and  block_offset="01" and byte_ofset="10" else
												 	word_3 & word_2 & byte_1_3 & byte_1_2 & input_byte & data_store(to_integer(unsigned(set)))(39 downto 0) when BYTE='1' and writing_from_cpu='1' and  block_offset="01" and byte_ofset="01" else
												 	word_3 & word_2 & byte_1_3 & byte_1_2 & byte_1_1 & input_byte & data_store(to_integer(unsigned(set)))(31 downto 0) when BYTE='1' and writing_from_cpu='1' and  block_offset="01" and byte_ofset="00" else

												 data_store(to_integer(unsigned(set)))(127 downto 32) & DATA_IN_FROM_DATAPATH  when  WORD='1' and writing_from_cpu='1'  and  block_offset="00" else
												 	word_3 & word_2 & word_1 & input_byte & data_store(to_integer(unsigned(set)))(23 downto 0) when BYTE='1' and writing_from_cpu='1' and  block_offset="00" and byte_ofset="11" else
												 	word_3 & word_2 & word_1 & byte_0_3 & input_byte & data_store(to_integer(unsigned(set)))(15 downto 0) when BYTE='1' and writing_from_cpu='1' and  block_offset="00" and byte_ofset="10" else
												 	word_3 & word_2 & word_1 & byte_0_3 & byte_0_2 & input_byte & data_store(to_integer(unsigned(set)))(7 downto 0) when BYTE='1' and writing_from_cpu='1' and  block_offset="00" and byte_ofset="01" else
												 	word_3 & word_2 & word_1 & byte_0_3 & byte_0_2 & byte_0_1 & input_byte when BYTE='1' and writing_from_cpu='1' and  block_offset="00" and byte_ofset="00" else

												 data_store(to_integer(unsigned(set)));			
			
		--data_store(to_integer(unsigned(set)))(127 downto 96) <= DATA_IN_FROM_DATAPATH when writing_from_cpu='1' and  block_offset="11" else data_store(to_integer(unsigned(set)));
		--data_store(to_integer(unsigned(set)))(95 downto 64) <= DATA_IN_FROM_DATAPATH when writing_from_cpu='1' and block_offset="10" else data_store(to_integer(unsigned(set)));
		--data_store(to_integer(unsigned(set)))(63 downto 32) <= DATA_IN_FROM_DATAPATH when writing_from_cpu='1' and block_offset="01" else data_store(to_integer(unsigned(set))); 
		--data_store(to_integer(unsigned(set)))(31 downto 0) <= DATA_IN_FROM_DATAPATH when writing_from_cpu='1' and block_offset="00" else data_store(to_integer(unsigned(set)));

		valid_store(to_integer(unsigned(set))) <= '1' when writing_from_memory='1';

		tag_store(to_integer(unsigned(set))) <= tag when writing_from_memory='1'; 

		dirty_store(to_integer(unsigned(set))) <='1' when writing_from_cpu='1' and (tag_eq='1' and valid_store(to_integer(unsigned(set)))='1')  else
												  '0' when reading_from_memory='1' else
												  dirty_store(to_integer(unsigned(set)));	


end behav;