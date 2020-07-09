----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:34:43 05/29/2018 
-- Design Name: 
-- Module Name:    music_gen_note - Behavioral 
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
use ieee.numeric_std.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned valuesuse IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity music_gen_note is
	PORT (clk,reset: IN std_logic;
	      freq : out std_logic_vector(5 downto 0)
		  );
end music_gen_note;

architecture Behavioral of music_gen_note is
constant num_max : integer := 10000000-1;
signal note_clk_next, note_clk_reg : unsigned(23 downto 0);
signal note_next, note_reg, bef_note :unsigned (5 downto 0);
signal en_note : std_logic;
signal music : std_logic_vector(5 downto 0);

type mem is array(0 to 30) of integer range 0 to 36;
constant keep_music : mem :=( 35, 33, 31, 29, 27, 25, 23,	21, 20, 18, 17, 15, 14,	12, 11, 10, 9,	7,	6,	6,	5,	4,	3,	2,	2,	1,	1,	1,	0,	0,	0);
	
	
begin
	process(clk,reset)
	begin
		if (reset='1') then
			note_clk_reg <= (others =>'0');
			note_reg		 <= (others =>'0');
		elsif rising_edge(clk) then
			note_clk_reg <= note_clk_next;
			note_reg 	 <= note_next;
	end if;
end process;
---------------------------------------------------------------------------------
 note_clk_next <= (others =>'0') when en_note ='1' else
						note_clk_reg+1;
 en_note 		<= '1' when note_clk_reg= num_max else
						'0';
--------------------------------------------------------------------------------
note_next <= bef_note when en_note= '1' else
					note_reg;
bef_note <= (others =>'0') when note_reg = 99 else
					note_reg+1;
				

music <= std_logic_vector(to_unsigned(keep_music(to_integer(note_reg)),6));

end Behavioral;

