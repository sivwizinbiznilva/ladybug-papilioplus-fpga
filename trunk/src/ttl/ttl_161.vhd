-------------------------------------------------------------------------------
--
-- TTL 74161 - Synchronous 4-Bit Binary Counter.
--
-- $Id: ttl_161.vhd,v 1.9 2005/10/10 21:59:13 arnim Exp $
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

entity ttl_161 is

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

end ttl_161;


library ieee;
use ieee.numeric_std.all;

architecture rtl of ttl_161 is

  signal cnt_q : unsigned(3 downto 0);
  signal cnt_s : unsigned(4 downto 0);

begin

  -----------------------------------------------------------------------------
  -- Process seq
  --
  -- Purpose:
  --   Implements the flip-flops.
  --
  --   Note: We assume that the sequential elements power-up to the same state
  --         as forced into by cl_n_i.
  --
  seq: process (ck_i, por_n_i)
  begin
    if por_n_i = '0' then
      cnt_q <= (others => '0');
    elsif ck_i'event and ck_i = '1' then
      cnt_q <= cnt_s(3 downto 0);
    end if;
  end process seq;
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Process adder
  --
  -- Purpose:
  --   Implements the adder and carry logic.
  --
  adder: process (ck_en_i,
                  cl_n_i,
                  cnt_q,
                  lo_n_i,
                  a_i, b_i, c_i, d_i,
                  t_i, p_i)
  begin
    cnt_s <= '0' & cnt_q;

    if cl_n_i = '1' then
      if ck_en_i = '1' then
        if lo_n_i = '0' then
          -- parallel load
          cnt_s <= '0' & d_i & c_i & b_i & a_i;
        elsif (p_i and t_i) = '1' then
          -- increment upon enable
          cnt_s <= ('0' & cnt_q) + 1;
        end if;
      end if;

    else
      -- pseudo-asynchronous clear
      cnt_s <= (others => '0');
    end if;
  end process adder;
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Output Mapping
  -----------------------------------------------------------------------------
  qa_o <= cnt_q(0);
  qb_o <= cnt_q(1);
  qc_o <= cnt_q(2);
  qd_o <= cnt_q(3);
  co_o <=   cnt_q(3) and cnt_q(2) and cnt_q(1) and cnt_q(0)
          when t_i = '1' else           -- t_i suppresses carry output
            '0';
  rise_qa_o <= cnt_s(0) and not cnt_q(0);
  rise_qb_o <= cnt_s(1) and not cnt_q(1);
  rise_qc_o <= cnt_s(2) and not cnt_q(2);
  rise_qd_o <= cnt_s(3) and not cnt_q(3);
  da_o      <= cnt_s(0);
  db_o      <= cnt_s(1);
  dc_o      <= cnt_s(2);
  dd_o      <= cnt_s(3);

end rtl;
