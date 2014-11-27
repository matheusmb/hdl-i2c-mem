library ieee;
use ieee.std_logic_1164.all;

package memI2cPkg is
	component start_stop_logic
	port(scl        : in  std_logic;
			 sda        : in  std_logic;
			 start_stop : out std_logic := '0');
	end component start_stop_logic;
end package memI2cPkg;

package body memI2cPkg is

end package body memI2cPkg;
