----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    04:34:49 05/09/2018 
-- Design Name: 
-- Module Name:    delay - Behavioral 
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

entity delay is
	Port ( clk, reset : in  STD_LOGIC;
			 --p1			: OUT STD_LOGIC_VECTOR(15 downto 0);
          en         : out STD_LOGIC );
end delay;

architecture Behavioral of delay is

constant m : natural := 40000;
	signal zero_p : std_logic;
	signal r_reg  : unsigned(15 downto 0);
	signal r_next : unsigned(15 downto 0);
begin

	-- register
process(clk,reset)
	begin
    if (reset = '1') then
        r_reg <= to_unsigned(m-1,16);
    elsif (clk'event and clk = '1') then 
			r_reg <= r_next;
    end if;
end process;

-- next stage logic
zero_p <= '1' when r_reg = 0 else 
			 '0';

--output logic
r_next <= to_unsigned(m-1,16) when zero_p = '1' else
			 r_reg - 1;
			 
--p1 <= std_logic_vector(r_reg);			 
										
en <= zero_p;

end Behavioral;





