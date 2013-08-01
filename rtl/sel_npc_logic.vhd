----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:33:24 04/25/2012 
-- Design Name: 
-- Module Name:    Concat - Sel_NPC_Logic 
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
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity IFDecoder is
    Port ( iSelNPC : in  STD_LOGIC;
           iBranchResult : in  STD_LOGIC;
		   iAssertBranch : in STD_LOGIC;
           oSelMuxNPC : out  STD_LOGIC_VECTOR (1 downto 0));
end IFDecoder;

architecture Sel_NPC_Logic of IFDecoder is

begin
	process (iSelNPC,iBranchResult,iAssertBranch)
		variable mSel : std_logic_vector(2 downto 0);
	begin
		mSel := iSelNPC & iBranchResult & iAssertBranch;
		oSelMuxNPC <= "00";
		case(mSel) is
			when "000" =>
				oSelMuxNPC <= "00"; -- Not a jump, get PC+1
			when "001" | "011" | "101" | "111" =>
				oSelMuxNPC <= "11"; -- Jump misstaken
			when "010" =>
				oSelMuxNPC <= "01"; -- BTB in action: branch taken
			when "100" | "110" =>
				oSelMuxNPC <= "10"; -- Jump and Link, get RB
			when others =>
				oSelMuxNPC <= "00"; -- Nothing
		end case;
	end process;

end Sel_NPC_Logic;




