
-- VHDL Instantiation Created from source file vga_driver.vhd -- 22:36:26 09/03/2019
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

	COMPONENT vga_driver
	PORT(
		clk : IN std_logic;          
		x : OUT std_logic_vector(9 downto 0);
		y : OUT std_logic_vector(8 downto 0);
		sblock : OUT std_logic;
		hsync : OUT std_logic;
		vsync : OUT std_logic
		);
	END COMPONENT;

	Inst_vga_driver: vga_driver PORT MAP(
		clk => ,
		x => ,
		y => ,
		sblock => ,
		hsync => ,
		vsync => 
	);


