
library ieee;
use ieee.std_logic_1164.all;

entity procBus is
	port(	DATA : in STD_LOGIC_VECTOR(7 downto 0);
		ACC : in STD_LOGIC_VECTOR(7 downto 0);
		EXTDATA : in STD_LOGIC_VECTOR(7 downto 0);
		OUTPUT : out STD_LOGIC_VECTOR(7 downto 0);
		ERR : out STD_LOGIC;
		dataSEL : in STD_LOGIC;
		accSEL : in STD_LOGIC;
		extdataSEL : in STD_LOGIC
	);
end procBus;

architecture dataflow of procBus is

signal sel : STD_LOGIC_VECTOR(2 downto 0);
signal ctrl : STD_LOGIC_VECTOR(2 downto 0);
signal selec : STD_LOGIC_VECTOR(1 downto 0);

begin
	sel(0) <= dataSEL;
	sel(1) <= accSEL;
	sel(2) <= extdataSEL;

	with sel select 
		ctrl <=	"001" when "001",
			"010" when "010",
			"011" when "100",
			"000" when "000",
			"100" when others;
	ERR <= ctrl(2);
	selec(0) <= ctrl(0);
	selec(1) <= ctrl(1);
	
	with selec select
		OUTPUT <=	DATA when "01",
				ACC when "10",
				EXTDATA when "11",
				"00000000" when others;

end dataflow;
