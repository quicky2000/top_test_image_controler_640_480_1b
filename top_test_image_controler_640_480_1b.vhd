--
--    This file is part of top_test_image_controler_640_480_1b
--    Copyright (C) 2011  Julien Thevenon ( julien_thevenon at yahoo.fr )
--
--    This program is free software: you can redistribute it and/or modify
--    it under the terms of the GNU General Public License as published by
--    the Free Software Foundation, either version 3 of the License, or
--    (at your option) any later version.
--
--    This program is distributed in the hope that it will be useful,
--    but WITHOUT ANY WARRANTY; without even the implied warranty of
--    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--    GNU General Public License for more details.
--
--    You should have received a copy of the GNU General Public License
--    along with this program.  If not, see <http://www.gnu.org/licenses/>
--
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_test_image_controler_640_480_1b is
  Port ( clk : in  STD_LOGIC;
         w1a : inout  STD_LOGIC_VECTOR (15 downto 0);
         w1b : inout  STD_LOGIC_VECTOR (15 downto 0);
         w2c : inout  STD_LOGIC_VECTOR (15 downto 0);
         rx : in  STD_LOGIC;
         tx : inout  STD_LOGIC);
end top_test_image_controler_640_480_1b;

architecture Behavioral of top_test_image_controler_640_480_1b is
  COMPONENT clock_25mhz
    PORT(
      CLKIN_IN : IN std_logic;          
      CLKFX_OUT : OUT std_logic;
      CLKIN_IBUFG_OUT : OUT std_logic;
      CLK0_OUT : OUT std_logic
      );
  END COMPONENT;

  signal clk_25mhz : std_logic;
  signal reset : std_logic;
  signal vsync : std_logic;
  signal hsync : std_logic;
  signal enable : std_logic;
  signal screen_right_left : std_logic;
  signal screen_up_down : std_logic;
  signal r : std_logic_vector ( 5 downto 0);
  signal g : std_logic_vector ( 5 downto 0);
  signal b : std_logic_vector ( 5 downto 0);
  signal audio_right : std_logic;
  signal audio_left : std_logic;
  signal x_out : std_logic_vector( 9 downto 0);
  signal y_out : std_logic_vector( 8 downto 0);
  signal vsync_ok : std_logic;
  signal hsync_ok : std_logic;
  signal enable_ok : std_logic;

  -- Signals to write in screen memory
  signal addr : std_logic_vector(18 downto 0) := (others => '0');
  signal data_in : std_logic;
  signal write_enable : std_logic;

begin

  Inst_clock_25mhz: clock_25mhz PORT MAP(
    CLKIN_IN => clk,
    CLKFX_OUT => clk_25mhz,
    CLKIN_IBUFG_OUT => open,
    CLK0_OUT => open
    );
  
  Inst_giovanni_card : entity work.giovanni_card PORT MAP(
    w1a => w1a,
    w1b => w1b,
    scr_red => r,
    scr_green => g,
    scr_blue => b,
    scr_clk => clk_25mhz,
    scr_hsync => hsync_ok,
    scr_vsync => vsync_ok,
    scr_enable => enable_ok,
    scr_right_left => screen_right_left,
    scr_up_down => screen_up_down,
    audio_right => audio_right,
    audio_left => audio_left,
    audio_stereo_ok => open,
    audio_plugged => open,
    io => open
    );
  
  Inst_driver_sharp : entity work.driver_sharp PORT MAP(
    clk => clk_25mhz,
    rst => reset,
    vsync => vsync,
    hsync => hsync,
    enable => enable,
    x_out => x_out,
    y_out => y_out
    );
  
  inst_image_controler : entity work.image_controler PORT MAP(
    clk => clk_25mhz,
    rst => reset,
    r => r,
    g => g,
    b => b,
    x => x_out,
    y => y_out,
    hsync_in => hsync,
    vsync_in => vsync,
    enable_in => enable,
    
    write_enable => write_enable,
    write_addr => addr,
    data_in => data_in,

    
    hsync_out => hsync_ok,
    vsync_out => vsync_ok,
    enable_out => enable_ok
    );

  inst_image_generator : entity work.image_generator
    port map (
      clk => clk_25mhz,
      rst => reset,
      write_enable => write_enable,
      data => data_in,
      addr => addr);
  
  reset <= '0';
  screen_right_left <= '1';
  screen_up_down <= '1';
  audio_right <= '0';
  audio_left <= '0';

end Behavioral;

