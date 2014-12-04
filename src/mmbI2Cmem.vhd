library IEEE;
use IEEE.std_logic_1164.all;
use work.memI2cPkg.all;

-- PIN DESCRIPTION
-- scl: The SCL input is used to positive
--edge clock data into each EEPROM device and negative
--edge clock data out of each device.

-- sda: The SDA pin is bidirectional for
--serial data transfer. This pin is open-drain driven and may
--be wire-ORed with any number of other open-drain or open
--collector devices.

-- Device/Page Addresses (A1, A0: The A1 and A0
--pins are device address inputs that are hardwired or left not
--connected for hardware compatibility with AT24C128/256.
--When the pins are hardwired, as many as four 512K
--devices may be addressed on a single bus system (device
--addressing is discussed in detail under the Device
--Addressing section). When the pins are not hardwired, the
--default A1 and A0 are zero.

-- WP: The write protect input, when tied
--to GND, allows normal write operations. When WP is tied
--high to VCC, all write operations to the memory are inhibited.
--If left unconnected, WP is internally pulled down to
--GND. Switching WP to VCC prior to a write operation creates
--a software write protect function.
entity mmbI2Cmem is
	port
	(
		addr	:	in		std_logic_vector(1 downto 0) := "00"; -- Address Inputs
		sda		:	inout	std_logic; -- Serial Data
		scl		:	in		std_logic; -- Serial Clock Input
		wp 		:	in		std_logic -- Write Protect
	);
end mmbI2Cmem;


architecture behavoral of mmbI2Cmem is
	alias A0 is addr(0);
	alias A1 is addr(1);
	
	signal 	s_start_stop	:	std_logic;
	
	signal s_rw				:	std_logic;
	signal s_AddrDone		:	std_logic;
	
	signal s_readerSt : std_logic := '0';
	signal s_readerDone : std_logic;
	signal s_readerOut : std_logic_vector(7 downto 0);
	
	signal s_writerSt : std_logic := '0';
	signal s_writerIn : std_logic_vector(7 downto 0);
	signal s_writerDone : std_logic;
	
	signal s_compRes : std_logic;
	signal s_mAddr : std_logic_vector(6 downto 0);
	signal s_mData : std_logic_vector(7 downto 0);
	signal s_mWrite : std_logic;
	signal s_AddrCompEn : std_logic;

	
	
begin
	
	Start_Stop: start_stop_logic
		port map(scl        => scl,
			     sda        => sda,
			     start_stop => s_start_stop);
			     
			     
	Device_Addr: device_addr_comparator 
		port map(
			scl  => scl,
			sda  => sda,
			a1   => a1,
			a0   => a0,
			load => s_AddrCompEn,
			comp => s_compRes,
			done => s_AddrDone,
			rw   => s_rw
		);
		
		
		
	Memory: ram 
		port map (
			address	 => s_mAddr,
			clock	 => scl,
			data	 => s_mData,
			wren	 => s_mWrite,
			q	 => s_writerIn
		);
			
	
	SerialReader : serial_reader port map(
		scl   => scl,
		sda   => sda,
		start => s_readerSt,
		done  => s_readerDone,
		dOut  => s_readerOut
	);
	
	SerialWriter : serial_writer
		port map(scl   => scl,
			     sda   => sda,
			     start => s_writerSt,
			     dIn   => s_writerIn,
			     done  => s_writerDone);
			    
			   		   
	
	Control_Unit : serial_control_logic port map(
		scl           => scl,
		sda           => sda,
		rw            => s_rw,
		wp			  => wp,
		stb            => s_start_stop,
		sReaderSt     => s_readerSt,
		sReaderDone   => s_readerDone,
		sReaderOut	  => s_readerOut,
		
		bAddrCompEn   => s_AddrCompEn,
		bAddrCompDone => s_AddrDone,
		bAddrCompRes  => s_compRes,
		
		mAddr         => s_mAddr,
		mData         => s_mData,
		mWrite        => s_mWrite,
		
		sWriterSt     => s_WriterSt,
		sWriterDone   => s_WriterDone
	);

				    
end behavoral;


