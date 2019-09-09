----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    20:51:32 09/01/2019 
-- Design Name: 
-- Module Name:    top_level - Behavioral 
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

entity top_level is port(
		segment : out std_logic_vector( 7 downto 0 );
		enable : out std_logic_vector( 2 downto 0 );
		led : out std_logic_vector ( 7 downto 0 );
		vga_connector : out std_logic_vector ( 9 downto 0 ); -- 9,8,7 :red, 6,5,4 : green, 3,2 :blue, hsync, vsync
		
	   button : in std_logic_vector ( 5 downto 0 );
		slider : in std_logic_vector ( 7 downto 0 );
		clk : in std_logic
		
	);
end top_level;

architecture Behavioral of top_level is

	COMPONENT clocking_pll
	PORT(
		CLKIN_IN : IN std_logic;         
		CLKFX_OUT : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT vga_driver
	PORT(
		clk : IN std_logic;          
		x : OUT unsigned(9 downto 0);
		y : OUT unsigned(8 downto 0);
		sblock : OUT std_logic;
		hsync : OUT std_logic;
		vsync : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT pixel_gen
	PORT(
		clk : IN std_logic;
		x : IN unsigned(9 downto 0);
		y : IN unsigned(8 downto 0);
		sblock : IN std_logic;      
		button : in std_logic_vector ( 5 downto 0 );
		slider : in std_logic_vector ( 7 downto 0 );
		red : OUT std_logic_vector(2 downto 0);
		green : OUT std_logic_vector(2 downto 0);
		blue : OUT std_logic_vector(1 downto 0);
		seg1, seg2, seg3 : out std_logic_vector( 4 downto 0 );
		led : out std_logic_vector( 7 downto 0 )
		);
	END COMPONENT;
	
	COMPONENT display_driver
	PORT(
		clk : IN std_logic;
		seg0 : IN std_logic_vector(4 downto 0);
		seg1 : IN std_logic_vector(4 downto 0);
		seg2 : IN std_logic_vector(4 downto 0);          
		segment : OUT std_logic_vector(7 downto 0);
		enable : OUT std_logic_vector(2 downto 0)
		);
	END COMPONENT;
	
	signal clk_pll : std_logic;
	signal temp_x : unsigned(9 downto 0);
	signal temp_y : unsigned(8 downto 0);
	signal sblock : std_logic;
	
	signal seg1, seg2, seg3 : std_logic_vector ( 4 downto 0 );
	
begin


Inst_clocking_pll: clocking_pll PORT MAP(
clk, clk_pll 
);


Inst_vga_driver: vga_driver PORT MAP(
	clk_pll,
	temp_x,
	temp_y,
	sblock,  
	vga_connector (1),
	vga_connector (0)
);



Inst_pixel_gen: pixel_gen PORT MAP(
		clk_pll,
		temp_x,
		temp_y,
		sblock,
		button,
		slider,
		vga_connector (9 downto 7),
		vga_connector (6 downto 4),
		vga_connector (3 downto 2),
		seg1,
		seg2,
		seg3,
		led
	);
	
Inst_display_driver: display_driver PORT MAP(
		segment => segment,
		enable => enable,
		clk => clk_pll,
		seg0 => seg3,
		seg1 => seg2,
		seg2 => seg1
	);
	
-- scotch mesh
--vga_connector (9 downto 7) <= std_logic_vector( temp_x (4 downto 2) ) when sblock = '0' else "000";
--vga_connector (6 downto 4) <= std_logic_vector( temp_y (4 downto 2) ) when sblock = '0' else "000";
--vga_connector (3 downto 2) <= "00";

-- red blue magenta squares;
--vga_connector (9 downto 7) <= "111" when temp_x > 100 and temp_x < 200 and temp_y > 100 and temp_y < 200 else "000";
--vga_connector (6 downto 4) <= "000";
--vga_connector (3 downto 2) <= "11" when temp_x > 150 and temp_x < 250 and temp_y > 150 and temp_y < 250 else "00";

-- full screen cyan
--vga_connector (9 downto 7) <= "000";
--vga_connector (6 downto 4) <= "000" when sblock = '1' else "111";
--vga_connector (3 downto 2) <= "00" when sblock = '1' else "11";

-- pll check
--vga_connector(9 downto 2) <= (others=>'0');
--vga_connector(1) <= clk_pll;
--vga_connector(0) <= not clk_pll;

end Behavioral;

