-------------------------------------------------------------------------------
--
-- $Id: ladybug_comp_pack-p.vhd,v 1.30 2006/02/07 00:44:21 arnim Exp $
--
-- Copyright (c) 2005, Arnim Laeuger (arnim.laeuger@gmx.net)
--
-- All rights reserved
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package ladybug_comp_pack is

  component ladybug_clk
    port (
      clk_20mhz_i      : in  std_logic;
      por_n_i          : in  std_logic;
      clk_en_10mhz_o   : out std_logic;
      clk_en_10mhz_n_o : out std_logic;
      clk_en_5mhz_o    : out std_logic;
      clk_en_5mhz_n_o  : out std_logic;
      clk_en_4mhz_o    : out std_logic
    );
  end component;

  component ladybug_por
    port (
      clk_20mhz_i : in  std_logic;
      por_n_o     : out std_logic
    );
  end component;

  component ladybug_res
    port (
      clk_20mhz_i : in  std_logic;
      ext_res_n_i : in  std_logic;
      res_n_o     : out std_logic;
      por_n_o     : out std_logic
    );
  end component;

  component ladybug_generic_ram
    generic (
      data_width_g : integer :=  8;
      addr_width_g : integer := 10
    );
    port (
      clk_i    : in  std_logic;
      clk_en_i : in  std_logic;
      a_i      : in  std_logic_vector(addr_width_g-1 downto 0);
      we_i     : in  std_logic;
      d_i      : in  std_logic_vector(data_width_g-1 downto 0);
      d_o      : out std_logic_vector(data_width_g-1 downto 0)
    );
  end component;

  component ladybug_cpu_unit
    generic (
      external_ram_g : integer := 0
    );
    port (
      clk_20mhz_i    : in  std_logic;
      clk_en_4mhz_i  : in  std_logic;
      res_n_i        : in  std_logic;
      rom_cpu_a_o    : out std_logic_vector(14 downto 0);
      rom_cpu_d_i    : in  std_logic_vector( 7 downto 0);
      ram_cpu_a_o    : out std_logic_vector(11 downto 0);
      ram_cpu_d_i    : in  std_logic_vector( 7 downto 0);
      ram_cpu_d_o    : out std_logic_vector( 7 downto 0);
      ram_cpu_cs_n_o : out std_logic;
      ram_cpu_we_n_o : out std_logic;
      sound_wait_n_i : in  std_logic;
      wait_n_i       : in  std_logic;
      right_chute_i  : in  std_logic;
      left_chute_i   : in  std_logic;
      gpio_in0_i     : in  std_logic_vector( 7 downto  0);
      gpio_in1_i     : in  std_logic_vector( 7 downto  0);
      gpio_in2_i     : in  std_logic_vector( 7 downto  0);
      gpio_in3_i     : in  std_logic_vector( 7 downto  0);
      gpio_extra_i   : in  std_logic_vector( 7 downto  0);
      a_o            : out std_logic_vector(10 downto  0);
      d_to_cpu_i     : in  std_logic_vector( 7 downto  0);
      d_from_cpu_o   : out std_logic_vector( 7 downto  0);
      rd_n_o         : out std_logic;
      wr_n_o         : out std_logic;
      cs7_n_o        : out std_logic;
      cs10_n_o       : out std_logic;
      cs11_n_o       : out std_logic;
      cs12_n_o       : out std_logic;
      cs13_n_o       : out std_logic
    );
  end component;

  component ladybug_video_unit
    generic (
      flip_screen_g    : integer := 0
    );
    port (
      clk_20mhz_i      : in  std_logic;
      por_n_i          : in  std_logic;
      res_n_i          : in  std_logic;
      clk_en_10mhz_i   : in  std_logic;
      clk_en_10mhz_n_i : in  std_logic;
      clk_en_5mhz_i    : in  std_logic;
      clk_en_5mhz_n_i  : in  std_logic;
      clk_en_4mhz_i    : in  std_logic;
      cs7_n_i          : in  std_logic;
      cs10_n_i         : in  std_logic;
      cs13_n_i         : in  std_logic;
      a_i              : in  std_logic_vector(10 downto 0);
      rd_n_i           : in  std_logic;
      wr_n_i           : in  std_logic;
      wait_n_o         : out std_logic;
      d_from_cpu_i     : in  std_logic_vector( 7 downto 0);
      d_from_video_o   : out std_logic_vector( 7 downto 0);
      vc_o             : out std_logic;
      vbl_tick_n_o     : out std_logic;
      vbl_buf_o        : out std_logic;
      rgb_r_o          : out std_logic_vector( 1 downto 0);
      rgb_g_o          : out std_logic_vector( 1 downto 0);
      rgb_b_o          : out std_logic_vector( 1 downto 0);
      hsync_n_o        : out std_logic;
      vsync_n_o        : out std_logic;
      comp_sync_n_o    : out std_logic;
      rom_char_a_o     : out std_logic_vector(11 downto 0);
      rom_char_d_i     : in  std_logic_vector(15 downto 0);
      rom_sprite_a_o   : out std_logic_vector(11 downto 0);
      rom_sprite_d_i   : in  std_logic_vector(15 downto 0)
    );
  end component;

  component ladybug_sound_unit
    port (
      clk_20mhz_i    : in  std_logic;
      clk_en_4mhz_i  : in  std_logic;
      por_n_i        : in  std_logic;
      cs11_n_i       : in  std_logic;
      cs12_n_i       : in  std_logic;
      wr_n_i         : in  std_logic;
      d_from_cpu_i   : in  std_logic_vector(7 downto 0);
      sound_wait_n_o : out std_logic;
      audio_o        : out signed(7 downto 0)
    );
  end component;

  component ladybug_machine
    generic (
      external_ram_g    : integer := 0;
      flip_screen_g     : integer := 0
    );
    port (
      ext_res_n_i       : in  std_logic;
      clk_20mhz_i       : in  std_logic;
      clk_en_10mhz_o    : out std_logic;
      clk_en_5mhz_o     : out std_logic;
      por_n_o           : out std_logic;
      tilt_n_i          : in  std_logic;
      player_select_n_i : in  std_logic_vector( 1 downto 0);
      player_fire_n_i   : in  std_logic_vector( 1 downto 0);
      player_up_n_i     : in  std_logic_vector( 1 downto 0);
      player_right_n_i  : in  std_logic_vector( 1 downto 0);
      player_down_n_i   : in  std_logic_vector( 1 downto 0);
      player_left_n_i   : in  std_logic_vector( 1 downto 0);
      player_bomb_n_i   : in  std_logic_vector( 1 downto 0);
      right_chute_i     : in  std_logic;
      left_chute_i      : in  std_logic;
      dip_block_1_i     : in  std_logic_vector( 7 downto 0);
      dip_block_2_i     : in  std_logic_vector( 7 downto 0);
      rgb_r_o           : out std_logic_vector( 1 downto 0);
      rgb_g_o           : out std_logic_vector( 1 downto 0);
      rgb_b_o           : out std_logic_vector( 1 downto 0);
      hsync_n_o         : out std_logic;
      vsync_n_o         : out std_logic;
      comp_sync_n_o     : out std_logic;
      audio_o           : out signed( 7 downto 0);
      rom_cpu_a_o       : out std_logic_vector(14 downto 0);
      rom_cpu_d_i       : in  std_logic_vector( 7 downto 0);
      rom_char_a_o      : out std_logic_vector(11 downto 0);
      rom_char_d_i      : in  std_logic_vector(15 downto 0);
      rom_sprite_a_o    : out std_logic_vector(11 downto 0);
      rom_sprite_d_i    : in  std_logic_vector(15 downto 0);
      ram_cpu_a_o       : out std_logic_vector(11 downto 0);
      ram_cpu_d_i       : in  std_logic_vector( 7 downto 0);
      ram_cpu_d_o       : out std_logic_vector( 7 downto 0);
      ram_cpu_we_n_o    : out std_logic;
      ram_cpu_cs_n_o    : out std_logic
    );
  end component;

end ladybug_comp_pack;
