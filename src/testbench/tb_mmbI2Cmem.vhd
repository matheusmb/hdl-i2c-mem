library ieee;
use ieee.std_logic_1164.all;

entity tb_mmbI2Cmem is
end tb_mmbI2Cmem;

architecture tb of tb_mmbI2Cmem is

    component mmbI2Cmem is
	port ( addr	:	in		std_logic_vector(1 downto 0) := "00"; -- Address Inputs
		sda		:	inout	std_logic; -- Serial Data
		scl		:	in		std_logic; -- Serial Clock Input
		wp 		:	in		std_logic -- Write Protect
	);
	end component mmbI2Cmem;

    signal scl        : std_logic := '0';
    signal sda        : std_logic;

    constant TbPeriod : time := 50 ns; -- EDIT put right period here
    
    
    
    type t_test_vector is array(natural range <>) of std_logic_vector(7 downto 0);
    
    
    constant test_vector : t_test_vector := ("10100001", "00000010", "10101001", "10100000", "00000010" );


begin

    dut : mmbI2Cmem
    port map (scl        => scl,
              sda        => sda,
              wp  => '0',
              addr => "00");
    
    stimuli : process
    begin
    	
    	-- Start 
    	sda <= '1';
    	scl <= '1';
    	
    	wait for TbPeriod;
    	
    	sda <= '0';
    	
    	wait for TbPeriod;
		scl <= '0';
		

    	
		-- Write op
    	for i in 0 to test_vector'HIGH-2 loop
    		for j in 7 downto 0 loop
    			sda <= test_vector(i)(j);
				wait for TbPeriod;
    			scl <= '1';
    			wait for TbPeriod;
    			scl <= '0';  
    		end loop;
			
			-- Ack Clk
			sda <= 'Z';
			wait for TbPeriod;
			scl <= '1';
			wait for TbPeriod;
			scl <= '0';
				
    	end loop;
		
		-- Read Op
   	-- Start 
    	-- Start 
		wait for TbPeriod;
    	sda <= '1';
    	scl <= '1';
    	
    	wait for TbPeriod;
    	
    	sda <= '0';
    	
    	wait for TbPeriod;
		scl <= '0';
		
		for i in test_vector'HIGH-1 to test_vector'HIGH loop
			for j in 7 downto 0 loop
				sda <= test_vector(i)(j);
				wait for TbPeriod;
				scl <= '1';
				wait for TbPeriod;
				scl <= '0'; 
			end loop;
			
			-- Ack Clk
			sda <= 'Z';
			wait for TbPeriod;
			scl <= '1';
			wait for TbPeriod;
			scl <= '0';			
		end loop;
		
		wait for TbPeriod;
		sda <= 'Z'; -- Put to Z so mem can write on it
		
		loop
			scl <= '1';
			wait for TbPeriod;
			scl <= '0';
			wait for TbPeriod;
		end loop;
    	
    	
    	
 		report "TestBench Finished!" severity note;
 		
        wait;
    end process;

end tb;
