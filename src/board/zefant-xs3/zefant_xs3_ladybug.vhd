-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: zefant_xs3_ladybug.vhd,v 1.2 2006/06/15 22:16:57 arnim Exp $
--
-- Toplevel of the Spartan3 port for Simple Solutions' Zefant-XS3 board.
--   http://zefant.de/
--
-------------------------------------------------------------------------------
--
-- Copyright (c) 2006, Arnim Laeuger (arnim.laeuger@gmx.net)
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

library IEEE;
use ieee.std_logic_1164.all;

entity zefant_xs3_ladybug is
  port (
    -- Zefant-DDR FPGA Module Peripherals -----------------------------------
    -- Clock oscillator
    osc1                     : in    std_logic;
    
    -- Flash Memory
    fl_a                     : out   std_logic_vector(24 downto 0);
    fl_d                     : inout std_logic_vector(15 downto 0);
    fl_ce_n                  : out   std_logic;
    fl_oe_n                  : out   std_logic;
    fl_we_n                  : out   std_logic;
    fl_byte_n                : out   std_logic;
    fl_rp_n                  : out   std_logic;
    fl_sts                   : in    std_logic;

    -- DDR SDRAM (SODIMM)
--    ddr_a                    : out   std_logic_vector(13 downto 0);
--    ddr_ba                   : out   std_logic_vector(1 downto 0);
--    ddr_dq                   : inout std_logic_vector(63 downto 0);
--    ddr_dqs                  : out   std_logic_vector(7 downto 0);
--    ddr_dm                   : out   std_logic_vector(7 downto 0);
--    ddr_we_n                 : out   std_logic;
--    ddr_ras_n                : out   std_logic;
--    ddr_cas_n                : out   std_logic;
--    ddr_ck                   : out   std_logic_vector(2 downto 0);
--    ddr_ck_n                 : out   std_logic_vector(2 downto 0);
--    ddr_cke                  : out   std_logic_vector(1 downto 0);
--    ddr_scl                  : out   std_logic;
--    ddr_sda                  : inout std_logic;
--    ddr_s0_n                 : out   std_logic;
--    ddr_s1_n                 : out   std_logic;

    -- FPGA dedicated/dual purpose pins 
    fpga_cs_b                : inout std_logic;
    fpga_dout_busy           : inout std_logic;
    fpga_init_b              : inout std_logic;
    fpga_rdwr_b              : inout std_logic;

    fpga_cpld_io             : inout std_logic_vector(7 downto 0);

--    cpld_clk                 : out   std_logic;

    -- SRAM 0
    sr0_a                    : out   std_logic_vector(17 downto 0);
    sr0_d                    : inout std_logic_vector(15 downto 0);
    sr0_ce_n                 : out   std_logic;
    sr0_lb_n                 : out   std_logic;
    sr0_oe_n                 : out   std_logic;
    sr0_ub_n                 : out   std_logic;
    sr0_we_n                 : out   std_logic;
    -- SRAM 1
    sr1_a                    : out   std_logic_vector(17 downto 0);
    sr1_d                    : inout std_logic_vector(15 downto 0);
    sr1_ce_n                 : out   std_logic;
    sr1_lb_n                 : out   std_logic;
    sr1_oe_n                 : out   std_logic;
    sr1_ub_n                 : out   std_logic;
    sr1_we_n                 : out   std_logic;

    -- Zefant-XS3 Baseboard Peripherals -----------------------------------
    -- EEPROM
    ee_cs_n                  : out   std_logic;
    ee_sck                   : out   std_logic;
    ee_si                    : out   std_logic;
    ee_so                    : in    std_logic;

    -- User Interface
    button                   : in    std_logic_vector(5 downto 0);
    led                      : out   std_logic_vector(5 downto 0);

    -- Audio Codec
    aud_sdata_in             : in    std_logic;
    aud_sdata_out            : out   std_logic;
    aud_bit_clk              : in    std_logic;
    aud_cin                  : out   std_logic;
    aud_reset_n              : out   std_logic;
    aud_sync                 : out   std_logic;

    -- Video DAC
    vid_blank                : out   std_logic;
    vid_clk                  : out   std_logic;
    vid_r                    : out   std_logic_vector(7 downto 0);
    vid_g                    : out   std_logic_vector(7 downto 0);
    vid_b                    : out   std_logic_vector(7 downto 0);
    vid_hsync                : out   std_logic;
    vid_psave_n              : out   std_logic;
    vid_sync_n               : out   std_logic;
    vid_vsync                : out   std_logic;
                                     
    -- Extension Connectors          
    x301                     : inout std_logic_vector(19 downto 2);
    x303                     : inout std_logic_vector(34 downto 1);

    -- RS 232
    rs232_rxd                : in    std_logic_vector(1 downto 0);
    rs232_txd                : out   std_logic_vector(1 downto 0);
    rs232_cts                : in    std_logic_vector(1 downto 0);
    rs232_rts                : out   std_logic_vector(1 downto 0);

    -- USB
    usb_rcv                  : in    std_logic;
    usb_vp                   : in    std_logic;
    usb_vm                   : in    std_logic;
    usb_vbus                 : in    std_logic;
    usb_oe_n                 : out   std_logic;
    usb_softcon              : out   std_logic;
    usb_suspnd               : out   std_logic;
    usb_vmo                  : out   std_logic;
    usb_vpo                  : out   std_logic

  );
end zefant_xs3_ladybug;


library ieee;
use ieee.numeric_std.all;

use work.ladybug_comp_pack.ladybug_machine;
use work.ladybug_dip_pack.all;
use work.board_misc_comp_pack.rom_dispatcher_16;
use work.board_misc_comp_pack.pcm_sound;
use work.snespad_comp.snespad;

architecture struct of zefant_xs3_ladybug is

  component zefant_xs3_clk
    port (
      clkin_i     : in  std_logic;
      locked_o    : out std_logic;
      clk_20mhz_o : out std_logic
    );
  end component;

  component dblscan
    port (
      R_IN          : in    std_logic_vector( 2 downto 0);
      G_IN          : in    std_logic_vector( 2 downto 0);
      B_IN          : in    std_logic_vector( 1 downto 0);
      HSYNC_IN      : in    std_logic;
      VSYNC_IN      : in    std_logic;
      R_OUT         : out   std_logic_vector( 2 downto 0);
      G_OUT         : out   std_logic_vector( 2 downto 0);
      B_OUT         : out   std_logic_vector( 1 downto 0);
      HSYNC_OUT     : out   std_logic;
      VSYNC_OUT     : out   std_logic;
      BLANK_OUT     : out   std_logic;
      --  NOTE CLOCKS MUST BE PHASE LOCKED !!
      CLK_6         : in    std_logic; -- input pixel clock (6MHz)
      CLK_EN_6M     : in    std_logic;
      CLK_12        : in    std_logic; -- output clock      (12MHz)
      CLK_EN_12M    : in    std_logic
    );
  end component;


  signal clk_20mhz_s    : std_logic;
  signal clk_en_10mhz_s : std_logic;
  signal clk_en_5mhz_s  : std_logic;
  signal reset_n_s      : std_logic;

  signal rom_cpu_a_s    : std_logic_vector(14 downto 0);
  signal rom_cpu_d_s    : std_logic_vector( 7 downto 0);
  signal rom_char_a_s   : std_logic_vector(11 downto 0);
  signal rom_char_d_s   : std_logic_vector(15 downto 0);
  signal rom_sprite_a_s : std_logic_vector(11 downto 0);
  signal rom_sprite_d_s : std_logic_vector(15 downto 0);

  signal lb_ext_mem_a_s : std_logic_vector(14 downto 0);
  signal lb_ext_mem_d_s : std_logic_vector(15 downto 0);

  signal but_up_s,
         but_down_s,
         but_left_s,
         but_right_s,
         but_a_s,
         but_b_s,
         but_x_s,
         but_y_s,
         but_start_s,
         but_sel_s,
         but_tr_s,
         but_tl_s       : std_logic_vector( 1 downto 0);
  signal right_chute_s,
         left_chute_s   : std_logic;

  signal but_res_n_q    : std_logic_vector( 1 downto 0) := (others => '1');
  signal but_por_n_q    : std_logic_vector( 1 downto 0) := (others => '1');

  signal pad_clk_s,
         pad_latch_s    : std_logic;
  signal pad_data_s     : std_logic_vector( 1 downto 0);

  signal rgb_r_s,
         rgb_g_s        : std_logic_vector( 2 downto 0);
  signal rgb_b_s        : std_logic_vector( 1 downto 0);
  signal rgb_hsync_n_s,
         rgb_vsync_n_s  : std_logic;
  signal rgb_hsync_s,
         rgb_vsync_s    : std_logic;

  signal vga_r_s,
         vga_g_s        : std_logic_vector( 2 downto 0);
  signal vga_b_s        : std_logic_vector( 1 downto 0);
  signal vga_hsync_s,
         vga_vsync_s    : std_logic;
  signal blank_s        : std_logic;

  signal por_n_s,
         por_but_n_s    : std_logic;
  signal audio_s        : signed(8 downto 0);

  signal dip_block_1_s,
         dip_block_2_s  : std_logic_vector( 7 downto 0);

  signal cp_addr_q      : unsigned(14 downto 0);
  signal cp_cs_n_q,
         cp_oe_n_q,
         cp_we_n_q      : std_logic;
  signal enable_lb_q    : boolean;

  type   cp_state_t     is (CP_READ,
                            CP_WRITE_ON, CP_WRITE_OFF,
                            CP_INC_ADDR,
                            CP_FINISH);
  signal cp_state_q     : cp_state_t;

  signal vcc_2_s        : std_logic_vector( 1 downto 0);
  signal gnd_8_s        : std_logic_vector( 7 downto 0);

begin

  vcc_2_s <= (others => '1');
  gnd_8_s <= (others => '0');

  -----------------------------------------------------------------------------
  -- Clock Generator
  -----------------------------------------------------------------------------
  zefant_xs3_clk_b : zefant_xs3_clk
    port map (
      clkin_i     => osc1,
      locked_o    => open,
      clk_20mhz_o => clk_20mhz_s
    );


  -- power-on reset is combined with external button press
  por_but_n_s <= por_n_s and but_por_n_q(1);

  -- reset is derived from result of copier process
  reset_n_s <=   '0'
               when not enable_lb_q or but_res_n_q(1) = '0' else
                 '1';


  -----------------------------------------------------------------------------
  -- Lady Bug Machine
  -----------------------------------------------------------------------------
  right_chute_s <= not but_tr_s(0);
  left_chute_s  <= not but_tl_s(0);
  ladybug_machine_b : ladybug_machine
    generic map (
      external_ram_g => 0,
      flip_screen_g  => 0
    )
    port map (
      ext_res_n_i       => reset_n_s,
      clk_20mhz_i       => clk_20mhz_s,
      clk_en_10mhz_o    => clk_en_10mhz_s,
      clk_en_5mhz_o     => clk_en_5mhz_s,
      por_n_o           => por_n_s,
      tilt_n_i          => vcc_2_s(0),
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
      rgb_r_o           => rgb_r_s(2 downto 1),
      rgb_g_o           => rgb_g_s(2 downto 1),
      rgb_b_o           => rgb_b_s,
      hsync_n_o         => rgb_hsync_n_s,
      vsync_n_o         => rgb_vsync_n_s,
      comp_sync_n_o     => open,
      audio_o           => audio_s(8 downto 1),
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

  rgb_r_s(0)  <= '0';
  rgb_g_s(0)  <= '0';
  audio_s(0)  <= '0';
  rgb_hsync_s <= not rgb_hsync_n_s;
  rgb_vsync_s <= not rgb_vsync_n_s;


  -----------------------------------------------------------------------------
  -- ROM Dispatcher
  -----------------------------------------------------------------------------
  rom_dispatcher_b : rom_dispatcher_16
    port map (
      clk_20mhz_i    => clk_20mhz_s,
      por_n_i        => por_but_n_s,
      ext_mem_a_o    => lb_ext_mem_a_s,
      ext_mem_d_i    => lb_ext_mem_d_s,
      rom_cpu_a_i    => rom_cpu_a_s,
      rom_cpu_d_o    => rom_cpu_d_s,
      rom_char_a_i   => rom_char_a_s,
      rom_char_d_o   => rom_char_d_s,
      rom_sprite_a_i => rom_sprite_a_s,
      rom_sprite_d_o => rom_sprite_d_s 
    );


  -----------------------------------------------------------------------------
  -- Process sram_mux
  --
  -- Purpose:
  --   Multiplexes the SRAM address and control signals from the dkong machine
  --   and the copier process.
  --
  sram_mux: process (enable_lb_q,
                     lb_ext_mem_a_s,
                     cp_addr_q,
                     cp_cs_n_q, cp_oe_n_q,
                     fl_d)
  begin
    if enable_lb_q then
      sr1_a(17 downto 15) <= (others => '0');
      sr1_a(14 downto  0) <= lb_ext_mem_a_s;
      sr1_ce_n            <= '0';
      sr1_oe_n            <= '0';
      sr1_d               <= (others => 'Z');

      fl_ce_n             <= '1';
      fl_oe_n             <= '1';
    else
      sr1_a(17 downto 15) <= (others => '0');
      sr1_a(14 downto 0)  <= std_logic_vector(cp_addr_q);
      sr1_ce_n            <= cp_cs_n_q;
      sr1_oe_n            <= '1';
      sr1_d               <= fl_d;

      fl_ce_n             <= cp_cs_n_q;
      fl_oe_n             <= cp_oe_n_q;
    end if;
  end process sram_mux;
  --
  -----------------------------------------------------------------------------


  lb_ext_mem_d_s     <= sr1_d;

  fl_a(0)            <= '0';
  fl_a(15 downto  1) <= std_logic_vector(cp_addr_q);
  fl_a(17 downto 16) <= (others => '0');
  fl_a(18)           <= '1';            -- Lady Bug Flash range
  fl_a(24 downto 19) <= (others => '0');
  
  sr1_we_n <= cp_we_n_q;


  -----------------------------------------------------------------------------
  -- Process por_but
  --
  -- Purpose:
  --   Synchronize button(1) and infer it as a power-on reset.
  --
  por_but: process (clk_20mhz_s, button)
  begin
    if button(1) = '0' then
      but_por_n_q <= (others => '0');
    elsif clk_20mhz_s'event and clk_20mhz_s = '1' then
      but_por_n_q(0) <= '1';
      but_por_n_q(1) <= but_por_n_q(0);
    end if;
  end process por_but;
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Process res_but
  --
  -- Purpose:
  --   Synchronize button(0) and infer it as a machine reset.
  --
  res_but: process (clk_20mhz_s, button)
  begin
    if button(0) = '0' then
      but_res_n_q <= (others => '0');
    elsif clk_20mhz_s'event and clk_20mhz_s = '1' then
      but_res_n_q(0) <= '1';
      but_res_n_q(1) <= but_res_n_q(0);
    end if;
  end process res_but;
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Process copy
  --
  -- Purpose:
  --   Copies the application data from Flash to SRAM.
  --
  copy: process (clk_20mhz_s, por_but_n_s)
    variable cnt_zero_v : boolean;
  begin
    if por_but_n_s = '0' then
      cp_addr_q   <= (others => '0');
      cp_cs_n_q   <= '1';
      cp_oe_n_q   <= '1';
      cp_we_n_q   <= '1';
      enable_lb_q <= false;
      cp_state_q  <= CP_READ;

    elsif clk_20mhz_s'event and clk_20mhz_s = '1' then
      -- copier functionality -------------------------------------------------
      if clk_en_5mhz_s = '1' then
        case cp_state_q is
          when CP_READ =>
            cp_cs_n_q     <= '0';
            cp_oe_n_q     <= '0';

            cp_state_q    <= CP_WRITE_ON;

          when CP_WRITE_ON =>
            cp_we_n_q     <= '0';
            cp_state_q    <= CP_WRITE_OFF;

          when CP_WRITE_OFF =>
            cp_we_n_q     <= '1';
            cp_state_q    <= CP_INC_ADDR;

          when CP_INC_ADDR =>
            if cp_addr_q /= 16#6000# then
              cp_addr_q   <= cp_addr_q + 1;
              cp_state_q  <= CP_READ;
            else
              cp_state_q  <= CP_FINISH;
            end if;

          when CP_FINISH =>
            cp_cs_n_q     <= '1';
            cp_oe_n_q     <= '1';
            enable_lb_q   <= true;

          when others =>
            null;
        end case;
      end if;

    end if;
  end process copy;
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- VGA Scan Doubler
  -----------------------------------------------------------------------------
  dblscan_b : dblscan
    port map (
      R_IN       => rgb_r_s,
      G_IN       => rgb_g_s,
      B_IN       => rgb_b_s,
      HSYNC_IN   => rgb_hsync_s,
      VSYNC_IN   => rgb_vsync_s,
      R_OUT      => vga_r_s,
      G_OUT      => vga_g_s,
      B_OUT      => vga_b_s,
      HSYNC_OUT  => vga_hsync_s,
      VSYNC_OUT  => vga_vsync_s,
      BLANK_OUT  => blank_s,
      CLK_6      => clk_20mhz_s,
      CLK_EN_6M  => clk_en_5mhz_s,
      CLK_12     => clk_20mhz_s,
      CLK_EN_12M => clk_en_10mhz_s
    );


  -----------------------------------------------------------------------------
  -- PCM Sound Interface to AC97 Codec
  -----------------------------------------------------------------------------
  pcm_sound_b : pcm_sound
    port map (
      clk_i              => clk_20mhz_s,
      reset_n_i          => reset_n_s,
      pcm_left_i         => audio_s,
      pcm_right_i        => audio_s,
      bit_clk_pad_i      => aud_bit_clk,
      sync_pad_o         => aud_sync,
      sdata_pad_o        => aud_sdata_out,
      sdata_pad_i        => aud_sdata_in,
      ac97_reset_pad_n_o => aud_reset_n,
      led_o              => open,
      dpy0_a_o           => open,
      dpy0_b_o           => open,
      dpy0_c_o           => open,
      dpy0_d_o           => open,
      dpy0_e_o           => open,
      dpy0_f_o           => open,
      dpy0_g_o           => open,
      dpy1_a_o           => open,
      dpy1_b_o           => open,
      dpy1_c_o           => open,
      dpy1_d_o           => open,
      dpy1_e_o           => open,
      dpy1_f_o           => open,
      dpy1_g_o           => open
    );


  -----------------------------------------------------------------------------
  -- VGA Output
  -----------------------------------------------------------------------------
  vid_r(7 downto 5) <= vga_r_s;
  vid_r(4 downto 0) <= (others => '0');
  vid_g(7 downto 5) <= vga_g_s;
  vid_g(4 downto 0) <= (others => '0');
  vid_b(7 downto 6) <= vga_b_s;
  vid_b(5 downto 0) <= (others => '0');
  vid_hsync         <= not vga_hsync_s;
  vid_vsync         <= not vga_vsync_s;
  vid_blank         <= not blank_s;
  vid_clk           <= clk_en_10mhz_s;


  -----------------------------------------------------------------------------
  -- Building the DIP Switches
  -----------------------------------------------------------------------------
  dip_block_1_s <= lb_dip_block_1_c;
  dip_block_2_s <= lb_dip_block_2_c;


  -----------------------------------------------------------------------------
  -- SNES Gamepads
  -----------------------------------------------------------------------------
  pad_data_s <= fpga_cpld_io(3 downto 2);
  snespads_b : snespad
    generic map (
      num_pads_g       => 2,
      reset_level_g    => 0,
      button_level_g   => 0,
      clocks_per_6us_g => 120
    )
    port map (
      clk_i            => clk_20mhz_s,
      reset_i          => reset_n_s,
      pad_clk_o        => pad_clk_s,
      pad_latch_o      => pad_latch_s,
      pad_data_i       => pad_data_s,
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
  fpga_cpld_io(0) <= pad_latch_s;
  fpga_cpld_io(1) <= pad_clk_s;


  -----------------------------------------------------------------------------
  -- Default values for unused ports
  -----------------------------------------------------------------------------

  -- Flash Memory -------------------------------------------------------------
--  fl_a      <= (others => '0');
--  fl_d      <= (others => 'Z');
--  fl_ce_n   <= '1';
--  fl_oe_n   <= '1';
  fl_we_n   <= '1';
  fl_byte_n <= '1';
  fl_rp_n   <= '1';

  -- DDR SDRAM ----------------------------------------------------------------
--  ddr_a     <= (others => '0');
--  ddr_ba    <= (others => '0');
--  ddr_dq    <= (others => 'Z');
--  ddr_dqs   <= (others => '0');
--  ddr_dm    <= (others => '0');
--  ddr_we_n  <= '1';
--  ddr_ras_n <= '1';
--  ddr_cas_n <= '1';
--  ddr_ck    <= (others => '0');
--  ddr_ck_n  <= (others => '1');
--  ddr_cke   <= (others => '0');
--  ddr_scl   <= '0';
--  ddr_sda   <= 'Z';
--  ddr_s0_n  <= '1';
--  ddr_s1_n  <= '1';

  fpga_cs_b      <= 'Z';
  fpga_dout_busy <= 'Z';
  fpga_init_b    <= 'Z';
  fpga_rdwr_b    <= 'Z';

  fpga_cpld_io(7 downto 2)   <= (others => 'Z');

--  cpld_clk       <= '0';
  -- same pin assigned clkd_clk <=> x303(30)
  x303(30) <= '0';

  -- SRAMs in SO-DIMM Socket --------------------------------------------------
  sr0_a <= (others => '0');
  sr0_d <= (others => 'Z');
  sr0_ce_n <= '1';
  sr0_lb_n <= '0';
  sr0_oe_n <= '1';
  sr0_ub_n <= '0';
  sr0_we_n <= '1';
--  sr1_a <= (others => '0');
--  sr1_d <= (others => 'Z');
--  sr1_ce_n <= '1';
  sr1_lb_n <= '0';
--  sr1_oe_n <= '1';
  sr1_ub_n <= '0';
--  sr1_we_n <= '1';

  -- Baseboard EEPROM ---------------------------------------------------------
  ee_cs_n <= '1';
  ee_sck  <= '0';
  ee_si   <= '0';

  -- User Interface -----------------------------------------------------------
  led <= (others => '0');

  -- Audio Codec --------------------------------------------------------------
--  aud_sdata_out <= '0';
  aud_cin       <= '0';
--  aud_reset_n   <= '0';
--  aud_sync      <= '0';

  -- Video DAC ----------------------------------------------------------------
--  vid_blank   <= '1';
--  vid_clk     <= '0';
--  vid_r       <= (others => '0');
--  vid_g       <= (others => '0');
--  vid_b       <= (others => '0');
--  vid_hsync   <= '0';
  vid_psave_n <= '1';
  vid_sync_n  <= '0';
--  vid_vsync   <= '0';

  -- Extension Connectors -----------------------------------------------------
  x301 <= (others => 'Z');
  x303 <= (others => 'Z');

  -- RS 232 -------------------------------------------------------------------
  rs232_txd <= (others => '1');
  rs232_rts <= (others => '1');

  -- USB ----------------------------------------------------------------------
  usb_oe_n    <= '1';
  usb_softcon <= '0';
  usb_suspnd  <= '1';
  usb_vmo     <= '0';
  usb_vpo     <= '1';

end struct;
