library ieee;
use ieee.std_logic_1164.all;

-- Generic Register

Entity Reg is
    Generic(W : integer);
    Port (d   : in std_logic_vector(W-1 downto 0);
          clk : in std_logic;
          re  : in std_logic;
          reset: in std_logic; 
          q   : out std_logic_vector(W-1 downto 0));
End;

Architecture behave of Reg is
    begin
        process(clk)
        begin
        if rising_edge(clk) then 
            if reset='1' then
                q<=X"00001000";
            elsif re='1' then
                q<=d;
            end if;
        end if;
        end process;
end;