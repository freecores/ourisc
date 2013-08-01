----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:48:33 04/18/2012 
-- Design Name: 
-- Module Name:    adder - Behavioral 
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
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity adder is
	Generic (
		WIDTH : integer := 16 );
    Port ( 
    	data_a : in std_logic_vector (WIDTH-1 downto 0);
        data_b : in std_logic_vector (WIDTH-1 downto 0);
        result : out std_logic_vector (WIDTH-1 downto 0) );
end adder;

architecture Macrofunction of adder is	
begin
	process(data_a, data_b)
		variable mAux : std_logic_vector(WIDTH-1 downto 0) := conv_std_logic_vector(0,WIDTH);
	begin
		mAux := data_a + data_b;
		result <= mAux;
	end process;

end Macrofunction;

