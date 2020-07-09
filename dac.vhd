----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:56:30 05/29/2018 
-- Design Name: 
-- Module Name:    dac - Behavioral 
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

entity dac is
  
  generic (
    WordWidth : natural := 8);

  port (
    clk, rst_n : in  std_logic;
    di         : in  std_logic_vector(WordWidth-1 downto 0);
    ao         : out std_logic);

end entity dac;

architecture beh of dac is
  signal ao_reg, ao_next : std_logic;
  signal sigma_reg, sigma_next : unsigned(WordWidth+1 downto 0);
  signal sigma_s : unsigned(WordWidth+1 downto 0);
  signal delta_s, delta_b : unsigned(WordWidth+1 downto 0);
begin  -- architecture beh
  delta_b(WordWidth+1 downto WordWidth) <= sigma_reg(WordWidth+1)&sigma_reg(WordWidth+1);
  delta_b(WordWidth-1 downto 0) <= (others => '0');
  delta_s <= unsigned(di) + delta_b;
  sigma_s <= delta_s + sigma_reg;

  process (clk, rst_n) is
  begin  -- process
    if rst_n = '1' then                 -- asynchronous reset (active low)
      sigma_reg(WordWidth+1 downto WordWidth) <= "01";
      sigma_reg(WordWidth-1 downto 0) <= (others => '0');
      ao_reg <= '0';
    elsif clk'event and clk = '1' then  -- rising clock edge
      sigma_reg <= sigma_next;
      ao_reg <= ao_next;
    end if;
  end process;
  sigma_next <= sigma_s;
  ao_next <= sigma_reg(WordWidth+1);
  --
  ao <= ao_reg;

end architecture beh;


