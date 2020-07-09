----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    05:53:26 05/09/2018 
-- Design Name: 
-- Module Name:    Top - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top is
    Port ( clk, reset : in  STD_LOGIC;
           seg : out  STD_LOGIC_VECTOR (7 downto 0);
           digit : out  STD_LOGIC_VECTOR (4 downto 0);
			  ao : out std_logic
			  );
end Top;

architecture Behavioral of Top is

COMPONENT delay
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         en : OUT  std_logic
        );
    END COMPONENT;


-----------------------------------------------------------------------------------
		  
COMPONENT display
    PORT(
         d0_in : IN  std_logic_vector(3 downto 0);
         d1_in : IN  std_logic_vector(3 downto 0);
         d2_in : IN  std_logic_vector(3 downto 0);
         d3_in : IN  std_logic_vector(3 downto 0);
         dl_in : IN  std_logic_vector(7 downto 0);
         number: IN  std_logic_vector(3 downto 0);
         radix : IN  std_logic_vector(3 downto 0);
         clk : IN  std_logic;
         reset : IN  std_logic;
         en : IN  std_logic;
         seg : OUT  std_logic_vector(7 downto 0);
         digit : OUT  std_logic_vector(4 downto 0)
        );
    END COMPONENT;
	 
	--Inputs
   signal d0_in : std_logic_vector(3 downto 0) :=  (others => '0');
   signal d1_in : std_logic_vector(3 downto 0) :=  (others => '0');
   signal d2_in : std_logic_vector(3 downto 0) :=  (others => '0');
   signal d3_in : std_logic_vector(3 downto 0) :=  (others => '0');
   signal dl_in : std_logic_vector(7 downto 0) :=  (others => '0');
   signal number: std_logic_vector(3 downto 0) :=  (others => '0');
   signal radix : std_logic_vector(3 downto 0) :=  (others => '0');
	signal en : std_logic := '0';

------------------------------------------------------------------			 
	 
    COMPONENT oclock
    PORT(
         clk : IN  std_logic;
         en : IN  std_logic;
         reset : IN  std_logic;
			d0_in : out  std_logic_vector(3 downto 0);
         d1_in : out std_logic_vector(3 downto 0);
         d2_in : out  std_logic_vector(3 downto 0);
         d3_in : out std_logic_vector(3 downto 0)
        );
    END COMPONENT;
    

    COMPONENT music_gen_note
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         freq : OUT  std_logic_vector(5 downto 0)
        );
    END COMPONENT;
	
    COMPONENT FuncGen
    PORT(
         clk : IN  std_logic;
         reset : IN  std_logic;
         fn : IN  std_logic_vector(1 downto 0);
         freq : IN  std_logic_vector(5 downto 0);
         ao_out : OUT  std_logic_vector(7 downto 0);
         dl : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
	signal fn : std_logic_vector(1 downto 0) := (others => '0');
   signal freq : std_logic_vector(5 downto 0) := (others => '0');

 	--Outputs
   signal ao_out : std_logic_vector(7 downto 0);
   signal dl : std_logic_vector(7 downto 0);

	 
    COMPONENT dac
	 generic ( WordWidth : natural:= 8);
    PORT(
         clk : IN  std_logic;
         rst_n : IN  std_logic;
         di : IN  std_logic_vector(WordWidth-1 downto 0);
         ao : OUT  std_logic
        );
    END COMPONENT;
 --Inputs
   signal rst_n : std_logic := '0';
   signal di : std_logic_vector(7 downto 0) := (others => '0');	 

	
begin

uut1: delay PORT MAP (
          clk => clk,
          reset => reset,
          en => en
        );	  
		  
uut2: display PORT MAP (
          d0_in => d0_in,
          d1_in => d1_in,
          d2_in => d2_in,
          d3_in => d3_in,
          dl_in => dl_in,
          number => number,
          radix => radix,
          clk => clk,
          reset => reset,
          en => en,
          seg => seg,
          digit => digit
        );
		 --   d0_in <= "0000";
       --   d1_in <= "0001";
       --   d2_in <= "0010";
       --   d3_in <= "0100";
       --   dl_in <= "10101010";
		 
uut3: oclock PORT MAP (
          clk => clk,
          en => en,
          reset => reset,
          d0_in => d0_in,
          d1_in => d1_in,
          d2_in => d2_in,
          d3_in => d3_in
        );
		  
 uut4: music_gen_note PORT MAP (
          clk => clk,
          reset => reset,
          freq => freq
        );	
 uut5: FuncGen PORT MAP (
          clk => clk,
          reset => reset,
          fn => fn,
          freq => freq,
          ao_out => ao_out,
          dl => dl
        );		
 uut6: dac PORT MAP (
          clk => clk,
          rst_n => rst_n,
          di => ao_out,
          ao => ao
        );		  
end Behavioral;

