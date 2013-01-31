-------------------------------------------------------------------------------
--
-- $Id: board_misc_comp_pack-p.vhd,v 1.6 2006/06/15 22:16:17 arnim Exp $
--
-- Copyright (c) 2005, Arnim Laeuger (arnim.laeuger@gmx.net)
--
-- All rights reserved
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package board_misc_comp_pack is

  component dac
    generic (
      msbi_g : integer := 7
    );
    port (
      clk_i   : in  std_logic;
      res_n_i : in  std_logic;
      dac_i   : in  std_logic_vector(msbi_g downto 0);
      dac_o   : out std_logic
    );
  end component;

  component rom_dispatcher_8
    port (
      clk_20mhz_i    : in  std_logic;
      por_n_i        : in  std_logic;
      ext_mem_a_o    : out std_logic_vector(15 downto 0);
      ext_mem_d_i    : in  std_logic_vector( 7 downto 0);
      rom_cpu_a_i    : in  std_logic_vector(14 downto 0);
      rom_cpu_d_o    : out std_logic_vector( 7 downto 0);
      rom_char_a_i   : in  std_logic_vector(11 downto 0);
      rom_char_d_o   : out std_logic_vector(15 downto 0);
      rom_sprite_a_i : in  std_logic_vector(11 downto 0);
      rom_sprite_d_o : out std_logic_vector(15 downto 0)
    );
  end component;

  component rom_dispatcher_16
    port (
      clk_20mhz_i    : in  std_logic;
      por_n_i        : in  std_logic;
      ext_mem_a_o    : out std_logic_vector(14 downto 0);
      ext_mem_d_i    : in  std_logic_vector(15 downto 0);
      rom_cpu_a_i    : in  std_logic_vector(14 downto 0);
      rom_cpu_d_o    : out std_logic_vector( 7 downto 0);
      rom_char_a_i   : in  std_logic_vector(11 downto 0);
      rom_char_d_o   : out std_logic_vector(15 downto 0);
      rom_sprite_a_i : in  std_logic_vector(11 downto 0);
      rom_sprite_d_o : out std_logic_vector(15 downto 0)
    );
  end component;

  component rom_ram_dispatcher_16
    port (
      clk_20mhz_i     : in  std_logic;
      por_n_i         : in  std_logic;
      chip_oel_o      : out std_logic;
      chip_oeu_o      : out std_logic;
      ext_mem_a_o     : out std_logic_vector(14 downto 0);
      ext_mem_d_i     : in  std_logic_vector(15 downto 0);
      ext_mem_d_o     : out std_logic_vector(15 downto 0);
      ext_mem_ce_n_o  : out std_logic;
      ext_mem_wel_n_o : out std_logic;
      ext_mem_weu_n_o : out std_logic;
      rom_cpu_a_i     : in  std_logic_vector(14 downto 0);
      rom_cpu_d_o     : out std_logic_vector( 7 downto 0);
      rom_char_a_i    : in  std_logic_vector(11 downto 0);
      rom_char_d_o    : out std_logic_vector(15 downto 0);
      rom_sprite_a_i  : in  std_logic_vector(11 downto 0);
      rom_sprite_d_o  : out std_logic_vector(15 downto 0);
      ram_cpu_a_i     : in  std_logic_vector(11 downto 0);
      ram_cpu_d_i     : in  std_logic_vector( 7 downto 0);
      ram_cpu_d_o     : out std_logic_vector( 7 downto 0);
      ram_cpu_we_n_i  : in  std_logic;
      ram_cpu_cs_n_i  : in  std_logic
    );
  end component;

  component pcm_sound
    port (
      clk_i              : in  std_logic;
      reset_n_i          : in  std_logic;
      pcm_left_i         : in  signed(8 downto 0);
      pcm_right_i        : in  signed(8 downto 0);
      bit_clk_pad_i      : in  std_logic;
      sync_pad_o         : out std_logic;
      sdata_pad_o        : out std_logic;
      sdata_pad_i        : in  std_logic;
      ac97_reset_pad_n_o : out std_logic;
      led_o              : out std_logic_vector(5 downto 0);
      dpy0_a_o           : out std_logic;
      dpy0_b_o           : out std_logic;
      dpy0_c_o           : out std_logic;
      dpy0_d_o           : out std_logic;
      dpy0_e_o           : out std_logic;
      dpy0_f_o           : out std_logic;
      dpy0_g_o           : out std_logic;
      dpy1_a_o           : out std_logic;
      dpy1_b_o           : out std_logic;
      dpy1_c_o           : out std_logic;
      dpy1_d_o           : out std_logic;
      dpy1_e_o           : out std_logic;
      dpy1_f_o           : out std_logic;
      dpy1_g_o           : out std_logic
    );
  end component;

end board_misc_comp_pack;
