--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   10:56:34 09/07/2019
-- Design Name:   
-- Module Name:   D:/xilinx_projects/vga_driver/vga_test.vhd
-- Project Name:  vga_driver
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: vga_driver
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
USE ieee.numeric_std.ALL;
 
ENTITY vga_test IS
END vga_test;
 
ARCHITECTURE behavior OF vga_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT vga_driver
    PORT(
         clk : IN  std_logic;
         x : OUT  unsigned(9 downto 0);
         y : OUT  unsigned(8 downto 0);
         sblock : OUT  std_logic;
         hsync : OUT  std_logic;
         vsync : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';

 	--Outputs
   signal x : unsigned(9 downto 0);
   signal y : unsigned(8 downto 0);
   signal sblock : std_logic;
   signal hsync : std_logic;
   signal vsync : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: vga_driver PORT MAP (
          clk => clk,
          x => x,
          y => y,
          sblock => sblock,
          hsync => hsync,
          vsync => vsync
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
