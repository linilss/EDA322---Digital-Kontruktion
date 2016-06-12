
library ieee;
use ieee.STD_LOGIC_1164.all;

entity reg is 
	generic (width : integer := 8);
	PORT(
		inp : in STD_LOGIC_VECTOR(width-1 downto 0);
		CLK : in STD_LOGIC;
		ARESETN : in STD_LOGIC;
		loadEnable : in STD_LOGIC;
		res : out STD_LOGIC_VECTOR(width-1 downto 0)
	); 
end reg;

architecture dataflow of reg is
--	signal zero : STD_LOGIC_VECTOR(width-1 downto 0) := (others => '0');
begin
	process(CLK, ARESETN)
	begin
--		if not (rising_edge(ARESETN)) then
--			res <= zero;
--		end if;
--
--		if rising_edge(CLK) and loadEnable = '1' then
--			res <= inp;
--		end if;

	if (ARESETN='0') then
			res <= (others => '0');
	elsif rising_edge(CLK) then
		if loadEnable = '1' then
			res <= inp;
		end if;
	end if;
	end process;
			
end dataflow;