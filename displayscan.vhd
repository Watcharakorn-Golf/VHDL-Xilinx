

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use ieee.std_logic_unsigned.all;

entity displayscan is
    Port ( led_in : in  STD_LOGIC_VECTOR (7 downto 0);
           d0_in, d1_in, d2_in,  d3_in  : in  STD_LOGIC_VECTOR (3 downto 0);
			  clk, reset : in STD_LOGIC;
			  seg : out STD_LOGIC_VECTOR (7 downto 0);
			  digit : out STD_LOGIC_VECTOR (4 downto 0)
			  );
end displayscan;

architecture Behavioral of displayscan is
	CONSTANT TCNS : unsigned(19 downto 0) := to_unsigned(10-1,20);
	signal BCD2Seg_8_bit : STD_LOGIC_VECTOR (7 downto 0);
	signal BCD2Seg_4_bit : STD_LOGIC_VECTOR (3 downto 0);
	signal seg_next, seg_reg : STD_LOGIC_VECTOR(7 downto 0);
	signal dsel_reg, dsel_next : unsigned(2 downto 0);
	signal timer_next, timer_reg : unsigned(19 DOWNTO 0);
	signal digit_next, digit_reg : STD_LOGIC_VECTOR(4 downto 0);
	signal dsel_before_next : unsigned(2 downto 0);
	signal en : std_logic;
begin
 process(clk,reset) 
 begin
	if reset = '1' then
		timer_reg <= TCNS;
		digit_reg <="11110";
		dsel_reg <= "100";
		seg_reg <= led_in;
		elsif rising_edge(clk) then 
		timer_reg <= timer_next;
		digit_reg <= digit_next;
		dsel_reg <= dsel_next;
		seg_reg <= seg_next;
	end if;
	end process;
	
	en <= '1' when timer_reg=(0)  else
			'0';
	timer_next <= TCNS when en='1' else
	timer_reg-1 ;
	 
	digit_next <= digit_reg when en='0' else
	digit_reg(3 downto 0)&digit_reg(4) ;
	digit <= digit_reg;
	
	dsel_before_next <= "000" when dsel_reg= "100" else
	dsel_reg+1 ;
	dsel_next <= dsel_before_next when en='1' else
			dsel_reg;
	
						  
	with dsel_reg(1 downto 0) select
	BCD2Seg_4_bit <= d0_in when "00",
						  d1_in when "01",
						  d2_in when "10",
						  d3_in when others;  
					
	with BCD2Seg_4_bit select		
   BCD2Seg_8_bit <=  "11111100" when  "0000",
							"01100000" when  "0001",
							"11011010" when  "0010",
							"11110010" when  others;

		seg_next	<=  led_in when dsel_reg(2)='1' else
					BCD2Seg_8_bit;
	seg<= seg_next;

end Behavioral;
