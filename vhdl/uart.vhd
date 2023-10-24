library ieee;
use ieee.std_logic_1164.all;

entity uart is

generic (dbit: integer:=8; n: integer:= 39);
port (tx: out std_logic;
		rx: in std_logic;
		clk, rst: in std_logic);

end uart;

architecture behav of uart is

component clock is
generic (n: integer:= 39);
port (clk: in std_logic;
		rst: in std_logic;
		tick: out std_logic);
end component;


component receiver is
generic(dbit: integer:= 8);
port (clk : in std_logic;
		rst : in std_logic;
		tick : in std_logic;
		rx : in std_logic;
		d : out std_logic_vector(dbit-1 downto 0);
		rx_done_tick : out std_logic);
		
end component;

component fifo is
generic (dbit : integer:= 8);
port (wr : in std_logic;
		d : in std_logic_vector(dbit-1 downto 0);
		r_d : out std_logic_vector(dbit-1 downto 0);
		flag : out std_logic;
		rd, clk , rst : in std_logic);

end component;


component transmitter is
generic(dbit : integer := 8);

port ( din : in std_logic_vector(dbit-1 downto 0);
		 tx_start : in std_logic;
		 tx_done_tick : out std_logic;
		 tick : in std_logic;
		 tx : out std_logic;
		 clk, rst : in std_logic);

end component;


signal tick: std_logic;
signal rx_done_tick: std_logic;
signal dout: std_logic_vector(dbit-1 downto 0);
signal r_d_fifo: std_logic_vector(dbit-1 downto 0);
signal flag_fifo: std_logic;
signal tx_done_tick_fifo: std_logic;

begin

u1 : receiver generic map( dbit => 8) port map( clk => clk , rst => rst , tick => tick,
																rx => rx, d => dout, rx_done_tick => rx_done_tick);
u2: fifo generic map(dbit => 8) port map(wr => rx_done_tick, d => dout, r_d => r_d_fifo, flag => flag_fifo,
													  rd => tx_done_tick_fifo, clk => clk, rst => rst);
													  
u3: transmitter generic map( dbit => 8) port map( din => r_d_fifo, tx_start =>flag_fifo , 
																  tx_done_tick => tx_done_tick_fifo,tick => tick, 
																  tx => tx, clk => clk, rst => rst);
																	
u4: clock generic map(n => 39) port map(clk => clk, rst => rst , tick => tick);


end behav;