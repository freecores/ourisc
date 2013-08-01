----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:02:04 04/19/2012 
-- Design Name:    Multiplexer 3 x 1
-- Module Name:    mux4x1 - Multiplex 
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

entity mux4x1 is
	generic ( 
		WIDTH : integer := 16 );
    port ( 
    	in_a : in STD_LOGIC_VECTOR (WIDTH-1 downto 0);
        in_b : in STD_LOGIC_VECTOR (WIDTH-1 downto 0);
        in_c : in STD_LOGIC_VECTOR (WIDTH-1 downto 0);
        in_d : in STD_LOGIC_VECTOR (WIDTH-1 downto 0);
        sel : in STD_LOGIC_VECTOR (1 downto 0);
        dataout : out STD_LOGIC_VECTOR (WIDTH-1 downto 0) );
end mux4x1;

architecture Multiplex of mux4x1 is
begin
	process(sel, in_a, in_b, in_c)
	begin
		case sel is
			when "00" => dataout <= in_a;
			when "01" => dataout <= in_b;
			when "10" => dataout <= in_c;
			when "11" => dataout <= in_d;
			when others => dataout <= (others => '0');
		end case;			
	end process;

end Multiplex;

