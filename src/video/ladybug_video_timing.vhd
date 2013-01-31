-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_video_timing.vhd,v 1.16 2006/02/07 19:27:38 arnim Exp $
--
-- The Video Timing Module of Lady Bug Machine.
--
-- It implements the horizontal and vertical timing signals including composite
-- sync information.
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

entity ladybug_video_timing is

  port (
    -- Clock and Reset Interface ----------------------------------------------
    clk_20mhz_i     : in  std_logic;
    por_n_i         : in  std_logic;
    clk_en_5mhz_i   : in  std_logic;
    -- Horizontal Timing Interface --------------------------------------------
    h_o             : out std_logic_vector(3 downto 0);
    h_t_o           : out std_logic_vector(3 downto 0);
    hbl_o           : out std_logic;
    hx_o            : out std_logic;
    ha_d_o          : out std_logic;
    ha_t_rise_o     : out std_logic;
    -- Vertical Timing Interface ----------------------------------------------
    v_o             : out std_logic_vector(3 downto 0);
    v_t_o           : out std_logic_vector(3 downto 0);
    vc_d_o          : out std_logic;
    vbl_n_o         : out std_logic;
    vbl_d_n_o       : out std_logic;
    vbl_t_n_o       : out std_logic;
    blank_flont_o   : out std_logic;
    -- RBG Video Interface ----------------------------------------------------
    hsync_n_o       : out std_logic;
    vsync_n_o       : out std_logic;
    comp_sync_n_o   : out std_logic
  );

end ladybug_video_timing;


library ieee;
use ieee.numeric_std.all;

use work.ladybug_video_pack.all;
use work.ttl_comp_pack.ttl_161;

architecture rtl of ladybug_video_timing is

  -- horizontal timing circuit
  signal h_s,
         h_t_s           : std_logic_vector(3 downto 0);
  signal hx_q,
         hx_s,
         hx_n_s          : std_logic;
  signal hx_rise_s       : std_logic;
  signal hbl_q,
         hbl_n_s         : std_logic;
  signal hsync_q         : std_logic;
  signal h_carry_s,
         h_t_carry_s,
         h_carry_and_n_s : std_logic;
  signal hd_rise_s       : std_logic;

  -- vertical timing circuit
  signal v_s,
         v_t_s           : std_logic_vector(3 downto 0);
  signal vx_q,
         vx_n_s          : std_logic;
  signal vbl_q,
         vbl_s,
         vbl_n_s         : std_logic;
  signal vbl_t_q,
         vbl_t_s,
         vbl_t_n_s       : std_logic;
  signal vsync_n_q       : std_logic;
  signal v_carry_s,
         v_t_carry_s,
         v_carry_and_n_s : std_logic;
  signal vc_rise_s,
         vd_rise_s       : std_logic;
  signal vb_t_rise_s     : std_logic;

  signal vdd_s,
         gnd_s  : std_logic;

begin

  vdd_s <= '1';
  gnd_s <= '0';


  -----------------------------------------------------------------------------
  -- Horizontal Timing
  -----------------------------------------------------------------------------
  h_counter_b : ttl_161
    port map (
      ck_i      => clk_20mhz_i,
      ck_en_i   => clk_en_5mhz_i,
      por_n_i   => por_n_i,
      cl_n_i    => vdd_s,
      p_i       => vdd_s,
      t_i       => vdd_s,
      lo_n_i    => h_carry_and_n_s,
      a_i       => gnd_s,
      b_i       => gnd_s,
      c_i       => gnd_s,
      d_i       => hx_n_s,
      qa_o      => h_s(HA_c),
      qb_o      => h_s(HB_c),
      qc_o      => h_s(HC_c),
      qd_o      => h_s(HD_c),
      co_o      => h_carry_s,
      rise_qa_o => open,
      rise_qb_o => open,
      rise_qc_o => open,
      rise_qd_o => hd_rise_s,
      da_o      => ha_d_o,
      db_o      => open,
      dc_o      => open,
      dd_o      => open
    );
  h_t_counter_b : ttl_161
    port map (
      ck_i      => clk_20mhz_i,
      ck_en_i   => clk_en_5mhz_i,
      por_n_i   => por_n_i,
      cl_n_i    => vdd_s,
      p_i       => h_carry_s,
      t_i       => h_s(HD_c),
      lo_n_i    => h_carry_and_n_s,
      a_i       => gnd_s,
      b_i       => gnd_s,
      c_i       => hx_n_s,
      d_i       => hx_n_s,
      qa_o      => h_t_s(HA_c),
      qb_o      => h_t_s(HB_c),
      qc_o      => h_t_s(HC_c),
      qd_o      => h_t_s(HD_c),
      co_o      => h_t_carry_s,
      rise_qa_o => ha_t_rise_o,
      rise_qb_o => open,
      rise_qc_o => open,
      rise_qd_o => open,
      da_o      => open,
      db_o      => open,
      dc_o      => open,
      dd_o      => open
    );

  h_carry_and_n_s <= not (h_carry_s and h_t_carry_s);


  -----------------------------------------------------------------------------
  -- Process h_timing
  --
  -- Purpose:
  --   Implement the horizontal timing circuit.
  --
  --   The original circuit has no asynchronous reset. To have a stable
  --   behavior on silicon, all sequential elements are cleared with the
  --   power-on reset. This assumes that the original chips power-up to
  --   these values.
  --
  --   See also instantiations of ttl_161.
  --
  h_timing: process (clk_20mhz_i, por_n_i)
  begin
    if por_n_i = '0' then
      hx_q      <= '0';
      hbl_q     <= '0';
      hsync_q   <= '1';

    elsif clk_20mhz_i'event and clk_20mhz_i = '1' then
      -- Flip-flops on 5 MHz clock --------------------------------------------
      -- HX
      hx_q <= hx_s;

      -- Free running flip-flops ----------------------------------------------
      -- HBL
      if (hx_q and not h_s(HD_c)) = '1' then
        -- pseudo-asynchronous preset
        hbl_q <= '1';
      elsif hd_rise_s = '1' then
        -- Rising edge on HD
        hbl_q <= hx_q;
      end if;

      -- HSYNC
      if hx_q = '0' then
        -- pseudo-asynchronous preset
        hsync_q   <= '0';
      elsif hd_rise_s = '1' then
        -- rising edge on HD
        hsync_q   <= not h_t_s(HB_c);
      end if;

    end if;

  end process h_timing;
  --
  -----------------------------------------------------------------------------

  hx_n_s  <= not hx_q;
  hbl_n_s <= not hbl_q;


  -----------------------------------------------------------------------------
  -- Process hx_comb
  --
  -- Purpose:
  --   Implements the combinational logic for hx. Including rising edge
  --   detection.
  --
  hx_comb: process (clk_en_5mhz_i,
                    h_carry_and_n_s,
                    hx_q)
  begin
    -- default assignments
    hx_s      <= hx_q;
    hx_rise_s <= '0';

    -- HX
    if clk_en_5mhz_i = '1' then
      if h_carry_and_n_s = '0' then
        hx_s        <= not hx_q;

        -- flag rising edge of hx_q
        if hx_q = '0' then
          hx_rise_s <= '1';
        end if;
      end if;
    end if;

  end process hx_comb;
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Vertical Timing
  -----------------------------------------------------------------------------
  v_counter_b : ttl_161
    port map (
      ck_i      => clk_20mhz_i,
      ck_en_i   => hx_rise_s,
      por_n_i   => por_n_i,
      cl_n_i    => vdd_s,
      p_i       => vdd_s,
      t_i       => vdd_s,
      lo_n_i    => v_carry_and_n_s,
      a_i       => gnd_s,
      b_i       => vx_n_s,
      c_i       => gnd_s,
      d_i       => vx_n_s,
      qa_o      => v_s(VA_c),
      qb_o      => v_s(VB_c),
      qc_o      => v_s(VC_c),
      qd_o      => v_s(VD_c),
      co_o      => v_carry_s,
      rise_qa_o => open,
      rise_qb_o => open,
      rise_qc_o => vc_rise_s,
      rise_qd_o => vd_rise_s,
      da_o      => open,
      db_o      => open,
      dc_o      => vc_d_o,
      dd_o      => open
    );

  v_t_counter_b : ttl_161
    port map (
      ck_i      => clk_20mhz_i,
      ck_en_i   => hx_rise_s,
      por_n_i   => por_n_i,
      cl_n_i    => vdd_s,
      p_i       => v_carry_s,
      t_i       => v_s(VD_c),
      lo_n_i    => v_carry_and_n_s,
      a_i       => vx_q,
      b_i       => vx_n_s,
      c_i       => vx_n_s,
      d_i       => vx_n_s,
      qa_o      => v_t_s(VA_c),
      qb_o      => v_t_s(VB_c),
      qc_o      => v_t_s(VC_c),
      qd_o      => v_t_s(VD_c),
      co_o      => v_t_carry_s,
      rise_qa_o => open,
      rise_qb_o => vb_t_rise_s,
      rise_qc_o => open,
      rise_qd_o => open,
      da_o      => open,
      db_o      => open,
      dc_o      => open,
      dd_o      => open
    );

  v_carry_and_n_s <= not (v_carry_s and v_t_carry_s);


  -----------------------------------------------------------------------------
  -- Process v_timing
  --
  -- Purpose:
  --   Implement the vertical timing circuit.
  --
  --   See process h_timing for reset discussion.
  --
  v_timing: process (clk_20mhz_i, por_n_i)
    variable preset_v : boolean;
  begin
    if por_n_i = '0' then
      vx_q      <= '0';
      vbl_q     <= '0';
      vsync_n_q <= '1';
      vbl_t_q   <= '0';

    elsif clk_20mhz_i'event and clk_20mhz_i = '1' then
      -- Free running flip-flops ----------------------------------------------
      -- VX
      if hx_rise_s = '1' then
        if v_carry_and_n_s = '0' then
          vx_q <= vx_n_s;
        end if;
      end if;

      -- VSYNC
      if vc_rise_s = '1' then
        -- rising edge on VC
        vsync_n_q <= not (v_t_carry_s and vx_n_s);
      end if;

      -- VBL
      vbl_q   <= vbl_s;

      -- VBL'
      vbl_t_q <= vbl_t_s;

    end if;
  end process v_timing;
  --
  -----------------------------------------------------------------------------

  vx_n_s    <= not vx_q;
  vbl_n_s   <= not vbl_q;
  vbl_t_n_s <= not vbl_t_q;


  -----------------------------------------------------------------------------
  -- Process vbl_comb
  --
  -- Purpose:
  --   Combinational logic for vbl_q and vbl_t_q.
  --
  vbl_comb: process (v_t_s,
                     vb_t_rise_s,
                     vd_rise_s,
                     vx_q,
                     vbl_q,
                     vbl_t_q)
    variable preset_v : boolean;
  begin
    preset_v := (v_t_s(VB_c) and v_t_s(VC_c) and v_t_s(VD_c)) = '1';
    -- VBL
    vbl_s   <= vbl_q;
    if preset_v then
      -- pseudo-asynchronous preset
      vbl_s <= '1';
    elsif vb_t_rise_s = '1' then
      -- rising edge on VB'
      vbl_s <= vx_q;
    end if;

    -- VBL'
    vbl_t_s   <= vbl_t_q;
    if preset_v then
      -- pseudo-asynchronous preset
      vbl_t_s <= '1';
    elsif vd_rise_s = '1' then
      -- rising edge on VD
      vbl_t_s <= vx_q;
    end if;

  end process vbl_comb;
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Output Mapping
  -----------------------------------------------------------------------------
  h_o           <= h_s;
  h_t_o         <= h_t_s;
  hbl_o         <= hbl_q;
  hx_o          <= hx_q;
  v_o           <= v_s;
  v_t_o         <= v_t_s;
  vbl_n_o       <= vbl_n_s;
  vbl_t_n_o     <= vbl_t_n_s;
  vbl_d_n_o     <= not vbl_s;
  hsync_n_o     <= not hsync_q;
  vsync_n_o     <= vsync_n_q;
  comp_sync_n_o <= hsync_q xor vsync_n_q;

  -- I have no idea why there is an additional wire called BLANK FLONT.
  -- From the schematics, it has the same as /VBL (just buffered).
  blank_flont_o <= vbl_n_s;

end rtl;
