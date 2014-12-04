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
			 done	:	out		std_logic;
			 rw     : out std_logic := 'Z');
	end component device_addr_comparator;
	
	
	component ram
	PORT
	(
		address		: IN STD_LOGIC_VECTOR (6 DOWNTO 0);
		clock		: IN STD_LOGIC  := '1';
		data		: IN STD_LOGIC_VECTOR (7 DOWNTO 0);
		wren		: IN STD_LOGIC ;
		q		: OUT STD_LOGIC_VECTOR (7 DOWNTO 0)
	);
end component;

	component serial_control_logic is
	port (
		scl 	: 	in 		std_logic;
		sda 	: 	in 		std_logic;
		rw		:	in		std_logic;
		wp		:	in		std_logic;
		stb 	:	in		std_logic;
		
		sReaderSt	:	out	std_logic; -- Start Reading 8 bits serial
		sReaderDone	:	in	std_logic; -- Serial Reader warns when its done
		sReaderOut	:	in	std_logic_vector(7 downto 0);
		
		bAddrCompEn : 	out std_logic; -- The comp will check for an matching addr
		bAddrCompDone	:	in	std_logic;
		bAddrCompRes	:	in	std_logic;
		
		mAddr		:	out	std_logic_vector(6 downto 0); -- 128 words
		mData		:	out	std_logic_vector(7 downto 0); -- memroy data
		mWrite		:	out	std_logic;
		
		sWriterSt	:	out	std_logic;
		sWriterDone	:	in std_logic
						
	);
end component serial_control_logic;


component serial_reader
	port(scl   : in  std_logic;
		 sda   : in  std_logic;
		 start : in  std_logic;
		 done  : out std_logic;
		 dOut  : out std_logic_vector(7 downto 0));
end component serial_reader;

component serial_writer
	port(scl   : in  std_logic;
		 sda   : out std_logic;
		 start : in  std_logic;
		 dIn   : in  std_logic_vector(7 downto 0);
		 done  : out std_logic);
end component serial_writer;


component clk_waitert
	port(scl  : in  std_logic;
		 st   : in  std_logic;
		 done : out std_logic);
end component clk_waitert;



	
end package memI2cPkg;

package body memI2cPkg is

end package body memI2cPkg;
