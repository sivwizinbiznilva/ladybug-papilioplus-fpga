-------------------------------------------------------------------------------
--
-- $Id: ladybug_video_comp_pack-p.vhd,v 1.21 2006/02/07 00:44:35 arnim Exp $
--
-- Copyright (c) 2005, Arnim Laeuger (arnim.laeuger@gmx.net)
--
-- All rights reserved
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package ladybug_video_comp_pack is

  component ladybug_video_timing
    port (
      clk_20mhz_i     : in  std_logic;
      por_n_i         : in  std_logic;
      clk_en_5mhz_i   : in  std_logic;
      h_o             : out std_logic_vector(3 downto 0);
      h_t_o           : out std_logic_vector(3 downto 0);
      hbl_o           : out std_logic;
      hx_o            : out std_logic;
      ha_d_o          : out std_logic;
      ha_t_rise_o     : out std_logic;
      v_o             : out std_logic_vector(3 downto 0);
      v_t_o           : out std_logic_vector(3 downto 0);
      vc_d_o          : out std_logic;
      vbl_n_o         : out std_logic;
      vbl_d_n_o       : out std_logic;
      vbl_t_n_o       : out std_logic;
      blank_flont_o   : out std_logic;
      hsync_n_o       : out std_logic;
      vsync_n_o       : out std_logic;
      comp_sync_n_o   : out std_logic
    );
  end component;

  component ladybug_char_ram
    port (
      clk_i    : in  std_logic;
      clk_en_i : in  std_logic;
      a_i      : in  std_logic_vector(9 downto 0);
      cs_n_i   : in  std_logic;
      we_n_i   : in  std_logic;
      d_i      : in  std_logic_vector(7 downto 0);
      d_o      : out std_logic_vector(7 downto 0)
    );
  end component;

  component ladybug_char_col_ram
    port (
      clk_i    : in  std_logic;
      clk_en_i : in  std_logic;
      a_i      : in  std_logic_vector(9 downto 0);
      cs_n_i   : in  std_logic;
      we_n_i   : in  std_logic;
      d_i      : in  std_logic_vector(3 downto 0);
      d_o      : out std_logic_vector(3 downto 0)
    );
  end component;

  component ladybug_char
    generic (
      flip_screen_g : integer := 0
    );
    port (
      clk_20mhz_i   : in  std_logic;
      por_n_i       : in  std_logic;
      res_n_i       : in  std_logic;
      clk_en_5mhz_i : in  std_logic;
      clk_en_4mhz_i : in  std_logic;
      cs10_n_i      : in  std_logic;
      cs13_n_i      : in  std_logic;
      a_i           : in  std_logic_vector(10 downto 0);
      rd_n_i        : in  std_logic;
      wr_n_i        : in  std_logic;
      wait_n_o      : out std_logic;
      d_from_cpu_i  : in  std_logic_vector( 7 downto 0);
      d_from_char_o : out std_logic_vector( 7 downto 0);
      h_i           : in  std_logic_vector( 3 downto 0);
      h_t_i         : in  std_logic_vector( 3 downto 0);
      ha_t_rise_i   : in  std_logic;
      hx_i          : in  std_logic;
      v_i           : in  std_logic_vector( 3 downto 0);
      v_t_i         : in  std_logic_vector( 3 downto 0);
      hbl_i         : in  std_logic;
      blank_flont_i : in  std_logic;
      blank_o       : out std_logic;
      crg_o         : out std_logic_vector( 5 downto 1);
      rom_char_a_o  : out std_logic_vector(11 downto 0);
      rom_char_d_i  : in  std_logic_vector(15 downto 0)
    );
  end component;

  component ladybug_rgb_prom
    port (
      clk_i : in  std_logic;
      a_i   : in  std_logic_vector(4 downto 0);
      d_o   : out std_logic_vector(7 downto 0)
    );
  end component;

  component ladybug_rgb
    port (
      clk_20mhz_i   : in  std_logic;
      por_n_i       : in  std_logic;
      clk_en_5mhz_i : in  std_logic;
      crg_i         : in  std_logic_vector(5 downto 1);
      sig_i         : in  std_logic_vector(4 downto 1);
      rgb_r_o       : out std_logic_vector(1 downto 0);
      rgb_g_o       : out std_logic_vector(1 downto 0);
      rgb_b_o       : out std_logic_vector(1 downto 0)
    );
  end component;

  component ladybug_sprite_ram
    port (
      clk_i    : in  std_logic;
      clk_en_i : in  std_logic;
      a_i      : in  std_logic_vector(9 downto 0);
      cs_n_i   : in  std_logic;
      we_n_i   : in  std_logic;
      d_i      : in  std_logic_vector(7 downto 0);
      d_o      : out std_logic_vector(7 downto 0)
    );
  end component;

  component ladybug_sprite_ctrl
    port (
      clk_20mhz_i     : in  std_logic;
      clk_en_5mhz_i   : in  std_logic;
      clk_en_5mhz_n_i : in  std_logic;
      por_n_i         : in  std_logic;
      vbl_n_i         : in  std_logic;
      vbl_d_n_i       : in  std_logic;
      vc_i            : in  std_logic;
      vc_d_i          : in  std_logic;
      ha_i            : in  std_logic;
      ha_d_i          : in  std_logic;
      rb6_i           : in  std_logic;
      rb7_i           : in  std_logic;
      rc3_i           : in  std_logic;
      rc4_i           : in  std_logic;
      rc5_i           : in  std_logic;
      j7_b_i          : in  std_logic;
      j7_c_i          : in  std_logic;
      clk_en_eck_i    : in  std_logic;
      c_o             : out std_logic_vector(10 downto 0);
      clk_en_5ck_n_o  : out std_logic;
      clk_en_6ck_n_o  : out std_logic;
      clk_en_7ck_n_o  : out std_logic;
      s6ck_n_o        : out std_logic;
      s7ck_n_o        : out std_logic;
      clk_en_b7_p3_o  : out std_logic;
      e5_p8_o         : out std_logic;
      clk_en_e7_3_o   : out std_logic;
      a8_p5_n_o       : out std_logic
    );
  end component;

  component ladybug_sprite_lu_prom
    port (
      clk_i : in  std_logic;
      a_i   : in  std_logic_vector(4 downto 0);
      d_o   : out std_logic_vector(7 downto 0)
    );
  end component;

  component ladybug_sprite_ctrl_lu_prom
    port (
      clk_i : in  std_logic;
      a_i   : in  std_logic_vector(4 downto 0);
      d_o   : out std_logic_vector(7 downto 0)
    );
  end component;

  component ladybug_sprite_vram
    port (
      clk_i    : in  std_logic;
      clk_en_i : in  std_logic;
      a_i      : in  std_logic_vector(9 downto 0);
      cs_n_i   : in  std_logic;
      we_n_i   : in  std_logic;
      d_i      : in  std_logic_vector(3 downto 0);
      d_o      : out std_logic_vector(3 downto 0)
    );
  end component;

  component ladybug_sprite
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
      a_i              : in  std_logic_vector( 9 downto 0);
      d_from_cpu_i     : in  std_logic_vector( 7 downto 0);
      h_i              : in  std_logic_vector( 3 downto 0);
      h_t_i            : in  std_logic_vector( 3 downto 0);
      hx_i             : in  std_logic;
      ha_d_i           : in  std_logic;
      v_i              : in  std_logic_vector( 3 downto 0);
      v_t_i            : in  std_logic_vector( 3 downto 0);
      vbl_n_i          : in  std_logic;
      vbl_d_n_i        : in  std_logic;
      vbl_buf_o        : out std_logic;
      vc_d_i           : in  std_logic;
      blank_flont_i    : in  std_logic;
      blank_i          : in  std_logic;
      sig_o            : out std_logic_vector( 4 downto 1);
      rom_sprite_a_o   : out std_logic_vector(11 downto 0);
      rom_sprite_d_i   : in  std_logic_vector(15 downto 0)
    );
  end component;

end ladybug_video_comp_pack;
