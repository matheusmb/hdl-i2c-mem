library ieee;
use ieee.std_logic_1164.all;

entity tb_device_addr_comparator is
end tb_device_addr_comparator;

architecture tb of tb_device_addr_comparator is

    component device_addr_comparator
        port (scl  : in std_logic;
              sda  : in std_logic;
              a0   : in std_logic;
              a1   : in	std_logic;
              load : in std_logic;
              comp : out std_logic;
              rw   : out std_logic);
    end component;

    signal scl  : std_logic := '1';
    signal sda  : std_logic;
    signal a0   : std_logic;
    signal a1	: std_logic;
    signal load : std_logic;
    signal comp : std_logic;
    signal rw   : std_logic;
    

    constant TbPeriod : time := 1000 ns; -- EDIT put right period here
    
    type r_test_record is record
    	addr 	: 	std_logic_vector(7 downto 0);
    	a1, a0 	: 	std_logic;
    	load 	: 	std_logic;
    	
    	res_comp : 	std_logic;
    	res_rw	 :	std_logic;
    	
    end record r_test_record;
    
    type t_test_vector is array(natural range <>) of r_test_record;
    
    
    constant test_vector : t_test_vector := (
	    (
	    	addr 	=> 	"11000101",
	    	a1		=> 	'1',
	    	a0 		=> 	'0',
	    	load 	=>	'1',
	    	
	    	res_comp => '0',   
	    	res_rw	 => 'Z' 	
	    ),
	    (
	    	addr 	=> 	"10100100",
	    	a1		=> 	'1',
	    	a0 		=> 	'0',
	    	load 	=>	'0',
	    	
	    	res_comp => '0',   
	    	res_rw	 => 'Z' 	
	    ),
	    (
	    	addr 	=> 	"10100100",
	    	a1		=> 	'1',
	    	a0 		=> 	'0',
	    	load 	=>	'1',
	    	
	    	res_comp => '1',   
	    	res_rw	 => '0' 	
	    ),   
	    (
	    	addr 	=> 	"10100101",
	    	a1		=> 	'1',
	    	a0 		=> 	'0',
	    	load 	=>	'1',
	    	
	    	res_comp => '1',   
	    	res_rw	 => '1' 	
	    )
	   
	);
   

begin

    dut : device_addr_comparator
    port map (scl  => scl,
              sda  => sda,
              a0   => a0,
              a1   => a1,
              load => load,
              comp => comp,
              rw   => rw);



    stimuli : process

    begin
    	for i in test_vector'range loop
			report "Executing Test Vector" & INTEGER'image(i);
    		load <= test_vector(i).load;
    		a1 <= test_vector(i).a1;
    		a0 <= test_vector(i).a0;
    		
    		for j in r_test_record.addr'HIGH downto 0 loop
    			scl <= not scl;
    			wait for TbPeriod;
    			
    			sda <= test_vector(i).addr(j);
    			
    			scl <= not scl;
    			
    			wait for TbPeriod;    			    			
    		end loop;
			
			scl <= not scl;
			
			wait for TbPeriod;
			
			scl <= not scl;
    		
    		assert (
    			comp = test_vector(i).res_comp 				
    		) report "Res Comp Failed on Test Vector" & INTEGER'image(i) severity error;
	
    		assert (
    			rw = test_vector(i).res_rw			
    		) report "Res RW Failed on Test Vector" & INTEGER'image(i) severity error;	

    		    	
			load <= '0';
			wait for TbPeriod;
    	end loop;
    	
    	report "Testbench completed!";
        wait;
    end process;

end tb;
