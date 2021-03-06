
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use std.textio.all;

entity EDA322Testbench is

end EDA322Testbench;


architecture Behavioral of EDA322Testbench is
	component EDA322_processor is
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
	end component;
	



signal test_time_step : integer := 0;

	signal CLK:  std_logic := '0';
	signal ARESETN:  std_logic := '0';
	signal master_load_enable:  std_logic := '0';


signal pc2seg: std_logic_vector(7 downto 0);
signal addr2seg: std_logic_vector(7 downto 0);
signal instr2seg: std_logic_vector(11 downto 0);
signal dMemOut2seg: std_logic_vector(7 downto 0);
signal aluOut2seg: std_logic_vector(7 downto 0);
signal acc2seg: std_logic_vector(7 downto 0);
signal flag2seg: std_logic_vector(3 downto 0);
signal busOut2seg: std_logic_vector(7 downto 0);
signal disp2seg: std_logic_vector(7 downto 0);
signal errSig2seg: std_logic;
signal ovf: std_logic;
signal zero: std_logic;


Type memory_array is ARRAY (0 to 68) of STD_LOGIC_VECTOR(7 downto 0);
	
impure function init_memory_wfile(txt_file_name : in string) return memory_array is
	file txt_file : text open read_mode is txt_file_name;
    	variable txt_line : line;
    	variable temp_bv : bit_vector(7 downto 0);
    	variable temp_mem : memory_array;
	variable I : integer := 0;
	begin
		while not endfile(txt_file) loop
        		readline(txt_file, txt_line);
        		read(txt_line, temp_bv);
        		temp_mem(i) := to_stdlogicvector(temp_bv);
			I := I + 1;
		end loop;
	return temp_mem;
end function;

signal acctrace : memory_array := init_memory_wfile("accTrace.txt");	
signal disptrace : memory_array := init_memory_wfile("dispTrace.txt");
signal dMemOuttrace : memory_array := init_memory_wfile("dMemOutTrace.txt");
signal flagtrace : memory_array := init_memory_wfile("flagTrace.txt");
signal pctrace : memory_array := init_memory_wfile("pctrace.txt");


	
begin

-- Design Under Test (DUT) instantiation
	EDA322_dut : EDA322_processor port map (
	           externalIn => "00000000",
		   CLK => CLK,
		   master_load_enable => master_load_enable, -- flipflop load enables for single step mode
		   ARESETN =>ARESETN,
	           pc2seg => pc2seg, -- 8 bit
	           instr2seg => instr2seg, -- 12 bit
	           Addr2seg => addr2seg, --8 bit
	           dMemOut2seg => dMemOut2seg, -- 8 bit
	           aluOut2seg => aluOut2seg, -- 8 bit
	           acc2seg => acc2seg, --8 bit
	           flag2seg => flag2seg, -- 4bit
	           busOut2seg => busOut2seg, -- 8 bit
		   disp2seg => disp2seg, -- 8 bit
		   errSig2seg => errSig2seg, -- 1 bit -- to LED
		   ovf => ovf, --1 bit -- to LED
		   zero => zero -- 1 bit -- to LED
	  );




	CLK <= not CLK after 5 ns; -- CLK with period of 10ns
	

	acc: process(acc2seg)
	variable acccounter : integer := 0;
	begin
		if ARESETN = '1' then
			assert (acctrace(acccounter) = acc2seg) report "acc2seg error..." severity error;
			acccounter := acccounter+1;
		end if;
	end process;
	disp: process(disp2seg)
	variable dispcounter : integer := 0;
	begin
		assert (disp2seg = "10010000") 
			report "Test succeeded"
			severity failure;
		
		if ARESETN = '1' then
			assert (disptrace(dispcounter) = disp2seg) report "disp2seg error..." severity error;	
			dispcounter := dispcounter+1;
		end if;
	end process;
	dMemOut: process(dMemOut2seg)
	variable dMemOutcounter : integer := 0;
	begin
		if ARESETN = '1' then
			assert (dMemOuttrace(dMemOutcounter) = dMemOut2seg) report "dMemOut2seg error..." severity error;
			dMemOutcounter := dMemOutcounter+1;
		end if;
	end process;
	
	flag: process(flag2seg)
	variable flagcounter : integer := 0;
	begin
		if ARESETN = '1' then
			assert (flagtrace(flagcounter) = flag2seg) report "flag2seg error..." severity error;
			flagcounter := flagcounter+1;
		end if;
	end process;

	pc: process(pc2seg)
	variable pccounter : integer := 0;
	begin
		if ARESETN = '1' then
			assert (pctrace(pccounter) = pc2seg) report "pc2seg error..." severity error;
			pccounter := pccounter+1;
		end if;
	end process;
	
	process (CLK)
	begin
		if rising_edge(CLK) then
			test_time_step <= test_time_step + 1;
			master_load_enable <= not master_load_enable;
		else
			master_load_enable <= not master_load_enable;
		end if;
		if test_time_step = 2 then
			ARESETN <= '1';
		end if;
	end process;

	end Behavioral;


		