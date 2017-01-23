library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
USE ieee.std_logic_unsigned.all;
use std.textio.all;

entity Memory is
    port (ALUOUTM : in std_logic_vector(31 downto 0);
    	  WRITEDATAM: in std_logic_vector(31 downto 0);
          MEMWRITEM : in std_logic;
          MEMTOREGM: in std_logic;
          REGWRITEM: in std_logic;
          WRITEREGM: inout std_logic_vector(4 downto 0);
          reset : in std_logic;
          ReadData : out std_logic_vector(31 downto 0));
end Memory;

    architecture behav of Memory is


    	Component Cache is 
			port(ADDR: in  std_logic_vector(31 downto 0);
		 		RW : in std_logic; --- 0=READ / 1=WRITE
		 		RW_CONTROL: in std_logic; --- 0=Read permision / 1 = write permision
		 		DATA_IN_FROM_MEMORY: in std_logic_vector(127 downto 0);
		 		DATA_IN_FROM_DATAPATH: in std_logic_vector(31 downto 0);
		 		data_out_to_memory: out std_logic_vector(127 downto 0);
		 		data_out_to_path: out std_logic_vector(31 downto 0);
		 		hit: out std_logic); ----0=miss / 1=hit
		end Component;


		    signal ADDR_in :  std_logic_vector(31 downto 0);
            signal RW_in : std_logic := '0';
            signal RAW_CONTROL_in :  std_logic := '1';
            signal MemToCacheBuffer: std_logic_vector(127 downto 0);
            signal CacheToMemBuffer: std_logic_vector(127 downto 0);
            signal PathToCacheBuffer: std_logic_vector(31 downto 0);
            signal cache_out :  std_logic_vector(31 downto 0);
            signal hit_in: std_logic;
            signal mem_pet_done: std_logic;
        
    begin
            --CACHE
            DCache: Cache port map(ADDR => ADDR_in,
                                   RW => RW_in,
                                   RW_CONTROL => RAW_CONTROL_in,
                                   DATA_IN_FROM_MEMORY => MemToCacheBuffer,
                                   DATA_IN_FROM_DATAPATH => PathToCacheBuffer;
                                   data_out_to_memory => CacheToMemBuffer;
                                   data_out_to_path => cache_out,
                                   hit => hit_in);

            Cache_controler: process(clk) begin

            	if reset='0' then
            		if 
            end process;
    end behav;