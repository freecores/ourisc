----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    01:14:05 05/02/2012 
-- Design Name: 
-- Module Name:    DFF - FlipFlop 
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

entity dff is
	Generic (WIDTH : integer := 16);
    Port ( clk : in std_logic;
           en : in std_logic;
           rst_n : in std_logic;
           D : in std_logic_vector (WIDTH-1 downto 0);
           Q : out std_logic_vector (WIDTH-1 downto 0));
end dff;

architecture FlipFlop of dff is

begin
	process (clock,reset)
	begin
		if(reset = '0') then
			Q <= (others => '0');
		elsif clock'event and clock = '1' then
			if(enable = '1') then
				Q <= D;
			end if;	
		end if;
	end process;

end FlipFlop;

