library ieee;
use ieee.std_logic_1164.all;

entity transmitter is
generic(dbit : integer := 8);

port ( din : in std_logic_vector(dbit-1 downto 0);
		 tx_start : in std_logic;
		 tx_done_tick : out std_logic;
		 tick : in std_logic;
		 tx : out std_logic;
		 clk, rst : in std_logic);

end transmitter;

architecture behav of transmitter is
type state is(idle , start , data , stop);
signal pre_state: state;
signal s, n : integer;
signal b: std_logic_vector(dbit-1 downto 0);
begin
process(clk , rst)
	begin
		if( rst = '1') then
			s <= 0;
			n <= 0;
			b <= (others => '0');
			pre_state <= idle;
			tx <= '1';
			tx_done_tick <= '0';
		elsif( clk'event and clk = '1') then
			case pre_state is
				when idle => if( tx_start = '1') then
					pre_state <= start;
					s <= 0;
					n <= 0;
					b <= din;
					tx <= '0';
					tx_done_tick <= '0';
					else
					pre_state <= idle;
					s <= 0;
					n <= 0;
					tx <= '1';
					tx_done_tick <= '0';
					b <= (others => '0');
					end if;
				when start => 
					tx <= '0';
					if(tick = '1') then
						if( s = 15) then
							pre_state <= data;
							s <= 0;
						else
							s <= s+1;
							pre_state <= start;
						end if;
					end if;
				when data => 
					tx <= b(0);
						if( tick = '1') then
							if( s = 15) then
								s <= 0;
								b <= '0' & b(dbit-1 downto 1);
								if( n = dbit -1 ) then
									pre_state <= stop;
									n <= 0;
								else
									n <= n + 1;
								end if;
							else
								s <= s+ 1;
							end if;
						end if;
				when stop => 
					tx <= '1';
					if(tick = '1') then
						if(s = 15) then
							pre_state <= idle;
							tx_done_tick <= '1';
							s <= 0;
						else
							s <= s+ 1;
						end if;
					end if;
			end case;
		end if;
end process;
end behav;
