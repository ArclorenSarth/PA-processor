library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
USE ieee.std_logic_unsigned.all;
use std.textio.all;

--- NON GENERIC CACHE -- 4 lines of 128 bits each = 512 bits
entity Cache is 
	port(ADDR: in  std_logic_vector(31 downto 0);
		 RW : in std_logic; --- 0=READ / 1=WRITE
		 RW_CONTROL: in std_logic; --- 0=Not Permission / 1 = Permission
		 DATA_IN: in std_logic_vector(127 downto 0);
		 data_out: out std_logic_vector(31 downto 0);
		 hit: out std_logic); ----0=miss / 1=hit

end Cache;

architecture behav of Cache is
	
	type data_store_type is array (3 downto 0) of std_logic_vector(127 downto 0);
	type tag_store_type is array (3 downto 0) of std_logic_vector(26 downto 0);
	type valid_store_type is array (3 downto 0) of std_logic;

	signal tag_eq: std_logic;
	signal tag: std_logic_vector(26 downto 0);
	signal set: std_logic_vector(1 downto 0);
	signal block_offset: std_logic_vector(1 downto 0);
	signal byte_ofset : std_logic_vector(1 downto 0);

	signal data_store: data_store_type;
	signal tag_store: tag_store_type;
	signal valid_store: valid_store_type;

	begin

		tag <= ADDR(31 downto 5);
		set <= ADDR(4 downto 3);
		block_offset <= ADDR(3 downto 2);
		byte_ofset <= ADDR(1 downto 0);
		--ON READ
		tag_eq <= '1' when to_integer(unsigned(tag_store(to_integer(unsigned(set)))))= to_integer(unsigned(tag)) else '0';
		hit <= '1' when (tag_eq='1' and valid_store(to_integer(unsigned(set)))='1') else '0';

		data_out <= data_store(to_integer(unsigned(set)))(127 downto 96) when RW='0' and block_offset=X"11" else
				data_store(to_integer(unsigned(set)))(95 downto 64) when RW='0' and block_offset=X"10" else
				data_store(to_integer(unsigned(set)))(63 downto 32) when RW='0' and block_offset=X"01" else
				data_store(to_integer(unsigned(set)))(31 downto 0);

		--ON WRITE
		data_store(to_integer(unsigned(set))) <= DATA_IN when (RW='1' and RW_CONTROL='1');

		valid_store(to_integer(unsigned(set))) <= '1' when (RW='1' and RW_CONTROL='1');

		tag_store(to_integer(unsigned(set))) <= tag; 


end behav;
