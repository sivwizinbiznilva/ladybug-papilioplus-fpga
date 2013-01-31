-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_sprite.vhd,v 1.12 2005/10/10 22:02:14 arnim Exp $
--
-- Sprite Video Module of Lady Bug Machine.
--
-- This unit contains the whole sprite logic which is distributed on the
-- CPU and video boards.
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

entity ladybug_sprite is

  generic (
    flip_screen_g    : integer := 0
  );
  port (
    -- Clock and Reset Interface ----------------------------------------------
    clk_20mhz_i      : in  std_logic;
    por_n_i          : in  std_logic;
    res_n_i          : in  std_logic;
    clk_en_10mhz_i   : in  std_logic;
    clk_en_10mhz_n_i : in  std_logic;
    clk_en_5mhz_i    : in  std_logic;
    clk_en_5mhz_n_i  : in  std_logic;
    clk_en_4mhz_i    : in  std_logic;
    -- CPU Interface ----------------------------------------------------------
    cs7_n_i          : in  std_logic;
    a_i              : in  std_logic_vector( 9 downto 0);
    d_from_cpu_i     : in  std_logic_vector( 7 downto 0);
    -- RGB Video Interface ----------------------------------------------------
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
    -- Sprite ROM Interface ---------------------------------------------------
    rom_sprite_a_o   : out std_logic_vector(11 downto 0);
    rom_sprite_d_i   : in  std_logic_vector(15 downto 0)
  );

end ladybug_sprite;


library ieee;
use ieee.numeric_std.all;

use work.ladybug_video_pack.all;
use work.ttl_comp_pack.ttl_161;
use work.ttl_comp_pack.ttl_166;
use work.ttl_comp_pack.ttl_395;
use work.ladybug_video_comp_pack.ladybug_sprite_ram;
use work.ladybug_video_comp_pack.ladybug_sprite_ctrl;
use work.ladybug_video_comp_pack.ladybug_sprite_lu_prom;
use work.ladybug_video_comp_pack.ladybug_sprite_ctrl_lu_prom;
use work.ladybug_video_comp_pack.ladybug_sprite_vram;

architecture rtl of ladybug_sprite is

  -----------------------------------------------------------------------------
  -- General purpose indice for register outputs
  -----------------------------------------------------------------------------
  constant qa_c  : natural := 0;
  constant qb_c  : natural := 1;
  constant qc_c  : natural := 2;
  constant qd_c  : natural := 3;

  signal clk_5mhz_n_q  : std_logic;

  signal c_s           : std_logic_vector(10 downto 0);
  signal v_cnt_s       : std_logic_vector( 4 downto 0);
  signal v_cnt_carry_s : std_logic;
  signal ra_s          : std_logic_vector( 9 downto 0);

  signal sprite_ram_cs_n_s,
         sprite_ram_we_n_s   : std_logic;
  signal rb_s,
         rb_unflip_s,
         rc_s     : std_logic_vector( 7 downto 0);

  signal ma_s     : std_logic_vector(11 downto 0);
  signal ma_q     : std_logic_vector(11 downto 6);
  signal mb_q     : std_logic_vector( 1 downto 0);
  signal mc_q     : std_logic_vector( 6 downto 0);
  signal cl_q     : std_logic_vector( 4 downto 0);

  signal j7_s     : std_logic_vector(qc_c downto qa_c);
  signal mc_6_n_s : std_logic;

  signal clk_en_eck_s,
         clk_en_rd_s,
         clk_en_5ck_n_s,
         clk_en_6ck_n_s,
         clk_en_7ck_n_s  : std_logic;
  signal clk_en_b7_p3_s  : std_logic;
  signal clk_en_e7_3_s   : std_logic;
  signal s6ck_n_s,
         s7ck_n_s        : std_logic;
  signal e5_p8_s         : std_logic;
  signal a8_p5_n_s       : std_logic;

  signal c7_p13_s        : std_logic;

  signal df_muxed_s      : std_logic_vector( 7 downto 0);

  signal ct0_s,
         ct1_s           : std_logic;
  signal ct_shift_s      : std_logic;

  signal ck_inh_s,
         ck_inh_n_q      : std_logic;
  signal qh1_s,
         qh2_s           : std_logic;

  signal lu_a_s          : std_logic_vector( 4 downto 0);
  signal lu_d_s          : std_logic_vector( 7 downto 0);
  signal lu_d_mux_s      : std_logic_vector( 3 downto 0);

  signal rd_shift_s,
         rd_vram_s       : std_logic_vector(15 downto 0);
  signal rs_s,
         rs_n_s          : std_logic_vector( 3 downto 0);
  signal rs_enable_s     : std_logic;
  signal f8_ser_s        : std_logic;
  signal clk_en_shift_s  : std_logic;
  signal shift_oc_n_s    : std_logic;

  signal ctrl_lu_a_s     : std_logic_vector( 4 downto 0);
  signal ctrl_lu_d_s     : std_logic_vector( 7 downto 0);

  signal ctrl_lu_q_d_s,
         ctrl_lu_q       : std_logic_vector( 6 downto 1);

  signal vram_we_n_s     : std_logic;
  signal vram_a6_in_s,
         vram_a6_out_s,
         vram_b6_in_s,
         vram_b6_out_s,
         vram_c6_in_s,
         vram_c6_out_s,
         vram_d6_in_s,
         vram_d6_out_s   : std_logic_vector( 3 downto 0);

  signal cr_mux_sel_s    : std_logic;

  signal rc6_n_s,
         rc7_n_s         : std_logic;
  signal a6_carry_s      : std_logic;

  signal ca_q            : std_logic_vector( 3 downto 1);
  signal ca6_s,
         ca7_s,
         ca8_s           : std_logic;
  signal x_s             : std_logic_vector( 5 downto 0);

  signal cr_s            : std_logic_vector( 9 downto 0);

  signal vram_q          : std_logic_vector(15 downto 0);

  signal flip_screen_s   : std_logic;

  signal vdd_s,
         gnd_s  : std_logic;

begin

  vdd_s <= '1';
  gnd_s <= '0';

  -- derive flip screen information from generic
  flip_screen_s <=   '1'
                   when flip_screen_g = 1 else
                     '0';


  -----------------------------------------------------------------------------
  -- The Vertical Counters
  -----------------------------------------------------------------------------
  v_cnt_d5_b : ttl_161
    port map (
      ck_i      => clk_20mhz_i,
      ck_en_i   => clk_en_b7_p3_s,
      por_n_i   => por_n_i,
      cl_n_i    => vdd_s,
      p_i       => vdd_s,
      t_i       => vdd_s,
      lo_n_i    => e5_p8_s,
      a_i       => gnd_s,
      b_i       => v_t_i(VA_c),
      c_i       => v_t_i(VB_c),
      d_i       => v_t_i(VC_c),
      qa_o      => v_cnt_s(0),
      qb_o      => v_cnt_s(1),
      qc_o      => v_cnt_s(2),
      qd_o      => v_cnt_s(3),
      co_o      => v_cnt_carry_s,
      rise_qa_o => open,
      rise_qb_o => open,
      rise_qc_o => open,
      rise_qd_o => open,
      da_o      => open,
      db_o      => open,
      dc_o      => open,
      dd_o      => open
    );

  v_cnt_c5_b : ttl_161
    port map (
      ck_i      => clk_20mhz_i,
      ck_en_i   => clk_en_b7_p3_s,
      por_n_i   => por_n_i,
      cl_n_i    => vdd_s,
      p_i       => v_cnt_carry_s,
      t_i       => v_cnt_carry_s,
      lo_n_i    => e5_p8_s,
      a_i       => v_t_i(VD_c),
      b_i       => vdd_s,
      c_i       => vdd_s,
      d_i       => vdd_s,
      qa_o      => v_cnt_s(4),
      qb_o      => open,
      qc_o      => open,
      qd_o      => open,
      co_o      => open,
      rise_qa_o => open,
      rise_qb_o => open,
      rise_qc_o => open,
      rise_qd_o => open,
      da_o      => open,
      db_o      => open,
      dc_o      => open,
      dd_o      => open
    );


  -----------------------------------------------------------------------------
  -- Process sprite_ram_ctrl
  --
  -- Purpose:
  --   Generates the control signals for the sprite RAM.
  --
  sprite_ram_ctrl: process (cs7_n_i,
                            vbl_n_i,
                            a_i,
                            c_s, v_cnt_s)
    variable cpu_access_v : std_logic;
  begin
    vbl_buf_o         <= not vbl_n_i;

    cpu_access_v      := not cs7_n_i and not vbl_n_i;

    sprite_ram_we_n_s <= not cpu_access_v;
    sprite_ram_cs_n_s <= cpu_access_v nor vbl_n_i;

    if vbl_n_i = '0' then
      ra_s <= a_i;
    else
      ra_s(4 downto 0) <= c_s(4 downto 0);
      ra_s(9 downto 5) <= v_cnt_s(4 downto 0);
    end if;
  end process sprite_ram_ctrl;
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Process flip
  --
  -- Purpose:
  --   Generate the flipped version of several signals.
  --
  flip: process (flip_screen_s,
                 s7ck_n_s,
                 rb_unflip_s)
  begin
    for idx in 0 to rb_unflip_s'high loop
      rb_s(idx) <= rb_unflip_s(idx) xor (flip_screen_s and not s7ck_n_s);
    end loop;
  end process flip;
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- The Sprite RAM
  -----------------------------------------------------------------------------
  sprite_ram_b : ladybug_sprite_ram
    port map (
      clk_i    => clk_20mhz_i,
      clk_en_i => clk_en_4mhz_i,
      a_i      => ra_s,
      cs_n_i   => sprite_ram_cs_n_s,
      we_n_i   => sprite_ram_we_n_s,
      d_i      => d_from_cpu_i,
      d_o      => rb_unflip_s
    );


  -----------------------------------------------------------------------------
  -- Process rc_add
  --
  -- Purpose:
  --   Implements IC N6 and E6 which add sprite RAM data and Cx signals to
  --   form RCx bus.
  --
  rc_add: process (rb_s,
                   c_s,
                   v_i)
    variable a_v, b_v,
             sum_v     : unsigned(8 downto 0);
  begin
    -- prepare the inputs of the adder
    a_v(3 downto 0) := unsigned(rb_s(3 downto 0));
    a_v(4)          := '1';
    a_v(5)          := '0';
    a_v(7 downto 6) := unsigned(rb_s(1 downto 0));
    a_v(8)          := '0';

    b_v(0)          := not c_s(6);
    b_v(1)          := not c_s(7);
    b_v(2)          := not c_s(8);
    b_v(3)          := not v_i(VD_c);
    b_v(4)          := c_s(10);
    b_v(5)          := '0';
    b_v(7 downto 6) := "11";
    b_v(8)          := '0';

    sum_v := a_v + b_v;

    rc_s  <= std_logic_vector(sum_v(7 downto 0));

  end process rc_add;
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Sprite Control Logic
  -----------------------------------------------------------------------------
  sprite_ctrl_b : ladybug_sprite_ctrl
    port map (
      clk_20mhz_i     => clk_20mhz_i,
      clk_en_5mhz_i   => clk_en_5mhz_i,
      clk_en_5mhz_n_i => clk_en_5mhz_n_i,
      por_n_i         => por_n_i,
      vbl_n_i         => vbl_n_i,
      vbl_d_n_i       => vbl_d_n_i,
      vc_i            => v_i(VC_c),
      vc_d_i          => vc_d_i,
      ha_i            => h_i(HA_c),
      ha_d_i          => ha_d_i,
      rb6_i           => rb_s(6),
      rb7_i           => rb_s(7),
      rc3_i           => rc_s(3),
      rc4_i           => rc_s(4),
      rc5_i           => rc_s(5),
      j7_b_i          => j7_s(qb_c),
      j7_c_i          => j7_s(qc_c),
      clk_en_eck_i    => clk_en_eck_s,
      c_o             => c_s,
      clk_en_5ck_n_o  => clk_en_5ck_n_s,
      clk_en_6ck_n_o  => clk_en_6ck_n_s,
      clk_en_7ck_n_o  => clk_en_7ck_n_s,
      s6ck_n_o        => s6ck_n_s,
      s7ck_n_o        => s7ck_n_s,
      clk_en_b7_p3_o  => clk_en_b7_p3_s,
      e5_p8_o         => e5_p8_s,
      clk_en_e7_3_o   => clk_en_e7_3_s,
      a8_p5_n_o       => a8_p5_n_s
    );


  -----------------------------------------------------------------------------
  -- Process misc_seq
  --
  -- Purpose:
  --   Implements several sequential elements.
  --
  misc_seq: process (clk_20mhz_i, por_n_i)
  begin
    if por_n_i = '0' then
      clk_5mhz_n_q <= '0';
      ma_q         <= (others => '0');
      mb_q         <= (others => '0');
      mc_q         <= (others => '0');
      cl_q         <= (others => '0');
      ck_inh_n_q   <= '1';

    elsif clk_20mhz_i'event and clk_20mhz_i = '1' then
      -- Turn clk_5mhz_n into clock waveform ----------------------------------
      if clk_en_5mhz_n_i = '1' then
        clk_5mhz_n_q <= '1';
      elsif clk_en_5mhz_i = '1' then
        clk_5mhz_n_q <= '0';
      end if;

      -- 8-Bit Register M6 ----------------------------------------------------
      if clk_en_5ck_n_s = '1' then
        mb_q <= rb_s(1 downto 0);
        ma_q <= rb_s(7 downto 2);
      end if;

      -- 8-Bit Register P6 ----------------------------------------------------
      if clk_en_e7_3_s = '1' then
        mc_q(3 downto 0) <= rc_s(3 downto 0);
        mc_q(4)          <= rb_s(4) xor flip_screen_s;
        mc_q(5)          <= rb_s(5) xor flip_screen_s;
        mc_q(6)          <= rb_s(6);
      end if;

      -- 6-Bit Register B6 ----------------------------------------------------
      if clk_en_6ck_n_s = '1' then
        cl_q <= rb_s(4 downto 0);
      end if;

      -- Flip-Flop H8 ---------------------------------------------------------
      if clk_en_10mhz_n_i = '1' then
        ck_inh_n_q <= not ck_inh_s;
      end if;

    end if;
  end process misc_seq;
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- J7 - An Anonymous Counter
  -----------------------------------------------------------------------------
  mc_6_n_s <= not mc_q(6);
  c7_p13_s <= not ct_shift_s and not ck_inh_s;
  j7_b : ttl_161
    port map (
      ck_i      => clk_20mhz_i,
      ck_en_i   => clk_en_10mhz_i,
      por_n_i   => por_n_i,
      cl_n_i    => vdd_s,
      p_i       => c7_p13_s,
      t_i       => c7_p13_s,
      lo_n_i    => s6ck_n_s,
      a_i       => gnd_s,
      b_i       => mc_q(6),
      c_i       => mc_6_n_s,
      d_i       => vdd_s,
      qa_o      => j7_s(qa_c),
      qb_o      => j7_s(qb_c),
      qc_o      => j7_s(qc_c),
      qd_o      => open,
      co_o      => open,
      rise_qa_o => open,
      rise_qb_o => open,
      rise_qc_o => open,
      rise_qd_o => open,
      da_o      => open,
      db_o      => open,
      dc_o      => open,
      dd_o      => open
    );


  -----------------------------------------------------------------------------
  -- Process ma_vec
  --
  -- Purpose:
  --   Build the ma_s vector.
  --
  ma_vec: process (ma_q,
                   mb_q,
                   mc_q,
                   j7_s)
  begin
    ma_s(11 downto 6)  <= ma_q;

    if mc_q(6) = '0' then
      ma_s(5 downto 4) <= mb_q;
    else
      ma_s(5)          <= mc_q(3) xor mc_q(4);
      ma_s(4)          <= mc_q(5) xor j7_s(qc_c);
    end if;
                         
    ma_s(3)            <= mc_q(2) xor mc_q(4);
    ma_s(2)            <= mc_q(1) xor mc_q(4);
    ma_s(1)            <= mc_q(0) xor mc_q(4);
    ma_s(0)            <= mc_q(5) xor j7_s(qa_c);
  end process ma_vec;
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Process df_mux
  --
  -- Purpose:
  --   Builds the multiplexed data from Sprite ROM.
  --   Two-stage multiplexer:
  --     1) ROM data to DFx: 16->8
  --     2) DF to input for shift register: 8->8
  --        This is actually a scrambler.
  --
  df_mux: process (rom_sprite_d_i,
                   cl_q,
                   mc_q)
    variable df_v : std_logic_vector(7 downto 0);
  begin
    if cl_q(4) = '0' then
      -- ROM L7
      df_v := rom_sprite_d_i( 7 downto 0);
    else
      -- ROM M7
      df_v := rom_sprite_d_i(15 downto 8);
    end if;

    if mc_q(5) = '0' then
      df_muxed_s(0) <= df_v(1);
      df_muxed_s(1) <= df_v(3);
      df_muxed_s(2) <= df_v(5);
      df_muxed_s(3) <= df_v(7);
      --
      df_muxed_s(4) <= df_v(0);
      df_muxed_s(5) <= df_v(2);
      df_muxed_s(6) <= df_v(4);
      df_muxed_s(7) <= df_v(6);
    else
      df_muxed_s(0) <= df_v(7);
      df_muxed_s(1) <= df_v(5);
      df_muxed_s(2) <= df_v(3);
      df_muxed_s(3) <= df_v(1);
      --
      df_muxed_s(4) <= df_v(6);
      df_muxed_s(5) <= df_v(4);
      df_muxed_s(6) <= df_v(2);
      df_muxed_s(7) <= df_v(0);
    end if;

  end process df_mux;
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- The Two 8-Bit Shift Registers
  -----------------------------------------------------------------------------
  ct_shift_s <= not (not ct0_s and not ct1_s and not a8_p5_n_s);
  h6_b : ttl_166
    port map (
      clk_i     => clk_20mhz_i,
      clk_en_i  => clk_en_10mhz_i,
      por_n_i   => por_n_i,
      clk_inh_i => ck_inh_s,
      clr_n_i   => vdd_s,
      sh_i      => ct_shift_s,
      ser_i     => gnd_s,
      a_i       => gnd_s,
      b_i       => gnd_s,
      c_i       => gnd_s,
      d_i       => gnd_s,
      e_i       => df_muxed_s(0),
      f_i       => df_muxed_s(1),
      g_i       => df_muxed_s(2),
      h_i       => df_muxed_s(3),
      qh_o      => qh1_s
    );

  j6_b : ttl_166
    port map (
      clk_i     => clk_20mhz_i,
      clk_en_i  => clk_en_10mhz_i,
      por_n_i   => por_n_i,
      clk_inh_i => ck_inh_s,
      clr_n_i   => vdd_s,
      sh_i      => ct_shift_s,
      ser_i     => gnd_s,
      a_i       => gnd_s,
      b_i       => gnd_s,
      c_i       => gnd_s,
      d_i       => gnd_s,
      e_i       => df_muxed_s(4),
      f_i       => df_muxed_s(5),
      g_i       => df_muxed_s(6),
      h_i       => df_muxed_s(7),
      qh_o      => qh2_s
    );


  -----------------------------------------------------------------------------
  -- Sprite Look-up PROM
  -----------------------------------------------------------------------------
  lu_a_s(4 downto 2) <= cl_q(2 downto 0);
  lu_a_s(1)          <= qh2_s;
  lu_a_s(0)          <= qh1_s;
  lu_b : ladybug_sprite_lu_prom
    port map (
      clk_i => clk_20mhz_i,
      a_i   => lu_a_s,
      d_o   => lu_d_s
    );

  lu_d_mux_s <=   lu_d_s(3 downto 0)
                when cl_q(3) = '0' else
                  lu_d_s(7 downto 4);


  -----------------------------------------------------------------------------
  -- Shift Registers
  -----------------------------------------------------------------------------
  clk_en_shift_s <= clk_en_10mhz_i and not ck_inh_s;
  shifters: for idx in 0 to 3 generate
    shifter : ttl_395
      port map (
        clk_i     => clk_20mhz_i,
        ck_en_i   => clk_en_shift_s,
        por_n_i   => por_n_i,
        clr_n_i   => vdd_s,
        oc_n_i    => shift_oc_n_s,
        ld_sh_n_i => gnd_s,
        ser_i     => lu_d_mux_s(idx),
        a_i       => gnd_s,
        b_i       => gnd_s,
        c_i       => gnd_s,
        d_i       => gnd_s,
        qa_o      => rd_shift_s(15 - 4*idx),
        qb_o      => rd_shift_s(14 - 4*idx),
        qc_o      => rd_shift_s(13 - 4*idx),
        qd_o      => rd_shift_s(12 - 4*idx),
        qd_t_o    => open
      );
  end generate;

  f8_ser_s <= qh1_s nor qh2_s;
  f8_b : ttl_395
    port map (
      clk_i     => clk_20mhz_i,
      ck_en_i   => clk_en_shift_s,
      por_n_i   => por_n_i,
      clr_n_i   => vdd_s,
      oc_n_i    => shift_oc_n_s,
      ld_sh_n_i => gnd_s,
      ser_i     => f8_ser_s,
      a_i       => gnd_s,
      b_i       => gnd_s,
      c_i       => gnd_s,
      d_i       => gnd_s,
      qa_o      => rs_s(3),
      qb_o      => rs_s(2),
      qc_o      => rs_s(1),
      qd_o      => rs_s(0),
      qd_t_o    => open
    );
--  rs_n_s(3) <= not rs_s(3) or not rs_enable_s;
--  rs_n_s(2) <= not rs_s(2) or not rs_enable_s;
--  rs_n_s(1) <= not rs_s(1) or not rs_enable_s;
--  rs_n_s(0) <= not rs_s(0) or not rs_enable_s;
  rs_n_s(3) <= rs_s(3) and rs_enable_s;
  rs_n_s(2) <= rs_s(2) and rs_enable_s;
  rs_n_s(1) <= rs_s(1) and rs_enable_s;
  rs_n_s(0) <= rs_s(0) and rs_enable_s;


  -----------------------------------------------------------------------------
  -- Sprite Control Look-up PROM
  -----------------------------------------------------------------------------
  ctrl_lu_a_s(0) <= '1';
  ctrl_lu_a_s(1) <= hx_i;
  ctrl_lu_a_s(2) <= clk_5mhz_n_q;
  ctrl_lu_a_s(3) <= h_i(HA_c);
  ctrl_lu_a_s(4) <= h_i(HB_c);
  ctrl_lu_b : ladybug_sprite_ctrl_lu_prom
    port map (
      clk_i => clk_20mhz_i,
      a_i   => ctrl_lu_a_s,
      d_o   => ctrl_lu_d_s
    );


  -----------------------------------------------------------------------------
  -- Process ctrl_lu_seq
  --
  -- Purpose:
  --   Registers output of Sprite Control Look-up PROM.
  --
  ctrl_lu_seq: process (clk_20mhz_i, por_n_i)
  begin
    if por_n_i = '0' then
      ctrl_lu_q <= (others => '0');
    elsif clk_20mhz_i'event and clk_20mhz_i = '1' then
      ctrl_lu_q <= ctrl_lu_q_d_s;
    end if;
  end process ctrl_lu_seq;
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Process ctrl_lu_comb
  --
  -- Purpose:
  --   Combinational logic for the sprite control registers.
  --
  ctrl_lu_comb: process (clk_en_10mhz_i,
                         ctrl_lu_d_s,
                         ctrl_lu_q,
                         ctrl_lu_q_d_s)
  begin
    -- default assignments
    ctrl_lu_q_d_s <= ctrl_lu_q;
    clk_en_eck_s  <= '0';
    clk_en_rd_s   <= '0';

    -- register control
    if clk_en_10mhz_i = '1' then
      ctrl_lu_q_d_s  <= ctrl_lu_d_s(5 downto 0);

      if ctrl_lu_q(1) = '0' and ctrl_lu_q_d_s(1) = '1' then
        -- detect rising edge on ctrl_lu_q(1)
        clk_en_eck_s <= '1';
      end if;

      if ctrl_lu_q(6) = '0' and ctrl_lu_q_d_s(6) = '1' then
        -- detect rising edge on ctrl_lu_q(6)
        clk_en_rd_s  <= '1';
      end if;
    end if;
    
  end process ctrl_lu_comb;
  --
  shift_oc_n_s <= ctrl_lu_q(1) nand res_n_i;
  ck_inh_s     <= ctrl_lu_q(2);
  cr_mux_sel_s <= ctrl_lu_q(3);
  vram_we_n_s  <= ctrl_lu_q(4);
  rs_enable_s  <= ctrl_lu_q(5);
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Sprite VRAM Counters
  -----------------------------------------------------------------------------
  rc6_n_s <= not rc_s(6);
  rc7_n_s <= not rc_s(7);
  a6_b : ttl_161
    port map (
      ck_i      => clk_20mhz_i,
      ck_en_i   => clk_en_10mhz_i,
      por_n_i   => por_n_i,
      cl_n_i    => vdd_s,
      p_i       => ck_inh_n_q,
      t_i       => ck_inh_n_q,
      lo_n_i    => s7ck_n_s,
      a_i       => rc6_n_s,
      b_i       => rc7_n_s,
      c_i       => rb_s(2),
      d_i       => rb_s(3),
      qa_o      => ct0_s,
      qb_o      => ct1_s,
      qc_o      => x_s(0),
      qd_o      => x_s(1),
      co_o      => a6_carry_s,
      rise_qa_o => open,
      rise_qb_o => open,
      rise_qc_o => open,
      rise_qd_o => open,
      da_o      => open,
      db_o      => open,
      dc_o      => open,
      dd_o      => open
    );

  a5_b : ttl_161
    port map (
      ck_i      => clk_20mhz_i,
      ck_en_i   => clk_en_10mhz_i,
      por_n_i   => por_n_i,
      cl_n_i    => vdd_s,
      p_i       => a6_carry_s,
      t_i       => a6_carry_s,
      lo_n_i    => s7ck_n_s,
      a_i       => rb_s(4),
      b_i       => rb_s(5),
      c_i       => rb_s(6),
      d_i       => rb_s(7),
      qa_o      => x_s(2),
      qb_o      => x_s(3),
      qc_o      => x_s(4),
      qd_o      => x_s(5),
      co_o      => open,
      rise_qa_o => open,
      rise_qb_o => open,
      rise_qc_o => open,
      rise_qd_o => open,
      da_o      => open,
      db_o      => open,
      dc_o      => open,
      dd_o      => open
    );


  -----------------------------------------------------------------------------
  -- Process ca_seq
  --
  -- Purpose:
  --   Implements B5, the register that holds the CS flip-flops.
  --
  ca_seq: process (clk_20mhz_i, por_n_i)
  begin
    if por_n_i = '0' then
      ca_q   <= (others => '0');
    elsif clk_20mhz_i'event and clk_20mhz_i = '1' then
      if clk_en_7ck_n_s = '1' then
        ca_q <= c_s(8 downto 6);
      end if;
    end if;
  end process ca_seq;
  --
  ca6_s <= ca_q(1);
  ca7_s <= ca_q(2);
  ca8_s <= ca_q(3);
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Process vram_mux
  --
  -- Purpose:
  --   Generates the VRAM address CRx.
  --   It implements chips D5, C5 and B5.
  --
  vram_mux: process (h_i, h_t_i,
                     v_i,
                     x_s,
                     ca6_s, ca7_s, ca8_s,
                     cr_mux_sel_s)
  begin
    if cr_mux_sel_s = '0' then
      -- D5
      cr_s(0) <= h_i(HC_c);
      cr_s(1) <= h_i(HD_c);
      cr_s(2) <= h_t_i(HA_c);
      cr_s(3) <= h_t_i(HB_c);
      -- C5
      cr_s(4) <= h_t_i(HC_c);
      cr_s(5) <= h_t_i(HD_c);
      cr_s(6) <= v_i(VA_c);
      cr_s(7) <= v_i(VB_c);
      -- B5
      cr_s(8) <= v_i(VC_c);
      cr_s(9) <= v_i(VD_c);

    else
      -- D5
      cr_s(0) <= x_s(0);
      cr_s(1) <= x_s(1);
      cr_s(2) <= x_s(2);
      cr_s(3) <= x_s(3);
      -- C5
      cr_s(4) <= x_s(4);
      cr_s(5) <= x_s(5);
      cr_s(6) <= ca6_s;
      cr_s(7) <= ca7_s;
      -- B5
      cr_s(8) <= ca8_s;
      cr_s(9) <= not v_i(VD_c);

    end if;
  end process vram_mux;
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Sprite VRAM
  -----------------------------------------------------------------------------
  vram_a6_in_s(0) <= rd_shift_s( 0);
  vram_a6_in_s(1) <= rd_shift_s( 4);
  vram_a6_in_s(2) <= rd_shift_s( 8);
  vram_a6_in_s(3) <= rd_shift_s(12);
  vram_a6_b : ladybug_sprite_vram
    port map (
      clk_i    => clk_20mhz_i,
      clk_en_i => vdd_s,
      a_i      => cr_s,
      cs_n_i   => rs_n_s(0),
      we_n_i   => vram_we_n_s,
      d_i      => vram_a6_in_s,
      d_o      => vram_a6_out_s
    );
  --
  vram_b6_in_s(0) <= rd_shift_s( 1);
  vram_b6_in_s(1) <= rd_shift_s( 5);
  vram_b6_in_s(2) <= rd_shift_s( 9);
  vram_b6_in_s(3) <= rd_shift_s(13);
  vram_b6_b : ladybug_sprite_vram
    port map (
      clk_i    => clk_20mhz_i,
      clk_en_i => vdd_s,
      a_i      => cr_s,
      cs_n_i   => rs_n_s(1),
      we_n_i   => vram_we_n_s,
      d_i      => vram_b6_in_s,
      d_o      => vram_b6_out_s
    );
  --
  vram_c6_in_s(0) <= rd_shift_s( 2);
  vram_c6_in_s(1) <= rd_shift_s( 6);
  vram_c6_in_s(2) <= rd_shift_s(10);
  vram_c6_in_s(3) <= rd_shift_s(14);
  vram_c6_b : ladybug_sprite_vram
    port map (
      clk_i    => clk_20mhz_i,
      clk_en_i => vdd_s,
      a_i      => cr_s,
      cs_n_i   => rs_n_s(2),
      we_n_i   => vram_we_n_s,
      d_i      => vram_c6_in_s,
      d_o      => vram_c6_out_s
    );
  --
  vram_d6_in_s(0) <= rd_shift_s( 3);
  vram_d6_in_s(1) <= rd_shift_s( 7);
  vram_d6_in_s(2) <= rd_shift_s(11);
  vram_d6_in_s(3) <= rd_shift_s(15);
  vram_d6_b : ladybug_sprite_vram
    port map (
      clk_i    => clk_20mhz_i,
      clk_en_i => vdd_s,
      a_i      => cr_s,
      cs_n_i   => rs_n_s(3),
      we_n_i   => vram_we_n_s,
      d_i      => vram_d6_in_s,
      d_o      => vram_d6_out_s
    );
  -- Remap VRAM data outputs to the complete bus ------------------------------
  rd_vram_s(15) <= vram_d6_out_s(3) or rs_n_s(3);
  rd_vram_s(14) <= vram_c6_out_s(3) or rs_n_s(2);
  rd_vram_s(13) <= vram_b6_out_s(3) or rs_n_s(1);
  rd_vram_s(12) <= vram_a6_out_s(3) or rs_n_s(0);
  --
  rd_vram_s(11) <= vram_d6_out_s(2) or rs_n_s(3);
  rd_vram_s(10) <= vram_c6_out_s(2) or rs_n_s(2);
  rd_vram_s( 9) <= vram_b6_out_s(2) or rs_n_s(1);
  rd_vram_s( 8) <= vram_a6_out_s(2) or rs_n_s(0);
  --
  rd_vram_s( 7) <= vram_d6_out_s(1) or rs_n_s(3);
  rd_vram_s( 6) <= vram_c6_out_s(1) or rs_n_s(2);
  rd_vram_s( 5) <= vram_b6_out_s(1) or rs_n_s(1);
  rd_vram_s( 4) <= vram_a6_out_s(1) or rs_n_s(0);
  --
  rd_vram_s( 3) <= vram_d6_out_s(0) or rs_n_s(3);
  rd_vram_s( 2) <= vram_c6_out_s(0) or rs_n_s(2);
  rd_vram_s( 1) <= vram_b6_out_s(0) or rs_n_s(1);
  rd_vram_s( 0) <= vram_a6_out_s(0) or rs_n_s(0);
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Process rd_seq
  --
  -- Purpose:
  --   Implements the registers saving the RDx bus.
  --
  rd_seq: process (clk_20mhz_i, por_n_i)
  begin
    if por_n_i = '0' then
      vram_q <= (others => '0');
    elsif clk_20mhz_i'event and clk_20mhz_i = '1' then
      if blank_flont_i = '0' then
        -- pseudo-asynchronous clear
        vram_q   <= (others => '0');

      elsif clk_en_rd_s = '1' then
        if shift_oc_n_s = '0' then
          -- take data from shift registers
          vram_q <= rd_shift_s;
        else
          -- take data from VRAM
          vram_q <= rd_vram_s;
        end if;
      end if;
    end if;
  end process rd_seq;
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Process sig_mux
  --
  -- Purpose:
  --   Multiplexes the saved VRAM data to generate the four SIG outputs.
  --
  sig_mux: process (vram_q,
                    h_i,
                    blank_i)
    variable vec_v : std_logic_vector(1 downto 0);
  begin
    -- default assignment
    sig_o <= (others => '0');

    vec_v := h_i(HB_c) & h_i(HA_c);

    if blank_i = '0' then
      case vec_v is
        when "00" =>
          sig_o(1) <= vram_q( 1);
          sig_o(2) <= vram_q( 5);
          sig_o(3) <= vram_q( 9);
          sig_o(4) <= vram_q(13);
        when "01" =>
          sig_o(1) <= vram_q( 2);
          sig_o(2) <= vram_q( 6);
          sig_o(3) <= vram_q(10);
          sig_o(4) <= vram_q(14);
        when "10" =>
          sig_o(1) <= vram_q( 3);
          sig_o(2) <= vram_q( 7);
          sig_o(3) <= vram_q(11);
          sig_o(4) <= vram_q(15);
        when "11" =>
          sig_o(1) <= vram_q( 0);
          sig_o(2) <= vram_q( 4);
          sig_o(3) <= vram_q( 8);
          sig_o(4) <= vram_q(12);
        when others =>
          null;
      end case;
    end if;
  end process sig_mux;
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Output Mapping
  -----------------------------------------------------------------------------
  rom_sprite_a_o <= ma_s;

end rtl;
