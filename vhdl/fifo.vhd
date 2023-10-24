library ieee;
use ieee.std_logic_1164.all;

entity fifo is
generic (dbit : integer:= 8);
port (wr : in std_logic;
		d : in std_logic_vector(dbit-1 downto 0);
		r_d : out std_logic_vector(dbit-1 downto 0);
		flag : out std_logic;
		rd, clk , rst : in std_logic);

end fifo;

architecture behav of fifo is
begin
process(clk, rst)
begin
	if( rst = '1') then
		flag <= '0';
		r_d <= (others => '0');
	elsif( clk'event and clk = '1') then
		flag <= '0';
		if(wr = '1') then
			r_d <= d;
			flag <= '1';
		elsif (rd = '1') then
			flag <= '0';
		end if;
	end if;
end process;
end behav;