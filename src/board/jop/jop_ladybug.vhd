-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: jop_ladybug.vhd,v 1.24 2006/02/07 18:49:59 arnim Exp $
--
-- Toplevel of the Cyclone port for JOP.design's cycore board.
--   http://jopdesign.com/
--
-------------------------------------------------------------------------------
--
-- Copyright (c) 2005, Arnim Laeuger (arnim.laeuger@gmx.net)
--
-- All rights reserved
--
-- Redistribution and use in source and synthezised forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- Redistributions of source code must retain the above copyright notice,
-- this list of conditions and the following disclaimer.
--
-- Redistributions in synthesized form must reproduce the above copyright
-- notice, this list of conditions and the following disclaimer in the
-- documentation and/or other materials provided with the distribution.
--
-- Neither the name of the author nor the names of other contributors may
-- be used to endorse or promote products derived from this software without
-- specific prior written permission.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
-- THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
-- PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.
--
-- Please report bugs to the author, but before you do so, please
-- make sure that this is not a derivative work and that
-- you have the latest version of this file.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity jop_ladybug is

  port (
    -- Global Interface -------------------------------------------------------
    clk_i        : in    std_logic;
    -- VGA Interface ----------------------------------------------------------
    rgb_r_o      : out   std_logic_vector( 2 downto 0);
    rgb_g_o      : out   std_logic_vector( 2 downto 0);
    rgb_b_o      : out   std_logic_vector( 1 downto 0);
    comp_sync_n_o: out   std_logic;
    -- Audio Interface --------------------------------------------------------
    audio_l_o    : out   std_logic;
    audio_r_o    : out   std_logic;
    audio_o      : out   std_logic_vector( 7 downto 0);
    -- SNES Pad Interface -----------------------------------------------------
    pad_clk_o    : out   std_logic;
    pad_latch_o  : out   std_logic;
    pad_data_i   : in    std_logic_vector( 1 downto 0);
    -- UART Interface ---------------------------------------------------------
    rxd_i        : in    std_logic;
    txd_o        : out   std_logic;
    cts_i        : in    std_logic;
    rts_o        : out   std_logic;
    -- RAMA Interface ---------------------------------------------------------
    rama_a_o     : out   std_logic_vector(17 downto 0);
    rama_d_b     : inout std_logic_vector(15 downto 0);
    rama_cs_n_o  : out   std_logic;
    rama_oe_n_o  : out   std_logic;
    rama_we_n_o  : out   std_logic;
    rama_lb_n_o  : out   std_logic;
    rama_ub_n_o  : out   std_logic;
    -- RAMB Interface ---------------------------------------------------------
    ramb_a_o     : out   std_logic_vector(17 downto 0);
    ramb_d_b     : inout std_logic_vector(15 downto 0);
    ramb_cs_n_o  : out   std_logic;
    ramb_oe_n_o  : out   std_logic;
    ramb_we_n_o  : out   std_logic;
    ramb_lb_n_o  : out   std_logic;
    ramb_ub_n_o  : out   std_logic;
    -- Flash Interface --------------------------------------------------------
    fl_a_o       : out   std_logic_vector(18 downto 0);
    fl_d_b       : inout std_logic_vector( 7 downto 0);
    fl_we_n_o    : out   std_logic;
    fl_oe_n_o    : out   std_logic;
    fl_cs_n_o    : out   std_logic;
    fl_cs2_n_o   : out   std_logic;
    fl_rdy_i     : in    std_logic
  );

end jop_ladybug;


library ieee;
use ieee.numeric_std.all;

use work.ladybug_comp_pack.ladybug_machine;
use work.ladybug_dip_pack.all;
use work.board_misc_comp_pack.dac;
use work.board_misc_comp_pack.rom_dispatcher_16;
use work.snespad_comp.snespad;

architecture struct of jop_ladybug is

  signal gnd_s    : std_logic;
  signal gnd_8_s  : std_logic_vector( 7 downto 0);

  signal clk_20mhz_s     : std_logic;
  signal por_n_s         : std_logic;
  signal ext_res_n_s     : std_logic;

  signal rom_cpu_a_s     : std_logic_vector(14 downto 0);
  signal rom_cpu_d_s     : std_logic_vector( 7 downto 0);
  signal rom_char_a_s    : std_logic_vector(11 downto 0);
  signal rom_char_d_s    : std_logic_vector(15 downto 0);
  signal rom_sprite_a_s  : std_logic_vector(11 downto 0);
  signal rom_sprite_d_s  : std_logic_vector(15 downto 0);

  signal dip_block_1_s,
         dip_block_2_s   : std_logic_vector( 7 downto 0);

  signal but_a_s,
         but_b_s,
         but_x_s,
         but_y_s,
         but_start_s,
         but_sel_s,
         but_tl_s,
         but_tr_s        : std_logic_vector( 1 downto 0);
  signal but_up_s,
         but_down_s,
         but_left_s,
         but_right_s     : std_logic_vector( 1 downto 0);
  signal left_chute_s,
         right_chute_s   : std_logic;

  signal signed_audio_s  : signed(7 downto 0);
  signal dac_audio_s     : std_logic_vector( 7 downto 0);
  signal audio_s         : std_logic;

begin

  gnd_s    <= '0';
  gnd_8_s  <= (others => '0');

  clk_20mhz_s <= clk_i;
  ext_res_n_s <= but_tl_s(0) or but_tr_s(0);

  -----------------------------------------------------------------------------
  -- Ladybug Machine
  -----------------------------------------------------------------------------
  machine_b : ladybug_machine
    generic map (
      external_ram_g    => 0,           -- use internal RAM
      flip_screen_g     => 0            -- don't flip, please
    )
    port map (
      ext_res_n_i       => ext_res_n_s,
      clk_20mhz_i       => clk_20mhz_s,
      clk_en_10mhz_o    => open,
      clk_en_5mhz_o     => open,
      por_n_o           => por_n_s,
      tilt_n_i          => but_y_s(0),
      player_select_n_i => but_start_s,
      player_fire_n_i   => but_a_s,
      player_up_n_i     => but_up_s,
      player_right_n_i  => but_right_s,
      player_down_n_i   => but_down_s,
      player_left_n_i   => but_left_s,
      player_bomb_n_i   => but_b_s,
      right_chute_i     => right_chute_s,
      left_chute_i      => left_chute_s,
      dip_block_1_i     => dip_block_1_s,
      dip_block_2_i     => dip_block_2_s,
      rgb_r_o           => rgb_r_o(2 downto 1),
      rgb_g_o           => rgb_g_o(2 downto 1),
      rgb_b_o           => rgb_b_o,
      hsync_n_o         => open,
      vsync_n_o         => open,
      comp_sync_n_o     => comp_sync_n_o,
      audio_o           => signed_audio_s,
      rom_cpu_a_o       => rom_cpu_a_s,
      rom_cpu_d_i       => rom_cpu_d_s,
      rom_char_a_o      => rom_char_a_s,
      rom_char_d_i      => rom_char_d_s,
      rom_sprite_a_o    => rom_sprite_a_s,
      rom_sprite_d_i    => rom_sprite_d_s,
      ram_cpu_a_o       => open,
      ram_cpu_d_i       => gnd_8_s,
      ram_cpu_d_o       => open,
      ram_cpu_we_n_o    => open,
      ram_cpu_cs_n_o    => open
    );

  rgb_r_o(0) <= 'Z';
  rgb_g_o(0) <= 'Z';


  -----------------------------------------------------------------------------
  -- Convert signed audio data of Lady Bug Machine (range 127 to -128) to
  -- simple unsigned value.
  -----------------------------------------------------------------------------
  dac_audio_s <= std_logic_vector(unsigned(signed_audio_s + 128));

  dac_l_b : dac
    generic map (
      msbi_g => 7
    )
    port map (
      clk_i   => clk_20mhz_s,
      res_n_i => por_n_s,
      dac_i   => dac_audio_s,
      dac_o   => audio_s
    );

  audio_r_o <= audio_s;
  audio_l_o <= audio_s;
  audio_o   <= dac_audio_s;


  -----------------------------------------------------------------------------
  -- Building the DIP Switches
  -----------------------------------------------------------------------------
  dip_block_1_s <= lb_dip_block_1_c;
  dip_block_2_s <= lb_dip_block_2_c;


  -----------------------------------------------------------------------------
  -- ROM Dispatcher
  -----------------------------------------------------------------------------
  rom_dispatcher_b : rom_dispatcher_16
    port map (
      clk_20mhz_i    => clk_20mhz_s,
      por_n_i        => por_n_s,
      ext_mem_a_o    => rama_a_o(14 downto 0),
      ext_mem_d_i    => rama_d_b,
      rom_cpu_a_i    => rom_cpu_a_s,
      rom_cpu_d_o    => rom_cpu_d_s,
      rom_char_a_i   => rom_char_a_s,
      rom_char_d_o   => rom_char_d_s,
      rom_sprite_a_i => rom_sprite_a_s,
      rom_sprite_d_o => rom_sprite_d_s 
    );
  rama_a_o(17 downto 15) <= (others => '0');


  -----------------------------------------------------------------------------
  -- SNES Gamepads
  -----------------------------------------------------------------------------
  snespads_b : snespad
    generic map (
      num_pads_g       => 2,
      reset_level_g    => 0,
      button_level_g   => 0,
      clocks_per_6us_g => 120
    )
    port map (
      clk_i            => clk_20mhz_s,
      reset_i          => por_n_s,
      pad_clk_o        => pad_clk_o,
      pad_latch_o      => pad_latch_o,
      pad_data_i       => pad_data_i,
      but_a_o          => but_a_s,
      but_b_o          => but_b_s,
      but_x_o          => but_x_s,
      but_y_o          => but_y_s,
      but_start_o      => but_start_s,
      but_sel_o        => but_sel_s,
      but_tl_o         => but_tl_s,
      but_tr_o         => but_tr_s,
      but_up_o         => but_up_s,
      but_down_o       => but_down_s,
      but_left_o       => but_left_s,
      but_right_o      => but_right_s
    );
  left_chute_s  <= not but_sel_s(0);
  right_chute_s <= not but_x_s(0);


  -----------------------------------------------------------------------------
  -- JOP pin defaults
  -----------------------------------------------------------------------------
  -- UART
  txd_o       <= '1';
  rts_o       <= '1';
  -- RAMA
  rama_cs_n_o <= '0';
  rama_oe_n_o <= '0';
  rama_we_n_o <= '1';
  rama_lb_n_o <= '0';
  rama_ub_n_o <= '0';
  -- RAMB
  ramb_a_o    <= (others => '0');
  ramb_cs_n_o <= '1';
  ramb_oe_n_o <= '1';
  ramb_we_n_o <= '1';
  ramb_lb_n_o <= '1';
  ramb_ub_n_o <= '1';
  -- Flash
  fl_a_o      <= (others => '0');
  fl_we_n_o   <= '1';
  fl_oe_n_o   <= '1';
  fl_cs_n_o   <= '1';
  fl_cs2_n_o  <= '1';

end struct;
