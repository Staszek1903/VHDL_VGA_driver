----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:03:40 09/06/2019 
-- Design Name: 
-- Module Name:    pixel_gen - Behavioral 
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

entity pixel_gen is port (
   clk : in std_logic;
	x : in unsigned (9 downto 0);
	y : in unsigned (8 downto 0);
	sblock : in std_logic;
	button : in std_logic_vector ( 5 downto 0 );
	slider : in std_logic_vector ( 7 downto 0 );
	
	red : out std_logic_vector( 2 downto 0 );
	green : out std_logic_vector( 2 downto 0 );
	blue : out std_logic_vector( 1 downto 0 );
	seg1, seg2, seg3 : out std_logic_vector( 4 downto 0 );
	led : out std_logic_vector( 7 downto 0 )
);
end pixel_gen;
	
architecture Behavioral of pixel_gen is
	COMPONENT graphic_ram
	  PORT (
		clka : IN STD_LOGIC;
		wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
		addra : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
		dina : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		clkb : IN STD_LOGIC;
		addrb : IN STD_LOGIC_VECTOR(13 DOWNTO 0);
		doutb : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	  );
	 END COMPONENT;
	
	signal temp_x 	: unsigned ( 9 downto 0 );
	signal mem_x 	: unsigned ( 6 downto 0 );
	signal mem_y 	: unsigned ( 6 downto 0 );
	signal is_in_mem_space : std_logic;
	
	signal cursor_x : integer range 0 to 127 := 10;
	signal cursor_y : integer range 0 to 119 := 10;
	
	signal adra, adrb : unsigned ( 13 downto 0 );
	signal data_out : std_logic_vector (2 downto 0);
	signal data_in : std_logic_vector (2 downto 0) := "000";
	signal wr_en : std_logic := '0';
	
	signal cursor_masked, mem_masked, screen_masked : std_logic_vector ( 7 downto 0 );
--	signal temp_r, temp_g : std_logic_vector (2 downto 0);
--	signal temp_b : std_logic_vector (1 downto 0);
	
	signal mode : integer range 0 to 8 := 0;
--	signal new_color : std_logic_vector ( 7 downto 0 );
--	signal pallete_preview, pallete_out : std_logic_vector ( 7 downto 0 );
--	signal pallete_prev_adr, pallete_adr : std_logic_vector ( 2 downto 0 );
--	signal pallete_wr_en : std_logic := '0';

	type array_8_8 is array (0 to 7) of std_logic_vector(7 downto 0);
	signal pallete : array_8_8 := (0 => "00000000",
											 1 => "00000011",
											 2 => "00011100",
											 3 => "00011111",
											 4 => "11100000",
											 5 => "11100011",
											 6 => "11111100",
											 7 => "11111111");
	
begin
	led <= pallete( mode -1 );
	
	temp_x <= x-64; -- przesuniêcie ka¿dej lini o 64 piksele w prawo
	is_in_mem_space <= not std_logic(temp_x(9)); -- ostatni bit wskazuje ze rysujemy poza obszarem objetym przez pamiec
	mem_x <= temp_x(8 downto 2);	-- przeskalowanie na 128 pikseli w lini
	mem_y <= y( 8 downto 2 );	-- przeskalowanie na 120 ( tak 120 nie 128 bo (480<<4 = 120)) lini w ekranie
	adrb <=  mem_y & mem_x;
	
	g_ram : graphic_ram
	PORT MAP (
	 clka => clk,
	 wea(0) => wr_en,
	 addra =>  std_logic_vector(adra),
	 dina => data_in,
	 clkb => not clk,
	 addrb =>  std_logic_vector(adrb),
	 doutb => data_out
	);
	
--	new_color <= slider;
--	led <= pallete_preview;
--	pallete_adr <= data_out;
--	pallete_prev_adr <= std_logic_vector(to_unsigned(mode,3) -1); 
	
	seg1 <= "01101" when mode = 0 else "10010";
	seg2 <= "11011" when mode = 0 else "10111";
	seg3 <= "11000" when mode = 0 else std_logic_vector(to_unsigned(mode, 5));
	
--	temp_r <= "111" when data_out(2) = '1' else "000";
--	temp_g <= "111" when data_out(1) = '1' else "000";
--	temp_b <= "11"  when data_out(0) = '1' else "00";
	
	cursor_masked <= "10011110" when cursor_x = mem_x and cursor_y = mem_y else pallete(to_integer(unsigned(data_out))); --(temp_r & temp_g & temp_b);
	mem_masked <= "00000111" when is_in_mem_space = '0' else cursor_masked;
	screen_masked <= "00000000" when sblock = '1' else mem_masked;
	
	red 	<= screen_masked(7 downto 5);
	green <= screen_masked(4 downto 2);
	blue 	<= screen_masked(1 downto 0);
	
	adra <=  to_unsigned(cursor_y,7) & to_unsigned(cursor_x,7);

	process (clk)
		--variable last_state : std_logic_vector ( 5 downto 0 ) := "000000";
		variable counter : integer range 0 to 5000001 := 0;
	begin
		if falling_edge(clk) then
			if counter = 5000000 then
				counter := 0;
			else
				counter := counter + 1;
			end if;
			
			if counter = 0 then 
				if button(0) = '0' then -- and last_state(0) = '0' then
					if mode = 0 then
						data_in <= not slider(2 downto 0);
						wr_en <= '1';
					else
						pallete(mode - 1) <= not slider(7 downto 0);
					end if;
				else
					wr_en <= '0';
				end if;
				
				if button(1) = '0' then -- and last_state(1) = '0' then
					if mode = 8 then
						mode <= 0;
					else
						mode <= mode + 1;
					end if;
				end if;
				
				if button(2) = '0' then -- and last_state(2) = '0' then
					 cursor_y <= cursor_y - 1;
				end if;
				
				if button(3) = '0' then -- and last_state(3) = '0' then
					cursor_x <= cursor_x + 1;
				end if;
				
				if button(4) = '0' then --  and last_state(4) = '0' then
					cursor_y <= cursor_y + 1;
				end if;
				
				if button(5) = '0' then -- and last_state(5) = '0' then
					cursor_x <= cursor_x - 1;
				end if;
			end if;
			 --last_state := button;
			
		end if;
	end process;
	

end Behavioral;

