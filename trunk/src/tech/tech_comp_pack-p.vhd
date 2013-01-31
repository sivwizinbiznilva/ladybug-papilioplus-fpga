-------------------------------------------------------------------------------
-- $Id: tech_comp_pack-p.vhd,v 1.2 2005/11/12 10:24:23 arnim Exp $
--
-- Copyright (c) 2005, Arnim Laeuger (arnim.laeuger@gmx.net)
--
-- All rights reserved
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package tech_comp_pack is

  component ram_1kx4
    port (
      clk_i : in  std_logic;
      a_i   : in  std_logic_vector(9 downto 0);
      we_i  : in  std_logic;
      d_i   : in  std_logic_vector(3 downto 0);
      d_o   : out std_logic_vector(3 downto 0)
    );
  end component;

  component ram_1kx8
    port (
      clk_i : in  std_logic;
      a_i   : in  std_logic_vector(9 downto 0);
      we_i  : in  std_logic;
      d_i   : in  std_logic_vector(7 downto 0);
      d_o   : out std_logic_vector(7 downto 0)
    );
  end component;

  component ram_4kx8
    port (
      clk_i : in  std_logic;
      a_i   : in  std_logic_vector(11 downto 0);
      we_i  : in  std_logic;
      d_i   : in  std_logic_vector( 7 downto 0);
      d_o   : out std_logic_vector( 7 downto 0)
    );
  end component;

  component generic_ram
    generic (
      addr_width_g : integer := 1024;
      data_width_g : integer := 8
    );
    port (
      clk_i : in  std_logic;
      a_i   : in  std_logic_vector(addr_width_g-1 downto 0);
      we_i  : in  std_logic;
      d_i   : in  std_logic_vector(data_width_g-1 downto 0);
      d_o   : out std_logic_vector(data_width_g-1 downto 0)
    );
  end component;

end tech_comp_pack;
