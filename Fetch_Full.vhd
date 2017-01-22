library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
USE ieee.std_logic_unsigned.all;
use std.textio.all;

entity Fetch_Full is
    port (clk : in std_logic;
          muxIF : in std_logic;
          reset : in std_logic;
          FWWE : in std_logic;
          PCLocation : in std_logic_vector(31 downto 0);
          inst, PC : out std_logic_vector(31 downto 0));
    end Fetch_Full;
    

    architecture behaviour of Fetch_Full is
    --PC Signals
        signal PC_local: std_logic_vector(31 downto 0);
        signal PCF: std_logic_vector(31 downto 0);
        signal PCPlus4F: std_logic_vector(31 downto 0);

    --MEM Signals
        signal inst_data: std_logic_vector(127 downto 0);
        signal inst_nwe: std_logic;
        signal inst_noe: std_logic;
        signal inst_ncs: std_logic;
        --signal pet: std_logic;

    --CACHE Signals
        signal Addr_on_miss: std_logic_vector(31 downto 0);
        signal fwwe_in : std_logic;



        Component Reg is
            Generic(W : integer);
            Port (d   : in std_logic_vector(W-1 downto 0);
            clk : in std_logic;
            re  : in std_logic;
            reset: in std_logic;
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
            signal RW_in : std_logic := '0';
            signal RAW_CONTROL_in :  std_logic := '1';
            signal MemToCacheBuffer: std_logic_vector(127 downto 0);
            signal cache_out :  std_logic_vector(31 downto 0);
            signal hit_in: std_logic;
            signal mem_pet_done: std_logic;
        
    begin
            --CACHE
            ICache: Cache port map(ADDR => ADDR_in,
                                   RW => RW_in,
                                   RW_CONTROL => RAW_CONTROL_in,
                                   DATA_IN => MemToCacheBuffer,
                                   data_out => cache_out,
                                   hit => hit_in);
            ADDR_in <= PCF;
            fwwe_in<=hit_in;

            cache_miss: process(clk) 
                    begin
                        if reset='0' and rising_edge(clk) then
                            if hit_in='0' and RW_in='0' and RAW_CONTROL_in='1' then --Fail detection (Load @ and wait for MEM)
                               Addr_on_miss <= ADDR_in(31 downto 4) & X"0";
                               RW_in <= '1';
                               RAW_CONTROL_in<='0';
                               inst_noe<='1';
                            elsif hit_in='0' and RW_in='1' and RAW_CONTROL_in='0' then
                                MemToCacheBuffer <= inst_data;
                                RW_in <= '1';
                                RAW_CONTROL_in<=mem_pet_done;
                                inst_noe<='0';
                            elsif hit_in='1' and RW_in='1' and RAW_CONTROL_in='1' then
                                RW_in<='0';
                                RAW_CONTROL_in<=RAW_CONTROL_in;
                            else 
                                Addr_on_miss<=Addr_on_miss; --(I don't care about the output of the memory when I have a hit on Cache)
                                RW_in<=RW_in;
                                RAW_CONTROL_in<=RAW_CONTROL_in;
                            end if;
                        end if;

            end process;



            -- PC

                PCregister : Reg generic map(32) port map(PCPlus4F,clk,fwwe_in,reset,PCF);

                PC<=PCPlus4F when (muxIF='1' and reset='0') else PCLocation;

                PCPlus4F <= PCF+X"00000004";

                --inst <= inst_data;
    
            -- Instruction Memory
                inst_memory: entity work.sram64kx8(sram_behaviour)
                    port map (inst_ncs, Addr_on_miss, inst_data, inst_nwe, inst_noe, mem_pet_done);
                
                    -- never write to instruction memory
                    inst_nwe <= '1';
                    --inst_noe <= hit_in;
                    inst_ncs <= '1' when PCF(0)='U' else '0';
                    
                    inst<=cache_out when hit_in='1'else
                          "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ";
end behaviour;