library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
USE ieee.std_logic_unsigned.all;
use std.textio.all;

entity Fetch_Full is
    port (clk : in std_logic;
          muxIF : in std_logic;
          reset : in std_logic;
          PCPlus4F : in std_logic_vector(31 downto 0);
          PCLocation : in std_logic_vector(31 downto 0);
          inst, PC : out std_logic_vector(31 downto 0));
    end Fetch_Full;
    

    architecture behaviour of Fetch_Full is
    --PC Signals
        signal PC_in: std_logic_vector(31 downto 0);
        signal PCF: std_logic_vector(31 downto 0);

    --MEM Signals
        signal inst_data: std_logic_vector(127 downto 0);
        signal inst_nwe: std_logic;
        signal inst_noe: std_logic;
        signal inst_ncs: std_logic;

    --CACHE Signals
        signal Addr_on_miss: std_logic_vector(31 downto 0);



        Component Reg is
            Generic(W : integer);
            Port (d   : in std_logic_vector(W-1 downto 0);
            clk : in std_logic;
            q   : out std_logic_vector(W-1 downto 0));
        End Component;

        component Cache
            port(ADDR: in  std_logic_vector(31 downto 0);
             RW : in std_logic; --- 0=READ / 1=WRITE
             RW_CONTROL: in std_logic; --- 0=Not Permission / 1 = Permission
             DATA_IN: in std_logic_vector(127 downto 0);
             data_out: out std_logic_vector(31 downto 0);
             hit: out std_logic); ----0=miss / 1=hit
        end component;

        for ICache: Cache use entity work.Cache;
            signal ADDR_in :  std_logic_vector(31 downto 0);
            signal RW_in : std_logic;
            signal RAW_CONTROL_in :  std_logic;
            signal MemToCacheBuffer: std_logic_vector(127 downto 0);
            signal cache_out :  std_logic_vector(31 downto 0);
            signal hit_in: std_logic;
        
    begin
            --CACHE
            ICache: Cache port map(ADDR => ADDR_in,
                                   RW => RW_in,
                                   RW_CONTROL => RAW_CONTROL_in,
                                   DATA_IN => MemToCacheBuffer,
                                   data_out => cache_out,
                                   hit => hit_in);
            ADDR_in <= PC_in;

            cache_miss: process(clk) 
                        variable miss_penalty: integer := 5;
                    begin
                        if hit_in='0' then
                           Addr_on_miss <= ADDR_in(31 downto 4) & X"0";
                           MemToCacheBuffer<=inst_data;
                               --while miss_penalty > 0 loop
                                    --if rising_edge(clk) then
                                       --miss_penalty := miss_penalty -1;
                                    --end if;
                               --end loop;
                            RW_in <= '1';
                            RAW_CONTROL_in<='1';
                        else 
                            Addr_on_miss<=X"00020000"; --silly @ (I don't care about the output of the memory when I have a hit on Cache)
                            RW_in<='0';
                            RAW_CONTROL_in<='0';
                        end if;
            end process;



            -- PC

                PCregister : Reg generic map(32) port map(PC_in,clk,PCF);

                PC <= PCF+X"00000004" when hit_in<='1' else
                      PCF;

                PC_in <= PCPlus4F when (muxIF='1' and reset='0') else 
                         X"00001000" when (reset='1') else
                        PCLocation;

                --inst <= inst_data;
    
            -- Instruction Memory
                inst_memory: entity work.sram64kx8(sram_behaviour)
                    port map (inst_ncs, Addr_on_miss, inst_data, inst_nwe, inst_noe);
                
                    -- never write to instruction memory
                    inst_nwe <= '1';
                    inst_noe <= '0';
                    inst_ncs <= '1' when PCF(0)='U' else '0';
                    
                    inst<=cache_out when hit_in='1'else
                          "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
end behaviour;