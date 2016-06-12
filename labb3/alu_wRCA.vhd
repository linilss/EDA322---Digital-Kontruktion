
library ieee;
use ieee.std_logic_1164.all;

entity alu_wRCA is
	port(	ALU_inA, ALU_inB : in STD_LOGIC_VECTOR(7 downto 0);
		OPERATION : in STD_LOGIC_VECTOR(1 downto 0);
		ALU_out : out STD_LOGIC_VECTOR(7 downto 0);
		Carry, NotEq, Eq, IsOutZero : out STD_LOGIC
	);
end alu_wRCA;

architecture dataflow of alu_wRCA is
	component RCA is
		port(	a, b : STD_LOGIC_VECTOR(7 downto 0);
			ci : in STD_LOGIC;
			s : out STD_LOGIC_VECTOR(7 downto 0);
			co : out STD_LOGIC
		);	
	end component;

	component CMP is
		port( 	a : in STD_LOGIC_VECTOR(7 downto 0);
			b : in STD_LOGIC_VECTOR(7 downto 0); 
			EQ : out STD_LOGIC;
			NEQ : out STD_LOGIC
		);
	end component;

	component mux41 is
		port( 	a, b, c, d : in STD_LOGIC_VECTOR(7 downto 0);
			s : in STD_LOGIC_VECTOR(1 downto 0);
			o : out STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;

	signal nandOut, notOut, RCAOut, b, muxOut : STD_LOGIC_VECTOR(7 downto 0);
	signal cin, notOutZero : STD_LOGIC;
begin
	nandOut <= ALU_inA nand ALU_inB;
	notOut <= not ALU_inA;	
	
	with OPERATION select
		b <= (not ALU_inB) when "01",
		     ALU_inB when others;
	
	with OPERATION select
		cin <= OPERATION(0) when "01",
	              OPERATION(1) when others;




	a0 : RCA port map (ALU_inA, b, cin, RCAOut, Carry); 
	a1 : CMP port map (ALU_inA, ALU_inB, Eq, NotEq);

	a2 : mux41 port map (RCAOut, RCAOut, nandOut, notOut, OPERATION, muxOut);

	a3 : CMP port map(muxOut, "00000000", IsOutZero, notOutZero);
	ALU_out <= muxOut;
	
end dataflow;