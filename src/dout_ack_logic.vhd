library ieee;

use ieee.std_logic_1164.all;


entity dout_ack_logic is
	port (
		scl	:	in	std_logic;
		start :	in	std_logic;
		rw	:	in	std_logic;
		mem_in	:	out	std_logic_vector(7 downto 0);
		mem_out	:	in	std_logic_vector(7 downto 0);
		din	:	in	std_logic;
		dout:	out	std_logic
	);
end entity dout_ack_logic;


architecture Behavoral of dout_ack_logic is
	signal s_countR, s_countW 	:	integer	range 7 downto -1 := 7;
	signal s_data	:	std_logic_vector(7 downto 0) := (others => '0');	
begin
	
	mem_in <= s_data;
	
	pLogic :
	process(start, scl, rw, start)
	begin
		if(start = '1') then
			if(falling_edge(scl)) then
				if(rw = '0') then
					dOut <= mem_out(s_countR);
					s_countR <= s_countR - 1;
				else
					s_countR <= 7;
				end if;
			else
				if(rw = '1') then
						if(s_countW /= -1) then
							s_data(s_countW) <= din;
							s_countW <=  s_countW-1;
						end if;
				else
					s_countW <= 7;
				end if;			
			end if;			
		end if;
	end process pLogic;
	
end architecture Behavoral;

