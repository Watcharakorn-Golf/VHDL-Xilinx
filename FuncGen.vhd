----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:47:59 05/08/2017 
-- Design Name: 
-- Module Name:    FuncGen - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FuncGen is
    Port ( clk, reset : in  STD_LOGIC;
           fn : in  STD_LOGIC_VECTOR (1 downto 0);
           --freq : in  STD_LOGIC_VECTOR (2 downto 0); -- comment for using only 8 pitch
			  freq : in  STD_LOGIC_VECTOR (5 downto 0);
           ao_out : out  STD_LOGIC_VECTOR (7 downto 0);
           dl : out  STD_LOGIC_VECTOR (7 downto 0));
end FuncGen;

architecture Behavioral of FuncGen is

--signal register
signal count_freq_reg, count_freq_next : unsigned(13 downto 0);
signal count_up_reg, count_up_next : unsigned(7 downto 0);
signal count_down_reg, count_down_next : unsigned(7 downto 0);
signal updown_reg, updown_next : std_logic_vector(1 downto 0);

signal freq_in: unsigned(13 downto 0);
signal wave_en, seq_en: std_logic;
--signal shift: std_logic_vector(1 downto 0) := "01";
signal num, num1: unsigned(7 downto 0);

type mem is array(0 to 127) of integer range 0 to 255;
constant memdata : mem := (254, 254, 254, 254, 253, 253,	253, 252, 252,
	251, 250, 249,	249, 248, 247, 245, 244, 243, 242, 240, 239, 238, 236, 234,	233,
	231, 229, 227,	225, 223, 221,	219, 217, 215,	212, 210, 208,	205, 203, 200, 198,	
	195, 192, 190,	187, 184, 181,	179, 176, 173,	170, 167, 164,	161, 158, 155,	152,	
	149, 146, 143,	140, 136, 133,	130, 127, 124,	121, 118, 115,	112, 108, 105,	102,
	99, 96, 93,	90, 87, 84,	81, 79, 76,	73, 70, 67,	65, 62, 59,	57, 54, 51, 49, 47, 44, 42, 40, 37, 35, 
	33, 31, 29,	27, 25, 23,	21, 20, 18, 17, 15, 14,	12, 11, 10, 9,	7,	6,	6,	5,	4,	3,	2,	2,	1,	1,	1,	0,	0,	0);
	
	
signal ao_sine, ao_tri, ao_sq, ao_rand, ao_out_temp : std_logic_vector(7 downto 0);	

signal count_up_mux, count_down_mux: unsigned(7 downto 0);

signal r_reg,r_next : std_logic_vector(7 downto 0);
signal fb: std_logic;
constant seed : std_logic_vector(7 downto 0) := "00000001";

begin

--register 
process(clk, reset)
begin
	if (reset = '1') then
		count_freq_reg <= (others => '0');
		count_up_reg <= (others => '0');
		count_down_reg <= (others => '0');
		updown_reg <= "01";
	elsif (clk'event and clk = '1' ) then
		count_freq_reg <= count_freq_next;
		count_up_reg <= count_up_next;
		count_down_reg <= count_down_next;
		updown_reg <= updown_next;
	end if;
end process;
-- chnage freq to more than 3 octave 
with freq select -- freqmust be 6 bits
	 freq_in <= to_unsigned(1199,14) when "000000", --C3 0 
					to_unsigned(1131,14) when "000001", --C#3 1
					to_unsigned(1068,14) when "000010", --D3 2
					to_unsigned(1008,14) when "000011", --D#3 3
					to_unsigned(951,14) when "000100", --E3 4
					to_unsigned(898,14) when "000101", --F3 5
					to_unsigned(847,14) when "000110", --F#3 6
					to_unsigned(800,14) when "000111", --G3 7
					to_unsigned(755,14) when "001000", --G#3 8
					to_unsigned(713,14) when "001001", --A3 9
					to_unsigned(671,14) when "001010", --A#3 10
					to_unsigned(635,14) when "001011", --B3 11
					to_unsigned(599,14) when "001100", --C4 12
					to_unsigned(565,14) when "001101", --C#4 13
					to_unsigned(534,14) when "001110", --D4 14
					to_unsigned(504,14) when "001111", --D#4 15
					to_unsigned(475,14) when "010000", --E4 16
					to_unsigned(450,14) when "010001", --F4 17 
					to_unsigned(423,14) when "010010", --F#4 18
					to_unsigned(400,14) when "010011", --G4 19
					to_unsigned(377,14) when "010100", --G#4 20
					to_unsigned(356,14) when "010101", --A4 21
					to_unsigned(336,14) when "010110", --A#4 22
					to_unsigned(317,14) when "010111", --B4 23
					to_unsigned(299,14) when "011000", --C5 24
					to_unsigned(282,14) when "011001", --C#5 25
					to_unsigned(267,14) when "011010", --D5 26
					to_unsigned(252,14) when "011011", --D#5 27
					to_unsigned(237,14) when "011100", --E5 28
					to_unsigned(224,14) when "011101", --F5 29 
					to_unsigned(211,14) when "011110", --F#5 30
					to_unsigned(200,14) when "011111", --G5 31 
					to_unsigned(188,14) when "100001", --G#5 32
					to_unsigned(178,14) when "100010", --A5 33
					to_unsigned(168,14) when "100011", --A#5 34
					to_unsigned(158,14) when "100100", --B5 35
					to_unsigned(15686,14) when others; --B5 35
					
count_freq_next <= freq_in when count_freq_reg = 0 else 
						 count_freq_reg - 1;

wave_en <= '1' when count_freq_reg = 1 else 
			  '0';

count_up_mux <= "00000000" when count_up_reg = 127 else 	
					 count_up_reg + 1;

count_down_mux <= to_unsigned(127,8) when count_down_reg = 0 else 	
						count_down_reg - 1;

count_up_next <= count_up_mux when wave_en = '1' else 
					  count_up_reg;

count_down_next <= count_down_mux when wave_en = '1' else 	
						 count_down_reg;

seq_en <= '1' when count_down_reg = 1 else 
			 '0';


updown_next <= updown_reg(0) & updown_reg(1) when seq_en = '1' and wave_en = '1' else 	
					updown_reg; 
					
num1 <=  count_up_next when updown_reg(0) = '0' else
        count_down_next;		
		  
num <= to_unsigned(127,8) when num1 = to_unsigned(0,8) and updown_reg = "01" else
		 num1; 


-- for sine wave 
ao_sine <= std_logic_vector(to_signed(memdata(to_integer(num)),8));

-- for triangular wave 
ao_tri <= std_logic_vector(num+num);

-- for square wave
ao_sq <= "11111111" when updown_reg(0) = '0' else
			"00000000";

with fn select 
	ao_out <= ao_sine when "00",
						ao_tri  when "01",
						ao_sq   when "10",
						ao_rand when others;
			

			
--lfsr

process(clk, reset, wave_en)
begin
	if (reset = '0') then
		r_reg <= seed;
	elsif (clk'event and clk = '1' and wave_en = '1') then
		r_reg <= r_next;
	end if;
end process;

fb <= r_reg(1) xor r_reg(0);
r_next <= fb & r_reg(7 downto 1);

ao_rand <= r_next;


end Behavioral;


