library ieee;
use ieee.std_logic_1164.all;
use std.textio.all;

entity MemoryStage_Test is
end MemoryStage_Test;

architecture behaviour of MemoryStage_Test is
	
	component Memory is
         port (ALUOUTM : in std_logic_vector(31 downto 0);
          WRITEDATAM: in std_logic_vector(31 downto 0);
          MEMWRITEM : in std_logic;
          MEMTOREGM: in std_logic;
          REGWRITEM: in std_logic;
          WRITEREGM: inout std_logic_vector(4 downto 0);
          reset : in std_logic;
          clk: in std_logic;
          hit_m: out std_logic;
          ReadData : out std_logic_vector(31 downto 0));
    end component;

    for Memory_stage: Memory use entity work.Memory;
          signal ALUOUTM_in : std_logic_vector(31 downto 0);
          signal WRITEDATAM_in: std_logic_vector(31 downto 0);
          signal MEMWRITEM_in : std_logic;
          signal MEMTOREGM_in: std_logic;
          signal REGWRITEM_in: std_logic;
          signal WRITEREGM_in:  std_logic_vector(4 downto 0);
          signal reset_in : std_logic;
          signal clk_in: std_logic;
          signal hit_in: std_logic;
          signal ReadData_in :  std_logic_vector(31 downto 0);
	
begin
    Memory_stage: Memory port map(ALUOUTM=>ALUOUTM_in,
                                  WRITEDATAM=>WRITEDATAM_in,
                                  MEMWRITEM=>MEMWRITEM_in,
                                  MEMTOREGM=>MEMTOREGM_in,
                                  REGWRITEM=>REGWRITEM_in,
                                  WRITEREGM=>WRITEREGM_in,
                                  reset=>reset_in,
                                  clk=>clk_in,
                                  hit_m=>hit_in,
                                  ReadData=>ReadData_in);

    clock: process begin
        loop
            clk_in <= '0'; 
            wait for 1 ns;
            clk_in <= '1';
            wait for 1 ns;
        end loop;
    end process;

  test_process: process begin
        
            wait for 2 ns;
            reset_in<='1';
            wait for 2 ns;
            reset_in<='0';
            wait for 2 ns;
            ALUOUTM_in<=X"00000000"; --LW(miss)
            WRITEDATAM_in<=X"FFFFFFFF";
            MEMWRITEM_in<='1';
            MEMTOREGM_in<='0';
            REGWRITEM_in<='1';
            WRITEREGM_in<="00001";
                --CPU_OR_MEM_in<='1'
                wait for 2 ns;
            wait until hit_in='1';

            ALUOUTM_in<=X"00000000"; 
            WRITEDATAM_in<=X"FFFFFFF0";
            MEMWRITEM_in<='1';
            MEMTOREGM_in<='0';
            REGWRITEM_in<='1';
            WRITEREGM_in<="00001";
            wait for 4 ns;

            ALUOUTM_in<=X"00000040"; --LW(miss)
            WRITEDATAM_in<=X"FFFFFFFF";
            MEMWRITEM_in<='0';
            MEMTOREGM_in<='1';
            REGWRITEM_in<='1';
            WRITEREGM_in<="00001";
            wait until hit_in='1';
             wait for 2 ns;

  end process;

--  good_data <= data_out_to_path_in when hit_in='1' else "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU";
end behaviour;