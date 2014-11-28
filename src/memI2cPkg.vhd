library ieee;
use ieee.std_logic_1164.all;

package memI2cPkg is
	component start_stop_logic
	port(scl        : in  std_logic;
			 sda        : in  std_logic;
			 start_stop : out std_logic := '0');
	end component start_stop_logic;
	
	
	component device_addr_comparator
		port(scl    : in  std_logic;
			 sda    : in  std_logic;
			 a1, a0 : in  std_logic;
			 load   : in  std_logic;
			 comp   : out std_logic;
			 rw     : out std_logic := 'Z');
	end component device_addr_comparator;
end package memI2cPkg;

package body memI2cPkg is

end package body memI2cPkg;
