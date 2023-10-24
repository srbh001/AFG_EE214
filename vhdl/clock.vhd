library ieee;
use ieee.std_logic_1164.all;

entity clock is
generic (n: integer:= 39);
port (clk: in std_logic;
		rst: in std_logic;
		tick: out std_logic);
end clock;

architecture behav of clock is
signal s: integer;
begin
process(clk , rst)
begin
		if( rst = '1') then
			tick <= '0';
			s <= 0;
		elsif(clk'event and clk = '1') then
			if( s= n) then
				s <= 0;
				tick <= '1';
			else
				s <= s + 1;
				tick <= '0';
			end if;
		end if;
end process;
end behav;
