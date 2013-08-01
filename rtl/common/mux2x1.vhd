----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    22:26:49 04/18/2012 
-- Design Name: 
-- Module Name:    mux2x1 - Behavioral 
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

entity mux2x1 is
	Generic ( WIDTH : integer := 16 );
    Port ( in_a : in std_logic_vector (WIDTH-1 downto 0);
           in_b : in std_logic_vector (WIDTH-1 downto 0);
           sel : in std_logic_vector (0 downto 0); -- FIXME
           dataout : out std_logic_vector (WIDTH-1 downto 0));
end mux2x1;

architecture Primitive of mux2x1 is
begin
	process(sel, in_a, in_b)
	begin
		case sel is
			when "0" => dataout <= in_a;
			when "1" => dataout <= in_b;
			when others => dataout <= (others => '0');
		end case;
			
	end process;
end Primitive;

