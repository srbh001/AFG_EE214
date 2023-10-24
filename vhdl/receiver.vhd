library ieee;
use ieee.std_logic_1164.all;

entity receiver is
generic(dbit: integer:= 8);
port (clk : in std_logic;
		rst : in std_logic;
		tick : in std_logic;
		rx : in std_logic;
		d : out std_logic_vector(dbit-1 downto 0);
		rx_done_tick : out std_logic);
		
end receiver;


architecture behav of receiver is
type state is (idle ,start , data , stop);
signal pre_state : state;
signal s,n : integer;
signal b: std_logic_vector(dbit-1 downto 0);

begin

process(clk , rst)
begin
	if( rst = '1') then
		pre_state <= idle;
		b <= (others => '0');
		s <= 0;
		n <= 0;
	elsif(clk'event and clk = '1') then
		case pre_state is
			when idle => if(rx = '0') then
								pre_state <= start;
								s <= 0;
								n <= 0;
								b <= ( others => '0');
								rx_done_tick <= '0';
							else 
								pre_state <= idle;
								s <= 0;
								n <= 0;
								b <= (others => '0');
								rx_done_tick <= '0';
							end if;
			when start => if(tick = '1') then
									if( s = 7) then
										s <= 0;
										n <= 0;
										pre_state <= data;
									else
										s <= s + 1;
										pre_state <= start;
									end if;
								end if;
			when data => if(tick = '1') then
								if(s = 15) then
									s <= 0;
									b <= rx & b(dbit-1 downto 1);
										if( n = dbit-1) then
											pre_state <= stop;
											s <= 0;
										else
											n <= n + 1;
										end if;
								else
									s <= s+ 1;
									pre_state <= data;
								end if;
							end if;
			when stop => if( tick = '1') then
								if( s = 15) then
									d <= b;
									rx_done_tick <= '1';
									pre_state <= idle;
								else
									s <= s+1;
									pre_state <= stop;
								end if;
							end if;
			when others => null;
		end case;
	end if;
	
end process;
end behav;