library ieee;
use ieee.std_logic_1164.all;


entity start_stop_logic is
	port (
		scl 		: 	in 		std_logic;
		sda 		: 	in 		std_logic;
		start_stop 	: 	out 	std_logic := '0'		
	);
end entity start_stop_logic;

architecture RTL of start_stop_logic is
	signal sig_st_stp	:	std_logic := '0';
begin
	
	start_stop 	<= 	sig_st_stp;
	
	
	st_stp_logic :
	process(sda)
	begin
	
		if(scl = '1') then
			if(sda = '0') then
				sig_st_stp <= '1';
			
			else
				sig_st_stp <= '0';
			end if;
			
		end if;

		
	end process st_stp_logic;

end architecture RTL;
