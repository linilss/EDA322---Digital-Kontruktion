
library ieee;
use ieee.std_logic_1164.all;

entity mux41 is
	Port( 		a,b,c,d : in STD_LOGIC_VECTOR(7 downto 0);
			s : in STD_LOGIC_VECTOR(1 downto 0);
			o : out STD_LOGIC_VECTOR(7 downto 0)
	);
end mux41;


architecture behavioral of mux41 is
	component mux21 is
		port(
			a ,b : in STD_LOGIC_VECTOR(7 downto 0);
			s : in STD_LOGIC;
			o : out STD_LOGIC_VECTOR(7 downto 0)
		);
	end component;
	
	signal t1, t2 : STD_LOGIC_VECTOR(7 downto 0);
	
begin
	u1 : mux21 port map (a, b, s(0), t1);
	u2 : mux21 port map (c, d, s(0), t2);
	u3 : mux21 port map (t1, t2, s(1), o);
	
end behavioral;