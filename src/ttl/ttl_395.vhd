-------------------------------------------------------------------------------
--
-- TTL 74LS395 - 4-Bit Cascadable Shift Register with 3-State Outputs
--
-- $Id: ttl_395.vhd,v 1.3 2005/10/10 21:59:13 arnim Exp $
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

entity ttl_395 is

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

end ttl_395;


architecture rtl of ttl_395 is

  signal reg_q : std_logic_vector(3 downto 0);

begin

  -----------------------------------------------------------------------------
  -- Process seq
  --
  -- Purpose:
  --   Implements the sequential shift register.
  --
  seq: process (clk_i, por_n_i)
  begin
    if por_n_i = '0' then
      reg_q   <= (others => '0');

    elsif clk_i'event and clk_i = '1' then
      if clr_n_i = '0' then
        -- pseudo-asynchronous clear
        reg_q <= (others => '0');

      elsif ck_en_i = '1' then
        if ld_sh_n_i = '1' then
          -- parallel load
          reg_q <= d_i & c_i & b_i & a_i;

        else
          -- serial shift
          reg_q(3 downto 1) <= reg_q(2 downto 0);
          reg_q(0)          <= ser_i;

        end if;
      end if;
    end if;
  end process seq;
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Process outputs
  --
  -- Purpose:
  --   Generate the output signals.
  --
  outputs: process (reg_q,
                    clr_n_i,
                    oc_n_i)
  begin
    -- default assignment
    qa_o   <= '1';
    qb_o   <= '1';
    qc_o   <= '1';
    qd_o   <= '1';
    qd_t_o <= reg_q(3);

    if oc_n_i = '0' then
      if clr_n_i = '1' then
        qa_o <= reg_q(0);
        qb_o <= reg_q(1);
        qc_o <= reg_q(2);
        qd_o <= reg_q(3);

      else
        qa_o <= '0';
        qb_o <= '0';
        qc_o <= '0';
        qd_o <= '0';

      end if;
    end if;
  end process outputs;
  --
  -----------------------------------------------------------------------------

end rtl;
