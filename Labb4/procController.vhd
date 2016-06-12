library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity procController is
    Port ( 			master_load_enable: in STD_LOGIC;
				opcode : in  STD_LOGIC_VECTOR (3 downto 0);
				jmpop : in STD_LOGIC;
				neq : in STD_LOGIC;
				eq : in STD_LOGIC; 
				CLK : in STD_LOGIC;
				ARESETN : in STD_LOGIC;
				pcSel : out  STD_LOGIC;
				pcLd : out  STD_LOGIC;
				nxtPCop: out STD_LOGIC;
				instrLd : out  STD_LOGIC;
				addrMd : out  STD_LOGIC;
				dmWr : out  STD_LOGIC;
				dataLd : out  STD_LOGIC;
				flagLd : out  STD_LOGIC;
				accSel : out  STD_LOGIC;
				accLd : out  STD_LOGIC;
				dmRd : out  STD_LOGIC;
				acc2bus : out  STD_LOGIC;
				ext2bus : out  STD_LOGIC;
				dispLd: out STD_LOGIC;
				aluMd : out STD_LOGIC_VECTOR(1 downto 0));
end procController;

architecture Behavioral of procController is

type state_type  is (FE, DE, DE2, EX, ME);
signal state, next_state : state_type;
signal signals : STD_LOGIC_VECTOR(15 downto 0);


begin

pcSel <= signals(0);
pcLd <= signals(1);
nxtPCop <= signals(2);
instrLd <= signals(3);
addrMd <= signals(4);
dmWr <= signals(5);
dataLd <= signals(6);
flagLd <= signals(7);
accSel <= signals(8);
accLd <= signals(9);
dmRd <= signals(10);
acc2bus <= signals(11);
ext2bus <= signals(12);
dispLd <= signals(13);
aluMd(1) <= signals(14);
aluMd(0) <= signals(15);


process(CLK, ARESETN)
begin
if ARESETN = '0' then
	state <= FE;
else
    if (rising_edge(CLK)) then
        if master_load_enable = '1' then
		    state <= next_state;
        end if;
    end if;
end if;
end process;

process(state, opcode)
begin    
    case state is
        when FE =>
            next_state <= DE;
        when DE =>
            case opcode is
            when "0000" => next_state <= EX;
            when "0001" => next_state <= EX;
            when "0010" => next_state <= EX;
            when "0011" => next_state <= EX;
            when "0100" => next_state <= EX;
            when "0101" => next_state <= EX;
            when "0110" => next_state <= EX;
            when "0111" => next_state <= ME;
            when "1000" => next_state <= DE2;
            when "1001" => next_state <= DE2;
            when "1010" => next_state <= DE2;
            when "1011" => next_state <= FE;
            when "1100" => next_state <= FE;
            when "1101" => next_state <= FE;
            when "1110" => next_state <= FE;
            when "1111" => next_state <= EX;
            when others => next_state <= FE;
            end case;
        when DE2 =>
            case opcode is
            when "1000" => next_state <= EX;
            when "1001" => next_state <= EX;
            when "1010" => next_state <= ME;
            when others => next_state <= FE;
            end case;
        when EX =>
            next_state <= FE;
        when ME =>
            next_state <= FE;
    end case;
end process;
	

process(state, opcode)
begin
signals <= (others => '0');
    case opcode is
        when "0000" =>
	    	signals(2) <= '1';
		signals(3) <= '1';
            	case state is
                	when DE =>
		    		signals(6) <= '1';
                	when EX =>
		    		signals(1) <= '1';
		    		signals(7) <= '1';
		    		signals(9) <= '1';
		    		signals(10) <= '1';
                	when others =>
		end case;
        when "0001" =>
        	signals(2) <= '1';
		signals(3) <= '1';
            	case state is
                	when DE =>
				signals(6) <= '1';
                	when EX =>
				signals(1) <= '1';
				signals(7) <= '1';
				signals(9) <= '1';
			    	signals(10) <= '1';
                	when others =>
            	end case;
       when "0010" =>
        	signals(2) <= '1';
		signals(3) <= '1';
        	signals(15) <= '1';
            	case state is
                	when DE =>
				signals(6) <= '1';
                	when EX =>
				signals(1) <= '1';
				signals(7) <= '1';
				signals(9) <= '1';
				signals(10) <= '1';
			
                	when others =>
            	end case;

       when "0011" =>
        	signals(2) <= '1';
		signals(3) <= '1';
        	signals(14) <= '1';
            	case state is
                	when DE =>
				signals(6) <= '1';
			
                	when EX =>
				signals(1) <= '1';
				signals(7) <= '1';
				signals(9) <= '1';
				signals(10) <= '1';
                	when others =>
            	end case;
       when "0100" =>
        	signals(2) <= '1';
		signals(3) <= '1';
        	signals(14) <= '1';
		signals(15) <= '1';
            	case state is
                	when DE =>
				signals(6) <= '1';
                	when EX =>
				signals(1) <= '1';
				signals(7) <= '1';
				signals(9) <= '1';	
               	 	when others =>
            	end case;
       when "0101" =>
        	signals(2) <= '1';
		signals(3) <= '1';
            	case state is
			when DE =>
				signals(6) <= '1';
                	when EX =>
				signals(1) <= '1';
				signals(7) <= '1';
				signals(10) <= '1';
			
                	when others =>
            	end case;
       when "0110" =>
        	signals(2) <= '1';
		signals(3) <= '1';
            	case state is
		 	when DE =>
				signals(6) <= '1';			
	                when EX =>
				signals(1) <= '1';
				signals(8) <= '1';
				signals(9) <= '1';
				signals(10) <= '1';
			
                	when others =>
            	end case;

       when "0111" =>
        	signals(2) <= '1';
		signals(3) <= '1';
        	signals(11) <= '1';
            	case state is
                	when ME =>
				signals(1) <= '1';
				signals(5) <= '1';
	                when others =>
	        end case;

       when "1000" =>
        	signals(2) <= '1';
		signals(3) <= '1';
            	case state is
                	when DE =>
				signals(6) <= '1';
                	when DE2 =>
				signals(4) <= '1';
				signals(6) <= '1';
               	 	when EX =>
				signals(1) <= '1';
				signals(7) <= '1';
				signals(9) <= '1';
				signals(10) <= '1';
                	when others =>
            	end case;
       when "1001" =>
        	signals(2) <= '1';
		signals(3) <= '1';
            	case state is
                	when DE =>
				signals(6) <= '1';
            	    	when DE2 =>
				signals(4) <= '1';
				signals(6) <= '1';
               	 	when EX =>
				signals(1) <= '1';
				signals(8) <= '1';
				signals(9) <= '1';
				signals(10) <= '1';
                	when others =>
            	end case;
       when "1010" =>
        	signals(2) <= '1';
		signals(3) <= '1';
        	signals(11) <= '1';
            	case state is
                	when DE =>
				signals(6) <= '1';
               	 	when ME =>
				signals(1) <= '1';
				signals(4) <= '1';
				signals(5) <= '1';
                	when others =>
            	end case;
       when "1011" =>
        	signals(2) <= '1';
		signals(3) <= '1';
        	signals(12) <= '1';
            	case state is
                	when DE =>
				signals(1) <= '1';
				signals(5) <= '1';
                	when others =>
            	end case;
       when "1100" =>
		signals(3) <= '1';
            	case state is
                	when DE =>
				signals(0) <= '1';
				signals(1) <= '1';
		    		signals(2) <= jmpop;
                	when others =>
            	end case;
       when "1101" =>
		signals(3) <= '1';
	        case state is
                	when DE =>
				signals(0) <= eq;
				signals(1) <= '1';
		    		if eq='0' then
					signals(2) <= jmpop;
		    		else
					signals(2) <= '1';
		    		end if;
                	when others =>
            	end case;
       when "1110" =>
		signals(3) <= '1';
            	case state is
                	when DE =>
				signals(0) <= neq;
				signals(1) <= '1';
				signals(2) <= '1';
		    		if neq='0' then
					signals(2) <= jmpop;
		    		else
					signals(2) <= '1';
		    		end if;
                	when others =>
            	end case;
       when "1111" =>
		signals(2) <= '1';
		signals(3) <= '1';
	        case state is
                	when EX =>
				signals(1) <= '1';
				signals(13) <= '1';
                	when others =>
            	end case;
	when others =>
       		null;
    	end case; 
end process;

end Behavioral;
