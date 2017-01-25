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
          ctrlALUopEX : in std_logic_vector(6 downto 0);
          ctrlByteEX : in std_logic;
          REGWRITEM: in std_logic;
          WRITEREGM: in std_logic_vector(4 downto 0);
          reset : in std_logic;
          clk: in std_logic;
          ctrlRegWriteM : out std_logic;
          ctrlMemtoRegM : out std_logic;
          ctrlALUopM : out std_logic_vector(6 downto 0);
          ALUoutMFW : out std_logic_vector(31 downto 0);
          WRITEREGMFW : out std_logic_vector(4 downto 0);
          hit_m: out std_logic;
          ReadData : out std_logic_vector(31 downto 0));
end Memory;

    architecture behav of Memory is


    	Component DataCache is 
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
		 		dirty:out std_logic;
		 		hit: out std_logic); ----0=miss / 1=hit
		end Component;


		    	signal ADDR_in: std_logic_vector(31 downto 0);
		 		signal RW_Cache_in: std_logic; --- 0=READ / 1=WRITE
		 		signal RW_CONTROL_Cache_in: std_logic; --- 0=Read permision / 1 = write permision
		 		signal RW_MEM_in: std_logic:='0';
		 		signal RW_CONTROL_MEM_in: std_logic;
		 		signal BYTE_in: std_logic;
		 		signal WORD_in: std_logic;
		 		signal CPU_OR_MEM_in: std_logic; --- 0=MEMORY / 1=CPU
		 		signal MemToCacheBuffer: std_logic_vector(127 downto 0);
		 		signal PathToCacheBuffer: std_logic_vector(31 downto 0);
		 		signal CacheToMemBuffer: std_logic_vector(127 downto 0);
		 		signal cache_out: std_logic_vector(31 downto 0);
		 		signal dirty_in:std_logic;
		 		signal hit_in: std_logic; ----0=miss / 1=hit
		 		signal Addr_on_miss: std_logic_vector(31 downto 0);
		 		signal inst_data: std_logic_vector(127 downto 0);
		 		signal inst_noe:std_logic;
		 		signal inst_ncs:std_logic;
		 		signal inst_nwe:std_logic;
		 		signal mem_pet_done:std_logic;
		 		signal eviction: std_logic;
        
    begin
         
           ctrlALUopM <= ctrlALUopEX;
           ALUoutMFW <= ALUOUTM;
           WRITEREGMFW <= WRITEREGM; 
           ctrlRegWriteM <= REGWRITEM;
           ctrlMemtoRegM <= MEMTOREGM;


            --CACHE
            RW_Cache_in<='0' when MEMTOREGM='1' else
            			 '1' when MEMWRITEM ='1' else
            			 'U';

            RW_CONTROL_Cache_in <= '0' when RW_CONTROL_MEM_in='1' else '1';




            DCache: DataCache port map(ADDR => ADDR_in,
                                   RW_Cache => RW_Cache_in,
                                   RW_CONTROL_Cache => RW_CONTROL_Cache_in,
                                   RW_MEM => RW_MEM_in,
                                   RW_CONTROL_MEM => RW_CONTROL_MEM_in,
                                   BYTE=>'0',
                                   WORD=>'1',
                                   DATA_IN_FROM_MEMORY => MemToCacheBuffer,
                                   DATA_IN_FROM_DATAPATH => PathToCacheBuffer,
                                   data_out_to_memory => CacheToMemBuffer,
                                   data_out_to_path => cache_out,
                                   dirty=>dirty_in,
                                   adress_to_memory=>Addr_on_miss,
                                   hit => hit_in);

            hit_m<=hit_in;

            ADDR_in<=ALUOUTM;
            ReadData<=cache_out;


            PathToCacheBuffer<=WRITEDATAM;

            inst_data<=CacheToMemBuffer when inst_nwe='0' else "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
            MemToCacheBuffer<=inst_data when inst_noe='0' else inst_data;

            Cache_controler: process(clk) begin

            	if reset='0' and rising_edge(clk) then
            		if RW_CONTROL_Cache_in ='1' then
            			if RW_Cache_in='0' then
            				if hit_in='0' then 
            					if dirty_in='1' then --read miss with eviction
            						--RW_CONTROL_Cache_in<='0'; --deactive cache
	            					RW_CONTROL_MEM_in<='1';-- activate memory
	            					inst_nwe<='0'; --Write to memory demand
	            					inst_noe<='0';
	            					RW_MEM_in<='1';
            					elsif dirty_in='0' then --read miss no eviction
	            					--RW_CONTROL_Cache_in<='0'; --deactive cache
	            					RW_CONTROL_MEM_in<='1';-- activate memory
	            					inst_nwe<='1';--read from memory demand
	            					inst_noe<='0';
	            					RW_MEM_in<='1';
            					end if;
            				elsif hit_in='1' then -- read hit;
            					inst_nwe<='1'; --avoid transactions with the memory
	            				inst_noe<='1';
            				end if;
            			elsif RW_Cache_in='1' then
            				if hit_in='0' then
            					if dirty_in='1' then -- write miss with eviction
            						--RW_CONTROL_Cache_in<='0'; --deactive cache
	            					RW_CONTROL_MEM_in<='1';-- activate memory
	            					inst_nwe<='0'; --Write to memory demand
	            					inst_noe<='0';
	            					RW_MEM_in<='1';
	            				elsif dirty_in='0' then --write miss no eviction
	            					--RW_CONTROL_Cache_in<='0'; --deactive cache
	            					RW_CONTROL_MEM_in<='1';-- activate memory
	            					inst_nwe<='1'; --Write to memory demand
	            					inst_noe<='0';
	            					RW_MEM_in<='1';
	            				end if;
	            			elsif hit_in='1' then --write hit
	            				inst_nwe<='1'; --avoid transactions with the memory
	            				inst_noe<='1';
	            			end if;
	            		end if;
	            	elsif RW_CONTROL_Cache_in='0' then
	            		if RW_CONTROL_MEM_in='1' then --waiting memory response
	            			--RW_CONTROL_Cache_in<=mem_pet_done;
	            			RW_CONTROL_MEM_in<=not mem_pet_done;

	            		elsif RW_CONTROL_MEM_in='0' then 
	            			--I DONT CARE ABOUT IT, NOT LD OR ST on the mem phase of the pipeline
	            		end if;
            		end if;
            	elsif reset='1' and rising_edge(clk) then
            		RW_CONTROL_MEM_in<='0';
            	end if;
           	end process;

            inst_memory: entity work.sram64kx8(sram_behaviour)
                    port map (inst_ncs, Addr_on_miss, inst_data, inst_nwe, inst_noe, mem_pet_done);
                
                    -- never write to instruction memory
                    --inst_nwe <= '1';
                    --inst_noe <= hit_in;
                    inst_ncs <= '1' when reset='1' else '0';
    end behav;
