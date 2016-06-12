
library ieee;
use ieee.std_logic_1164.all;

entity CMP is
	port( 	a : in STD_LOGIC_VECTOR(7 downto 0);
		b : in STD_LOGIC_VECTOR(7 downto 0); 
		EQ : out STD_LOGIC;
		NEQ : out STD_LOGIC
	);
end CMP;

architecture dataflow of CMP is
	signal tmp : STD_LOGIC_VECTOR(7 downto 0);
begin
        tmp <= a xor b;
	
	EQ <= not (or(tmp));
	NEQ <= or(tmp);

end dataflow;