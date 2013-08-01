--
--	Package File Template
--
--	Purpose: This package defines supplemental types, subtypes, 
--		 constants, and functions 
--
--   To use any of the example code shown below, uncomment the lines and modify as necessary
--

library ieee;
use ieee.std_logic_1164.all;

package flags is
	constant equals :	std_logic_vector (3 downto 0) := "0001";
	constant above :	std_logic_vector (3 downto 0) := "0010";
	constant overflow :	std_logic_vector (3 downto 0) := "0100";
	constant error :	std_logic_vector (3 downto 0) := "1000";
end flags;