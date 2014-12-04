library ieee;
use ieee.std_logic_1164.all;

use work.memi2cpkg.all;

entity device_addr_comparator is
	port (
		scl 	: 	in 		std_logic;
		sda 	: 	in 		std_logic;
		a1, a0 	:	in		std_logic;
		load	:	in		std_logic;
		comp	:	out		std_logic;
		done	:	out		std_logic;
		rw		:	out		std_logic := 'Z'
	);
end entity device_addr_comparator;


architecture Behavoral of device_addr_comparator is
	signal s_addr	:	std_logic_vector(7 downto 0);
	signal s_count	:	integer range 7 downto -1 := 7;
	signal s_read_inp : std_logic := '0';
begin
	
	
	comp_logic:
	process(scl, load)
	begin	
		if(load = '1') then
			if(s_count = -1) then -- Addr is complete				
				done <= '1';
			else -- Addr isnt complete
				if(rising_edge(scl)) then
					s_addr(s_count) <= sda;
					s_count <= s_count - 1;
				end if;
			end if;
		else -- Load is 0
			done <= '0';
			s_count <= 7;
			s_addr <= (others => '0');
		end if;
							
	end process comp_logic;
	
	
	comparator :
	process(s_count)
	begin
		if(s_count = -1) then
			if(s_addr(7 downto 1) = ("10100" & a1 & a0) ) then
				comp <= '1';
				rw <= s_addr(0);			
			end if;	
		else
			comp <= '0';
		end if;	
	end process;
		
	
end architecture Behavoral;
