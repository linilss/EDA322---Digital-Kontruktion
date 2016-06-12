
library ieee;
use ieee.std_logic_1164.all;

entity FA is
	Port( 	a : in STD_LOGIC;
		b : in STD_LOGIC;
		ci : in STD_LOGIC;
		co : out STD_LOGIC;
		s : out STD_LOGIC
	);
end FA;

architecture dataflow of FA is

begin 
	s <= a XOR b XOR ci;
	co <= (ci AND (a XOR b)) OR (a AND b);
end dataflow;
