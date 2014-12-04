library ieee;
use ieee.std_logic_1164.all;

entity tb_start_stop_logic is
end tb_start_stop_logic;

architecture tb of tb_start_stop_logic is

    component mmbI2Cmem is
	port
	(
		addr	:	in		std_logic_vector(1 downto 0) := "00"; -- Address Inputs
		sda		:	inout	std_logic; -- Serial Data
		scl		:	in		std_logic; -- Serial Clock Input
		wp 		:	in		std_logic -- Write Protect
	);
end mmbI2Cmem;

    signal scl        : std_logic := '0';
    signal sda        : std_logic;
    signal start_stop : std_logic;

    constant TbPeriod : time := 1000 ns; -- EDIT put right period here

begin

    dut : start_stop_logic
    port map (scl        => scl,
              sda        => sda,
              start_stop => start_stop);
    
    stimuli : process
    begin
    	sda <= '1';
    	scl <= '1';
    	
    	wait for TbPeriod;
    	
    	sda <= '0';
    	
    	wait for TbPeriod;
    	
    	assert start_stop = '1' 
    		report "Start Condition Failed!" severity error;
    		
    	scl <= '1';
    	sda <= '1';
    	
    	wait for  TbPeriod;
    	
    	assert start_stop = '0' 
    		report "Stop Condition Failed!" severity error;
    	
 		report "TestBench Finished!" severity note;
 		
        wait;
    end process;

end tb;

configuration cfg_tb_start_stop_logic of tb_start_stop_logic is
    for tb
    end for;
end cfg_tb_start_stop_logic;