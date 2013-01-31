-------------------------------------------------------------------------------
--
-- $Id: ttl_comp_pack-p.vhd,v 1.9 2005/10/10 21:59:13 arnim Exp $
--
-- Copyright (c) 2005, Arnim Laeuger (arnim.laeuger@gmx.net)
--
-- All rights reserved
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package ttl_comp_pack is

  function ttl_45_f(a, b, c, d : in std_logic) return
    std_logic_vector;

  component ttl_161
    port (
      ck_i      : in  std_logic;
      ck_en_i   : in  std_logic;
      por_n_i   : in  std_logic;
      cl_n_i    : in  std_logic;
      p_i       : in  std_logic;
      t_i       : in  std_logic;
      lo_n_i    : in  std_logic;
      a_i       : in  std_logic;
      b_i       : in  std_logic;
      c_i       : in  std_logic;
      d_i       : in  std_logic;
      qa_o      : out std_logic;
      qb_o      : out std_logic;
      qc_o      : out std_logic;
      qd_o      : out std_logic;
      co_o      : out std_logic;
      rise_qa_o : out std_logic;
      rise_qb_o : out std_logic;
      rise_qc_o : out std_logic;
      rise_qd_o : out std_logic;
      da_o      : out std_logic;
      db_o      : out std_logic;
      dc_o      : out std_logic;
      dd_o      : out std_logic
    );
  end component;

  component ttl_166
    port (
      clk_i     : in  std_logic;
      clk_en_i  : in  std_logic;
      por_n_i   : in  std_logic;
      clk_inh_i : in  std_logic;
      clr_n_i   : in  std_logic;
      sh_i      : in  std_logic;
      ser_i     : in  std_logic;
      a_i       : in  std_logic;
      b_i       : in  std_logic;
      c_i       : in  std_logic;
      d_i       : in  std_logic;
      e_i       : in  std_logic;
      f_i       : in  std_logic;
      g_i       : in  std_logic;
      h_i       : in  std_logic;
      qh_o      : out std_logic
    );
  end component;

  component ttl_175
    port (
      ck_i    : in  std_logic;
      ck_en_i : in  std_logic;
      por_n_i : in  std_logic;
      cl_n_i  : in  std_logic;
      d_i     : in  std_logic_vector(4 downto 1);
      q_o     : out std_logic_vector(4 downto 1);
      q_n_o   : out std_logic_vector(4 downto 1);
      d_o     : out std_logic_vector(4 downto 1);
      d_n_o   : out std_logic_vector(4 downto 1)
    );
  end component;

  component ttl_393
    port (
      ck_i    : in  std_logic;
      ck_en_i : in  std_logic_vector(2 downto 1);
      por_n_i : in  std_logic;
      cl_i    : in  std_logic_vector(2 downto 1);
      qa_o    : out std_logic_vector(2 downto 1);
      qb_o    : out std_logic_vector(2 downto 1);
      qc_o    : out std_logic_vector(2 downto 1);
      qd_o    : out std_logic_vector(2 downto 1);
      da_o    : out std_logic_vector(2 downto 1);
      db_o    : out std_logic_vector(2 downto 1);
      dc_o    : out std_logic_vector(2 downto 1);
      dd_o    : out std_logic_vector(2 downto 1)
    );
  end component;

  component ttl_395
    port (
      clk_i     : in  std_logic;
      ck_en_i   : in  std_logic;
      por_n_i   : in  std_logic;
      clr_n_i   : in  std_logic;
      oc_n_i    : in  std_logic;
      ld_sh_n_i : in  std_logic;
      ser_i     : in  std_logic;
      a_i       : in  std_logic;
      b_i       : in  std_logic;
      c_i       : in  std_logic;
      d_i       : in  std_logic;
      qa_o      : out std_logic;
      qb_o      : out std_logic;
      qc_o      : out std_logic;
      qd_o      : out std_logic;
      qd_t_o    : out std_logic
    );
  end component;

end ttl_comp_pack;


library ieee;
use ieee.numeric_std.all;

package body ttl_comp_pack is

  -----------------------------------------------------------------------------
  -- 7445 - BCD to Decimal Decoder
  -----------------------------------------------------------------------------
  function ttl_45_f(a, b, c, d : in std_logic) return
    std_logic_vector is
    variable idx_v : std_logic_vector( 3 downto 0);
    variable vec_v : std_logic_vector(15 downto 0);
  begin
    vec_v := (others => '1');

    idx_v := d & c & b & a;
    vec_v(to_integer(unsigned(idx_v))) := '0';

    return vec_v(7 downto 0);
  end ttl_45_f;

end ttl_comp_pack;
