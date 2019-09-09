----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:25:41 09/02/2019 
-- Design Name: 
-- Module Name:    display_driver - Behavioral 
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

entity display_driver is
	port(
		segment : out std_logic_vector( 7 downto 0);
		enable : out std_logic_vector( 2 downto 0);
		
		clk : in std_logic;
		seg0 : in std_logic_vector (4 downto 0);
		seg1 : in std_logic_vector (4 downto 0);
		seg2 : in std_logic_vector (4 downto 0)
		);
end display_driver;

architecture Behavioral of display_driver is

	constant timer_limit : integer := 10000;
	signal timer_counter : integer range 0 to 10001 := 0;
	signal seg_num : integer range 0 to 2 :=0;
	signal current_seg : std_logic_vector (4 downto 0);
	signal inv_segment : std_logic_vector (7 downto 0);
	
begin
	process (clk)
	begin
		if rising_edge(clk) then
			if timer_counter = timer_limit then
				timer_counter <= 0;
				if seg_num = 2 then
					seg_num <= 0;
				else
					seg_num <= seg_num + 1;
				end if;
			else
				timer_counter <= timer_counter + 1;
			end if;
		end if;
	end process;
	
	with seg_num select
	current_seg <= seg0 when 0,
						seg1 when 1,
						seg2 when 2,
						"00000" when others;
	with seg_num select
	enable <= "110" when 0,
				 "101" when 1,
				 "011" when 2,
				 "111" when others;
						
	with current_seg select
	inv_segment <= "00111111" when "00000",
						"00000110" when "00001",
						"01011011" when "00010",
						"01001111" when "00011",
						"01100110" when "00100",
						"01101101" when "00101",
						"01111101" when "00110",
						"00000111" when "00111",
						"01111111" when "01000",
						"01101111" when "01001",
						"01110111" when "01010",
						"01111100" when "01011",
						"00111001" when "01100",
						"01011110" when "01101",
						"01111001" when "01110",
						"01110001" when "01111",
						"00111101" when "10000",
						"01110110" when "10001",
						"00000100" when "10010",
						"10000100" when "10011",
						"01110000" when "10100",
						"00001110" when "10101",
						"00110111" when "10110",
						"01010100" when "10111",
						"01011100" when "11000",
						"01110011" when "11001",
						"11011100" when "11010",
						"01010000" when "11011",
						"01101101" when "11100",
						"01000100" when "11101",
						"00011100" when "11110",
						"00111110" when "11111",
						"00000000" when others;
	
	segment <= not inv_segment;

end Behavioral;