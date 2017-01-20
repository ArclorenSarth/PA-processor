library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;
USE ieee.std_logic_unsigned.all;
use std.textio.all;

entity Fetch is
    port (clk : in std_logic;
          muxIF : in std_logic;
          boot : in std_logic;
          PCPlus4F : in std_logic_vector(31 downto 0);
          PCLocation : in std_logic_vector(31 downto 0);
          inst, PC : out std_logic_vector(31 downto 0));
    end Fetch;
    

    architecture behaviour of Fetch is
        signal PC_in: std_logic_vector(31 downto 0);
        signal PCF: std_logic_vector(31 downto 0);

        signal inst_data: std_logic_vector(31 downto 0);
        signal inst_nwe: std_logic;
        signal inst_noe: std_logic;
        signal inst_ncs: std_logic;

        Component Reg is
            Generic(W : integer);
            Port (d   : in std_logic_vector(W-1 downto 0);
            clk : in std_logic;
            q   : out std_logic_vector(W-1 downto 0));
        End Component;

        --for PCregister : Reg use entity work.Reg;
        
    begin
            -- PC

                PCregister : Reg generic map(32) port map(PC_in,clk,PCF);

                PC <= PCF+X"00000004";

                PC_in <= PCPlus4F when (muxIF='1' and boot='0') else 
                         X"00001000" when (boot='1') else
                        PCLocation;

                --inst <= inst_data;
    
            -- Instruction Memory
                inst_memory: entity work.sram64kx8(sram_behaviour)
                    port map (inst_ncs, PCF, inst_data, inst_nwe, inst_noe);
                
                    -- never write to instruction memory
                    inst_nwe <= '1';
                    inst_noe <= '0';
                    inst_ncs <= '1' when PCF(0)='U' else '0';
                    
                    inst<=inst_data;
end behaviour;