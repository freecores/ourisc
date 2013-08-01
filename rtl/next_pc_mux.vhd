library ieee;
use ieee.std_logic_1164.all;

entity next_pc_mux is
	generic (
	    DATA_WIDTH : integer := 16
	);
	port (
		pc_pus_one : in std_logic_vector(DATA_WIDTH-1 downto 0);
		alu_output : in std_logic_vector(DATA_WIDTH-1 downto 0);
		r7_result : in std_logic_vector(DATA_WIDTH-1 downto 0);
		flush_npc : in std_logic_vector(DATA_WIDTH-1 downto 0);
		select_signal : in  std_logic_vector(1 downto 0); -- 0 - FLAG, 1 - iRdselect @ verify vector usage
		enable : in std_logic;
		next_pc	: out std_logic_vector(DATA_WIDTH-1 downto 0)
	);

end next_pc_mux;

architecture Behavioral of next_pc_mux is
begin

	process(enable,selectsignal,alu_output,pc_pus_one,flush_npc,r7_result)
	begin
		if(enable = '1') then
			case select_signal is
				when "00" =>
					next_pc <= pc_pus_one;
				when "01" =>
					next_pc <= alu_output;
				when "10" =>
					next_pc <= r7_result;
				when "11" =>
					next_pc <= flush_npc;
				when others =>
					null;
			end case;
		end if;
	end process;
				 
end Behavioral;
