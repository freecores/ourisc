----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:18:18 03/06/2012 
-- Design Name: 
-- Module Name:    REG - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity fetch_dff is
	generic (
		DATA_WIDTH : integer := 16
	);
    port ( 
		clk				: in std_logic;
		enable			: in std_logic;
		reset			: in std_logic;
		instruct_in 	: in  STD_LOGIC_Vector (DATA_WIDTH-1 downto 0);
		instruct_out 	: out std_logic_vector (DATA_WIDTH-1 downto 0);
		mux_in 			: in  STD_LOGIC_Vector (DATA_WIDTH-1 downto 0);
		mux_out 		: out std_logic_vector (DATA_WIDTH-1 downto 0)
	);
end fetch_dff;

architecture Behavioral of fetch_dff is
			
begin
	process(clk,reset)
	begin
		if(reset = '1') then
			instruct_out <= (others => '0');
		elsif (clk ='1' and clk'event) then
			if(enable = '1') then
				instruct_out <= instruct_in;							
				mux_out <= mux_in;							
			end if;
		end if;			
	end process;

end Behavioral;

