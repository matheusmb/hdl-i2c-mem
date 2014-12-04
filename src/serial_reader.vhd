library ieee;

use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity serial_reader is
	port (
		scl : in std_logic;
		sda : in std_logic;
		start : in std_logic;
		done  : out std_logic;
		dOut  : out std_logic_vector(7 downto 0)
	);
end entity serial_reader;



architecture RTL of serial_reader is
	signal s_count : integer range 7 downto -1 := 7;
	signal s_done  : std_logic := '0';
	signal s_data : std_logic_vector(7 downto 0);
begin
	
	dOut <= s_data;
	done <= s_done;
	
	process(start, scl)
	begin
		if(start = '1') then
			if(rising_edge(scl)) then
				s_data(s_count) <= sda;				
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

