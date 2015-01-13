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

entity image_generator is
  Port ( clk : in  STD_LOGIC;
         rst : in  STD_LOGIC;
         addr : out  STD_LOGIC_VECTOR (18 downto 0);
         write_enable : out  STD_LOGIC;
         data : out  STD_LOGIC);
end image_generator;

architecture Behavioral of image_generator is

begin

  process(clk,rst)
    constant x_max : positive := 639;
    constant y_max : positive := 479;
    variable x_write : natural range 0 to x_max := 0;
    variable y_write : natural range 0 to y_max := 0;
    variable address : natural range 0 to 307199 := 0;
  begin
    if rst = '1' then
      write_enable <= '0';
      addr <= (others => '0');
      data <= '0';		
    elsif rising_edge(clk) then
      if std_logic_vector(to_unsigned(x_write,3)) = "000" or std_logic_vector(to_unsigned(y_write,3)) = "000" then
        write_enable <= '1';
        addr <= std_logic_vector(to_unsigned(address,19));
        data <= '1';
      else
        write_enable <= '0';
        addr <= (others => '0');
        data <= '0';
      end if;

      -- Address management 
      if address /= 307199 then
        address := address + 1;
      else
        address := 0;
      end if; -- addr max
      -- Coordinate management
      if x_write /= x_max then
        x_write := x_write + 1;
      else --xmax
        x_write := 0;
        if y_write /= y_max then
          y_write := y_write + 1;
        else
          y_write := 0;
        end if;	--ymax
      end if; -- xmax
    end if;-- clock rising edge
  end process;

end Behavioral;

