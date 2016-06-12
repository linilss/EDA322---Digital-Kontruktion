
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.numeric_bit.all;
use IEEE.std_logic_unsigned.all;



entity mux21 is
    Port ( a, b : in  STD_LOGIC_VECTOR(7 downto 0);
           s : in  STD_LOGIC;
           o : out  STD_LOGIC_VECTOR(7 downto 0)
	);
end mux21;

architecture Behavioral of mux21 is

begin
	with s select
		o <= b when '1', 
		  a when others;
	

end Behavioral;

