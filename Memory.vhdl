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
		 		DATA_IN: in std_logic_vector(127 downto 0);
		 		data_out: out std_logic_vector(31 downto 0);
		 		hit: out std_logic); ----0=miss / 1=hit
		end Component;
    end behav;