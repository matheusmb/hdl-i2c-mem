library ieee;
use ieee.std_logic_1164.all;

use work.memi2cpkg.all;

entity serial_control_logic is
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
end entity serial_control_logic;


architecture Behavoral of serial_control_logic is
	type I2C_STATE is (IDLE, COMP_ADDR, WAITING_COMP, GET_ADDR, WAITING_ADDR, ACK_COMP, ACK_ADDR_WRITE, GET_DATA, WAITING_DATA, WAITING_WRITE, WAIT_CLOCK);
	signal state 	:	I2C_STATE;
	
	signal s_mAddr	:	std_logic_vector(6 downto 0);
	signal s_mData	:	std_logic_vector(7 downto 0);
	signal s_st_wait: 	std_logic := '0';
	signal s_wait_done : std_logic := '0';

begin
	
	clk_waiter : clk_waitert port map(
		scl  => scl,
		st   => s_st_wait,
		done => s_wait_done
	);
	
	mAddr <= s_mAddr;
	mData <= s_mData;
	
	Control_Logic :
	process(scl, stb, bAddrCompDone, sReaderDone, sWriterDone, s_wait_done)
	begin

		case state is
		when IDLE =>
			sReaderSt <= '0';
			sWriterSt <= '0';
			bAddrCompEn <= '0';
			mWrite <= '0';
				if(stb = '1')  then
					state <= COMP_ADDR;
				end if;
				
			when COMP_ADDR =>
				bAddrCompEn <= '1';
				state <= WAITING_COMP;
				
			when WAITING_COMP =>
				if(bAddrCompDone = '1') then
					if(bAddrCompRes = '1') then
						state <= ACK_COMP;
						s_st_wait <= '1';
					else
						state <= IDLE;
					end if;
					
					bAddrCompEn <= '0';
				end if;	
				
			when ACK_COMP =>
				if(s_wait_done = '1') then
					s_st_wait <= '0';
					state <= GET_ADDR;
				end if;
			
				
			when GET_DATA =>
				if(s_wait_done = '1') then
					s_st_wait <= '0';
					sReaderSt <= '1';					
					state <= WAITING_DATA;
				end if;

			
				
			when  GET_ADDR => 
				sReaderSt <= '1';					
				state <= WAITING_ADDR;

				
				
			when WAITING_ADDR =>
				if(sReaderDone = '1') then
					sReaderSt <= '0';
					
					s_mAddr <= sReaderOut(6 downto 0);
					
					if(rw = '1') then
						s_st_wait <= '1';
						state <= GET_DATA;
					else
						s_st_wait <= '1';
						state <= ACK_ADDR_WRITE;
					end if;
				end if;		
				
			when ACK_ADDR_WRITE =>
				if(s_wait_done = '1') then
					s_st_wait <= '0';
					sWriterSt <= '1';
					state <= WAITING_WRITE;		
				end if;		
			
				
			when WAITING_WRITE =>
				if(sWriterDone = '1') then
					sWriterSt <= '0';
					state <= IDLE;
				end if;
			
			when WAITING_DATA =>
				if(sReaderDone = '1') then
					sReaderSt <= '0';
					
					s_mData <= sReaderOut;
					
					if(wp = '0') then
						mWrite <= '1';
					end if;
					s_st_wait <= '1';
					state <= WAIT_CLOCK;
				end if;
				
			when WAIT_CLOCK =>
				if(s_wait_done = '1') then
					s_st_wait <= '0';
					mWrite <= '0';
					state <= IDLE;
				end if;
				
						
						
							
						
				
				when others => null;
			end case;

					
	end process;
	

	
end architecture Behavoral;
