
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity EDA322_processor is
	Port ( 
		externalIn : in  STD_LOGIC_VECTOR (7 downto 0); --?extIn? in Figure 1
		CLK : in STD_LOGIC;
		master_load_enable : in STD_LOGIC;
		ARESETN : in STD_LOGIC;
		pc2seg : out  STD_LOGIC_VECTOR (7 downto 0); 	--PC  
		instr2seg : out  STD_LOGIC_VECTOR (11 downto 0); --Instruction register
		Addr2seg : out  STD_LOGIC_VECTOR (7 downto 0); 	--Address register
		dMemOut2seg : out  STD_LOGIC_VECTOR (7 downto 0);-- Data memory output
		aluOut2seg : out  STD_LOGIC_VECTOR (7 downto 0);--ALU output
		acc2seg : out  STD_LOGIC_VECTOR (7 downto 0); 	--Accumulator
		flag2seg : out  STD_LOGIC_VECTOR (3 downto 0); 	--Flags
		busOut2seg : out  STD_LOGIC_VECTOR (7 downto 0);--Value on the bus
		disp2seg: out STD_LOGIC_VECTOR(7 downto 0);	--Display register
		errSig2seg : out STD_LOGIC;			--Bus Error signal
		ovf : out STD_LOGIC;				--Overflow 
		zero : out STD_LOGIC				--Zero
	);
end EDA322_processor;

architecture dataflow of EDA322_processor is

signal cadder, offset2, nxtpc, pc, pcoffset, bitOffset, MemDataOutReged, Addr, dataIn, MemDataOut, OutFromAcc, BusOut, aluOut, muxOut, fOut, dOut, mux2adder : STD_LOGIC_VECTOR(7 downto 0);
signal jmpOffset : STD_LOGIC_VECTOR(6 downto 0);
signal InstrMemOut, Instruction : STD_LOGIC_VECTOR(11 downto 0);
signal aluMd : STD_LOGIC_VECTOR(1 downto 0);
signal FlagInp, opcode, flags : STD_LOGIC_VECTOR(3 downto 0);
signal nul, pcSel, pcLd, instrLd, addrMd, dmWr, dataLd, accSel, accLd, dispLd, flagLd, jmpop, neq, eq, nxtPCop, dmRd, acc2bus, ext2bus : STD_LOGIC;

begin
	bitOffset <= '0' & jmpOffset;
	jmpOffset <= Instruction(6 downto 0);
	dataIn <= BusOut;
	offset2 <= std_logic_vector(unsigned(not (pcoffset))+1);
	jmpop <= Instruction(7);

	pcAdder: entity work.RCA port map(a => pc,b => mux2adder, ci => '0',s => nxtpc, co => nul);
	mux2110: entity work.mux21 port map(a => "00000001", b => bitOffset, s => pcSel, o => pcoffset);
	mux2111: entity work.mux21 port map(a => offset2, b=> pcoffset, s => nxtPCop, o => mux2adder);
	FE: entity work.reg generic map (width => 8) port map(inp => nxtpc, CLK => CLK, ARESETN => ARESETN, loadEnable => pcLd, res => pc);
	iMemory: entity work.mem_array generic map (DATA_WIDTH => 12, ADDR_WIDTH => 8, INIT_FILE=>"inst_mem.mif") port map(ADDR => pc, DATAIN => "000000000000", CLK => CLK, WE => '0', OUTPUT => InstrMemOut);
	
	FEDE: entity work.reg generic map(width => 12) port map(inp => InstrMemOut, CLK => CLK, ARESETN => ARESETN, loadEnable => instrLd, res => Instruction);
	
	mux212: entity work.mux21 port map(a => Instruction(7 downto 0), b => MemDataOutReged, s => addrMd, o => Addr);
	dMemory: entity work.mem_array generic map (DATA_WIDTH => 8, ADDR_WIDTH => 8, INIT_FILE=>"data_mem.mif") port map(ADDR => Addr, DATAIN => dataIn, CLK => CLK, WE => dmWr, OUTPUT => MemDataOut);
	
	DEEX: entity work.reg generic map (width => 8) port map(inp => MemDataOut, CLK => CLK, ARESETN => ARESETN, loadEnable => dataLd, res => MemDataOutReged);
	
	ALU: entity work.alu_wRCA port map(ALU_inA => OutFromAcc, ALU_inB => BusOut, OPERATION => aluMd, ALU_out => aluOut, Carry => FlagInp(3), NotEq => FlagInp(2), Eq => FlagInp(1), IsOutZero => FlagInp(0));
	mux213: entity work.mux21 port map(a => aluOut, b => BusOut, s => accSel, o => muxOut);
	ACC: entity work.reg generic map(width => 8) port map(inp => muxOut, CLK => CLK, ARESETN => ARESETN, loadEnable => accLd, res => OutFromAcc);
	Display: entity work.reg generic map(width => 8) port map(inp => OutFromAcc, CLK => CLK, ARESETN => ARESETN, loadEnable => dispLd, res => disp2seg);
	FReg: entity work.reg generic map(width => 4) port map(inp => FlagInp, CLK => CLK, ARESETN => ARESETN, loadEnable => flagLd, res => flags);
	Controller: entity work.procController port map ( master_load_enable, opcode, jmpop, neq, eq, CLK,ARESETN, pcSel,pcLd, nxtPCop, instrLd, addrMd, dmWr, dataLd, flagLd, accSel, accLd, dmRd, acc2bus, ext2bus, dispLd, aluMd);
	
	ProcBus: entity work.procBus port map (DATA => MemDataOutReged, ACC => OutFromAcc,EXTDATA  => externalIn,OUTPUT => BusOut ,ERR => errSig2seg, dataSEL => dmRd, accSEL => acc2bus,extdataSEL => ext2bus);
	
	aluOut2seg <= aluOut;
	pc2seg <= pc;
	instr2seg <= Instruction;
	busOut2seg <= BusOut;
	Addr2seg <= Addr;
	dMemOut2seg <= MemDataOutReged;
	aluOut2seg <= aluOut;
	acc2seg <= OutFromAcc;
	flag2seg <= flags;
	ovf <= flags(3);
	neq <= flags(2);
	eq <= flags(1);
	zero <= flags(0);
	opcode <= Instruction(11 downto 8);
end dataflow;