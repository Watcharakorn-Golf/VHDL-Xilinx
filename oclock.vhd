----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    06:51:46 05/29/2018 
-- Design Name: 
-- Module Name:    oclock - Behavioral 
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


----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity oclock is
    Port ( clk, en, reset : in  STD_LOGIC;
			d0_in : out  std_logic_vector(3 downto 0);
         d1_in : out std_logic_vector(3 downto 0);
         d2_in : out  std_logic_vector(3 downto 0);
         d3_in : out std_logic_vector(3 downto 0)
	 );
end oclock;

architecture Behavioral of oclock is

constant max : unsigned := to_unsigned(4000000-1,22);
constant check_d0, check_d1: integer := 10;
constant check_d2 : integer := 6;
constant check_d3 : integer := 16;
signal bef_ds : std_logic;
signal ds	: std_logic;
signal ds_next, ds_reg: unsigned (21 downto 0);
signal d0_next,d0_reg : unsigned (3 downto 0);
signal d1_next,d1_reg : unsigned (3 downto 0);
signal d2_next,d2_reg : unsigned (3 downto 0);
signal d3_next,d3_reg : unsigned (3 downto 0);
signal bef_d0_next 	 : unsigned (3 downto 0);
signal bef_d1_next 	 : unsigned (3 downto 0);
signal bef_d2_next 	 : unsigned (3 downto 0);
signal bef_d3_next 	 : unsigned (3 downto 0);
signal d0, d1, d2, d3 : std_logic_vector (3 downto 0);


begin
	-- register
process(clk,reset) -- ds, d0, d1, d2, d3
	begin
    if (reset = '1') then
        ds_reg <= max ;
		  d0_reg <= "0000";
		  d1_reg <= "0000";
		  d2_reg <= "0000";
		  d3_reg <= "0000";
    elsif rising_edge(clk) then 
			ds_reg <= ds_next;
			d0_reg <= d0_next;
			d1_reg <= d1_next;
			d2_reg <= d2_next;
			d3_reg <= d3_next;
    end if;
end process;
----------------------------------------------------------------------------
-- next stage logic ds
bef_ds <= '1' when ds_reg = 0 else 
				'0';

--output logic ds
ds_next <= max when bef_ds = '1' else
			 ds_reg - 1;					
ds <= bef_ds;

-----------------------------------------------------------------------------
-- next stage logic d0
bef_d0_next <= "0000" when d0_reg = 9 else
					d0_reg+1;

--output logic d0
d0_next <= bef_d0_next when ds = '1' else 
				d0_reg ;

d0 <= std_logic_vector(d0_reg);
d0_in <= d0;
---------------------------------------------------------------------------
-- next stage logic d1
bef_d1_next <= "0000" when d1_reg = 9 else 
				d1_reg+1;

--output logic d1
d1_next <= bef_d1_next when (d0 = 9 and ds = '1') else
			 d1_reg;					
d1 <= std_logic_vector(d1_reg);
d1_in <= d1;
-------------------------------------------------------------------------------------
-- next stage logic d2
bef_d2_next <= "0000" when d2_reg = 5 else 
				d2_reg+1;

--output logic d2
d2_next <= bef_d2_next when (d1 = 9 and d0 = 9 and ds = '1') else
			 d2_reg;					
d2 <= std_logic_vector(d2_reg);
d2_in <= d2;
----------------------------------------------------------------------------

-- next stage logic d3
bef_d3_next <= "0000" when d3_reg = 15 else 
				d3_reg+1;

--output logic d3
d3_next <= bef_d3_next when (d2 = 5 and d1 = 9 and d0 = 9 and ds = '1')  else
				d3_reg;					
d3 <= std_logic_vector(d3_reg);
d3_in <= d3;




end Behavioral;

			
