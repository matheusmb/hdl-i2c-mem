library ieee;

use ieee.std_logic_1164.all;


entity clk_waitert is
	port (
		scl : in std_logic;
		st	:	in std_logic;
		done : out std_logic
	);
end entity clk_waitert;


architecture RTL of clk_waitert is
	
begin
	
	waiter:
	process(st, scl)
	begin
		if(st = '1') then
			if(rising_edge(scl)) then
				done <= '1';
			end if;
		else
			done <= '0';
		end if;
	end process;
		
end architecture RTL;

