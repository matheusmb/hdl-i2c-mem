library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity serial_writer is
	port (
		scl : in std_logic;
		sda : out std_logic;
		start : in std_logic;
		dIn  : in std_logic_vector(7 downto 0);
		done  : out std_logic		
	);
end entity serial_writer;



architecture RTL of serial_writer is
	signal s_count : integer range 7 downto -1 := 7;
	signal s_done  : std_logic := '0';
	signal s_in    : std_logic := 'Z';
begin
	
	sda <= s_in;
	done <= s_done;
	
	process(start, scl)
	begin
		if(start = '1') then
			if(falling_edge(scl)) then
				s_in <= dIn(s_count);				
				s_count <= s_count - 1;
				
				if(s_count = 0) then
					s_done <= '1';					
				end if;
			end if;
		else 
			s_done <= '0';
			s_count <= 7;
		end if;
	end process;	
	

		
	
end architecture RTL;

