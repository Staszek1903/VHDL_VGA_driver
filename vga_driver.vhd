----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    23:16:58 09/03/2019 
-- Design Name: 
-- Module Name:    vga_driver - Behavioral 
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


-- refresh 60Hz

-- 			screen		alternative time
-- line		31.5kHz		same							
-- pix		25.2MHz		20.141MHz
-- res		640x480		512x384		25.42us x 15.25ms
-- full		800x525     640x420		31.78us x 16.68ms
-- HFP		16				10.24			0.636us
-- HS			96				61.44			3.813us
-- HBP		48				30.72			1.906us
-- VFP		10				(8		)		0.317ms
-- VS			2				(1.6	)		0.063ms
-- VBP		33			 	(26.4	)		1.048ms	
-- * () - not used

-- ALTERNATIVE RESOLUTION(that works) : 512x480

-- ALWAYS CHECK CLOCK FREQUENCY !!!!

entity vga_driver is port ( 
	clk : in  STD_LOGIC;
	x : out  unsigned (9 downto 0);
	y : out  unsigned (8 downto 0);
	sblock : out std_logic := '0';
	hsync : out  STD_LOGIC := '1';
	vsync : out  STD_LOGIC := '1'
	);
end vga_driver;

architecture Behavioral of vga_driver is
	signal horizontal : unsigned (9 downto 0) := (others=>'0');
	signal vertical : unsigned (8 downto 0) := (others=>'0');
	
	constant row 	 	: integer := 800;
	constant column 	: integer := 525;
	constant pixels 	: integer := 640;
	constant lines 	: integer := 480;
	constant HFP		: integer := 16;
	constant HS 		: integer := 61;
	constant VFP		: integer := 10;
	constant VS			: integer := 2;
begin
	process (clk)
	begin
		if rising_edge(clk) then
			if horizontal = (row - 1) then
				horizontal <= (others => '0');
				if vertical = (column - 1) then
					vertical <= (others => '0');
				else
					vertical <= vertical + 1;
				end if;
			else
				horizontal <= horizontal +1;
			end if;
		end if;
	end process;
	
	hsync <= '0' when horizontal > (pixels + HFP) and horizontal < (pixels + HFP + HS + 1) else '1';
	vsync <= '0' when vertical > (lines + VFP) and vertical < (lines + VFP + VS + 1) else '1';
	
	sblock <= '0' when horizontal < pixels and vertical < lines else '1';
	
	x <= horizontal;
	y <= vertical;

end Behavioral;

