library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity pc_adder is
	generic (
	    DATA_WIDTH : integer := 16;
	    INC_PLUS : integer := 1
	);
	port (
		pc : in std_logic_vector(DATA_WIDTH-1 downto 0);
		pc_plus : out std_logic_vector(DATA_WIDTH-1 downto 0)
	);

end pc_adder;

architecture Behavioral of pc_adder is

	
begin
	process(pc)
		variable pc_aux : std_logic_vector(DATA_WIDTH-1 downto 0) := conv_std_logic_vector(0,DATA_WIDTH); -- verify if it is necessary
	begin
			pc_aux := pc + INC_PLUS;					
			pc_plus <= pc_aux;
	end process;
	
end Behavioral;
