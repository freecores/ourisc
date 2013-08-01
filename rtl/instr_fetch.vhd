library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

library work;
use work.ram_package.all;

entity instr_fetch is
	generic(
	    DATA_WIDTH : integer := 16
	);
	port (
	  
	  	--inst_connect_from_host : in std_logic_vector(RAM_addr_width+RAM_data_width+1 downto 0);
		--inst_connect_to_host   : out std_logic_vector(RAM_data_width downto 0);				
	    clk    			: IN std_logic;
		reset			: IN std_logic;
		enable			: IN std_logic;
		enable_pc		: IN std_logic;
	    --FLAG	 	    : IN std_logic;   
	    --RESULTADO_ALU   : IN std_logic_vector(DATA_WIDTH-1 downto 0);
		iRb				: IN std_logic_vector(DATA_WIDTH-1 downto 0);
		iRdSelect  		: IN std_logic; -- Jump and link (Select R7)
		-- Memory File read control
		read_file 		: IN  std_logic;	
		mux_out			: OUT std_logic_vector(DATA_WIDTH-1 downto 0);
		instruct_out	: OUT std_logic_vector(DATA_WIDTH-1 downto 0);
		-- @Pipeline
		iJumpAddress	: IN std_logic_vector(DATA_WIDTH-1 downto 0); -- Result from ID Adder
		iBranchAssert	: in std_logic_vector(1 downto 0); -- Branch verification in EXE
		iBranchResult : in std_logic; -- From ID
		-- Branch Recovering
		iBranchAddress : in std_logic_vector(DATA_WIDTH-1 downto 0);
		iNPCFromID : in std_logic_vector(DATA_WIDTH-1 downto 0)
		-- @end Pipeline	
	    );
end instr_fetch;

architecture TopLevel of instr_fetch is
component program_counter is
	generic(
	    DATA_WIDTH : integer := 16
	);
	port (
		current_pc  : in std_logic_vector(DATA_WIDTH-1 downto 0);
		clk			: in std_logic;
		enable 		: in std_logic;
		reset		: in std_logic;
		pc		    : out std_logic_vector(DATA_WIDTH-1 downto 0)
	);	
end component;

component pc_adder is
	generic (
	    DATA_WIDTH : integer := 16;
	    INC_PLUS : integer := 1
	);
	port (
		pc : in std_logic_vector(DATA_WIDTH-1 downto 0);
		pc_plus : out std_logic_vector(DATA_WIDTH-1 downto 0)
	);
end component;

component next_pc_mux is
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
end component;

component fetch_dff is
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
end component;

--component ram is
--	port(
--		read_file : in std_logic;
--		write_file : in std_logic;
--		WE : in std_logic;
--		clk: in std_logic;
--		ADRESS : in std_logic_vector(DATA_WIDTH-1 downto 0);	 
--		DATA : in std_logic_vector (DATA_WIDTH-1 downto 0);
--		Q : out std_logic_vector (DATA_WIDTH-1 downto 0)
--	);
--
--end component;

	component inst_ram is
		port (
				--inst_connect_from_host : in std_logic_vector(RAM_addr_width+RAM_data_width+1 downto 0);
				--inst_connect_to_host   : out std_logic_vector(RAM_data_width downto 0);
		
				clk 		: in std_logic;
				rst 		: in std_logic;
				we			: in std_logic;
				addr		: in std_logic_vector(RAM_addr_width-1 downto 0);
				datain		: in std_logic_vector(RAM_data_width-1 downto 0);
				dataout		: out std_logic_vector(RAM_data_width-1 downto 0)
		);
	end component;

	-- @Pipeline
	component IFDecoder
		Port ( iSelNPC : in  std_logic;
			   iBranchResult : in  std_logic;
			   iAssertBranch : in std_logic;
			   oSelMuxNPC : out  std_logic_vector (1 downto 0));
	end component;
	
	component mux2x1
		Generic (WIDTH : integer := 16);
		Port ( iDataA : in  std_logic_vector (WIDTH-1 downto 0);
			   iDataB : in  std_logic_vector (WIDTH-1 downto 0);
			   iSelect : in  std_logic_vector (0 downto 0);
			   oData : out  std_logic_vector (WIDTH-1 downto 0));
	end component;

  signal PC, PC_1, mem_out, new_pc     	:std_logic_vector( DATA_WIDTH-1 downto 0);
  
  --@Pipeline
  signal sel_mux_npc : std_logic_vector(1 downto 0);
  signal mFlushNPC : std_logic_vector(DATA_WIDTH-1 downto 0);
  
  signal test : std_logic_vector(0 downto 0);
  
  --Synthetise
  signal maddress : std_logic_vector(DATA_WIDTH-1 downto 0);
  
begin
	
  	inst_program_counter : program_counter 
  	port map (
		c urren t_pc =>  new_pc,
		clk => clk,
		reset => reset,
		enable => enable_pc,	 
		pc => PC
    );
	 
  	inst_pc_adder : pc_adder 
  	port map (
		pc_plus => PC_1,
		pc	=> PC
	);
	
  inst_mux1 : mux1 port map(
	 PC_1 	=> PC_1,
	 --selectsignal  => iRdselect & FLAG,
	 selectsignal => sel_mux_npc,
	 enable => enable_pc,
	 --RESULTADO_ALU => RESULTADO_ALU,
	 R7Result => iR, 
	 SA IDA	=>   new_pc,
	 --@Pipeline
	 --TODO: Generalizar este mux
	 RESULTADO_ALU => iJumpAddress,
	 iFlushNPC => mFlushNPC
    );
	 
	
	maddress <= "000000" & PC(9 downto 0);
--  inst_ram : ram port map(
--     clk   	 	=> clk,
--	  WE			=> '0',
--	  write_file => '0',
--	  read_file => read_file,
--	  DATA => "0000000000000000",
--	 adress		=> maddress,
--	 Q	=> mem_out
--   );

	instr_mem : inst_ram
		port map (
				--inst_connect_from_host => inst_connect_from_host,
				--inst_connect_to_host   => inst_connect_to_host,
		
				clk 	=>	clk,
				rst 	=>	reset,
				we		=>	'0',
				addr	=>	PC(9 downto 0),
				datain	=> (others => '0'),
				dataout	=>  mem_out
		);

 	inst_fetch_dff : fetch_dff 
 	port map (
		clk	=> clk,
	 	enable => enable,
	 	instruct_out => instruct_out,
	 	mux_out => mux_out,
	 	instruct_in => mem_out, 
		mu x_in => new_pc,
	 	--@Pipeline
	 	reset => iBranchAssert(0)
	 );

	--@Pipeline
	MuxDecoder : IFDecoder
		port map ( 
			iSelNPC => iRdSelect,
			iBranchResult => iBranchResult,
			iAssertBranch => iBranchAssert(1),
			oSelMuxNPC => sel_mux_npc
		);
	
	test <= conv_std_logic_vector(iBranchAssert(1),1);
	MuxBranchRecover : mux2x1
		generic map (WIDTH => 16)
		port map ( 
			iDataA => iNPCFromID,
			iDataB => iBranchAddress,
			iSelect => test,
			oData => mFlushNPC
		);

end TopLevel;

