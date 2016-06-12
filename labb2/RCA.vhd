 
library ieee;
use ieee.std_logic_1164.all;

entity RCA is
	port(	a : in STD_LOGIC_VECTOR(7 downto 0);
		b : in STD_LOGIC_VECTOR(7 downto 0);
		ci : in STD_LOGIC;
		s : out STD_LOGIC_VECTOR(7 downto 0);
		co : out STD_LOGIC
	); 
end RCA;
architecture dataflow of RCA is

component FA is
	port(	a, b, ci : in STD_LOGIC;
		co : out STD_LOGIC;
		s : out STD_LOGIC
	);
end component;

signal c1,c2,c3,c4,c5,c6,c7 : STD_LOGIC;

begin
	a0 : FA port map(a(0), b(0), ci, c1, s(0));
	a1 : FA port map(a(1), b(1), c1, c2, s(1));
	a2 : FA port map(a(2), b(2), c2, c3, s(2));
	a3 : FA port map(a(3), b(3), c3, c4, s(3));
	a4 : FA port map(a(4), b(4), c4, c5, s(4));
	a5 : FA port map(a(5), b(5), c5, c6, s(5));
	a6 : FA port map(a(6), b(6), c6, c7, s(6));
	a7 : FA port map(a(7), b(7), c7, co, s(7));	

end dataflow;