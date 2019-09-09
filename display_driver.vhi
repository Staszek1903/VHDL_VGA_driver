
-- VHDL Instantiation Created from source file display_driver.vhd -- 19:45:04 09/08/2019
--
-- Notes: 
-- 1) This instantiation template has been automatically generated using types
-- std_logic and std_logic_vector for the ports of the instantiated module
-- 2) To use this template to instantiate this entity, cut-and-paste and then edit

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

	Inst_display_driver: display_driver PORT MAP(
		segment => ,
		enable => ,
		clk => ,
		seg0 => ,
		seg1 => ,
		seg2 => 
	);


