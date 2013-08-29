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
    	sink_a   : in std_logic_vector (WIDTH-1 downto 0);
        sink_b   : in std_logic_vector (WIDTH-1 downto 0);
        sink_c   : in std_logic_vector (WIDTH-1 downto 0);
        sink_d   : in std_logic_vector (WIDTH-1 downto 0);
        sink_sel : in std_logic_vector (1 downto 0);
        src_data : out std_logic_vector (WIDTH-1 downto 0) );
end mux4x1;

architecture Multiplex of mux4x1 is
begin
	process(sink_sel, sink_a, sink_b, sink_c)
	begin
		case sink_sel is
			when "00" => src_data <= sink_a;
			when "01" => src_data <= sink_b;
			when "10" => src_data <= sink_c;
			when "11" => src_data <= sink_d;
			when others => src_data <= (others => '0');
		end case;			
	end process;

end Multiplex;

