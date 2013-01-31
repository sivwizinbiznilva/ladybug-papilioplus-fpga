-------------------------------------------------------------------------------
--
-- $Id: ladybug_cpu_comp_pack-p.vhd,v 1.7 2005/12/10 14:51:51 arnim Exp $
--
-- Copyright (c) 2005, Arnim Laeuger (arnim.laeuger@gmx.net)
--
-- All rights reserved
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

package ladybug_cpu_comp_pack is

  component ladybug_cpu_ram
    port (
      clk_i    : in  std_logic;
      clk_en_i : in  std_logic;
      a_i      : in  std_logic_vector(11 downto 0);
      cs_n_i   : in  std_logic;
      we_n_i   : in  std_logic;
      d_i      : in  std_logic_vector( 7 downto 0);
      d_o      : out std_logic_vector( 7 downto 0)
    );
  end component;

  component ladybug_addr_dec
    port (
      clk_20mhz_i    : in  std_logic;
      res_n_i        : in  std_logic;
      a_i            : in  std_logic_vector(15 downto 12);
      rd_n_i         : in  std_logic;
      wr_n_i         : in  std_logic;
      mreq_n_i       : in  std_logic;
      rfsh_n_i       : in  std_logic;
      cs_n_o         : out std_logic_vector(15 downto 0);
      ram_cpu_cs_n_o : out std_logic
    );
  end component;

  component ladybug_gpio
    port (
      a_i          : in  std_logic_vector(1 downto 0);
      cs_in_n_i    : in  std_logic;
      cs_extra_n_i : in  std_logic;
      in0_i        : in  std_logic_vector(7 downto 0);
      in1_i        : in  std_logic_vector(7 downto 0);
      in2_i        : in  std_logic_vector(7 downto 0);
      in3_i        : in  std_logic_vector(7 downto 0);
      extra_i      : in  std_logic_vector(7 downto 0);
      d_o          : out std_logic_vector(7 downto 0)
    );
  end component;

  component ladybug_chute
    port (
      clk_20mhz_i : in  std_logic;
      res_n_i     : in  std_logic;
      chute_i     : in  std_logic;
      chute_o     : out std_logic
    );
  end component;

  component ladybug_chutes
    port (
      clk_20mhz_i   : in  std_logic;
      res_n_i       : in  std_logic;
      right_chute_i : in  std_logic;
      left_chute_i  : in  std_logic;
      cs8_n_i       : in  std_logic;
      nmi_n_o       : out std_logic;
      int_n_o       : out std_logic
    );
  end component;

  component ladybug_decrypt_prom_l
    port (
      clk_i : in  std_logic;
      a_i   : in  std_logic_vector(7 downto 0);
      d_o   : out std_logic_vector(3 downto 0)
    );
  end component;

  component ladybug_decrypt_prom_u
    port (
      clk_i : in  std_logic;
      a_i   : in  std_logic_vector(7 downto 0);
      d_o   : out std_logic_vector(3 downto 0)
    );
  end component;

end ladybug_cpu_comp_pack;
