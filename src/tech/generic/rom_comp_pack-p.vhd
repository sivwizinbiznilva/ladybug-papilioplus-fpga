-------------------------------------------------------------------------------
-- $Id: rom_comp_pack-p.vhd,v 1.1 2006/02/07 00:43:49 arnim Exp $
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package rom_comp_pack is

  component rom_cpu
    port (
      Clk : in  std_logic;
      A   : in  std_logic_vector(14 downto 0);
      D   : out std_logic_vector( 7 downto 0)
    );
  end component;

  component rom_char_l
    port (
      Clk : in  std_logic;
      A   : in  std_logic_vector(11 downto 0);
      D   : out std_logic_vector( 7 downto 0)
    );
  end component;

  component rom_char_u
    port (
      Clk : in  std_logic;
      A   : in  std_logic_vector(11 downto 0);
      D   : out std_logic_vector( 7 downto 0)
    );
  end component;

  component rom_sprite_l
    port (
      Clk : in  std_logic;
      A   : in  std_logic_vector(11 downto 0);
      D   : out std_logic_vector( 7 downto 0)
    );
  end component;

  component rom_sprite_u
    port (
      Clk : in  std_logic;
      A   : in  std_logic_vector(11 downto 0);
      D   : out std_logic_vector( 7 downto 0)
    );
  end component;

end rom_comp_pack;
