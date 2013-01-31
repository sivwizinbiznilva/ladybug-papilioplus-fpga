-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: zefant-xs3_clk.vhd,v 1.2 2006/06/15 22:16:38 arnim Exp $
--
-- Clock generator for Simple Solutions' Zefant-XS3 board.
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

library ieee;
use ieee.std_logic_1164.all;

entity zefant_xs3_clk is

  port (
    clkin_i     : in  std_logic;
    locked_o    : out std_logic;
    clk_20mhz_o : out std_logic
  );

end zefant_xs3_clk;


library unisim;
use unisim.vcomponents.all;

architecture rtl of zefant_xs3_clk is

  signal clkin_ibuf_s    : std_logic;
  signal clk_40mhz_s,
         clk_40mhz_buf_s : std_logic;
  signal clk_20mhz_q     : std_logic := '0';
  signal gnd_s           : std_logic;

begin

  gnd_s <= '0';

  dcm_b : dcm
    generic map (
      CLKIN_PERIOD   => 15.15,
      CLKFX_MULTIPLY => 14,
      CLKFX_DIVIDE   => 23,
      CLK_FEEDBACK   => "NONE"
    )
    port map (
      CLKIN          => clkin_ibuf_s,
      CLKFB          => gnd_s,
      RST            => gnd_s,
      PSEN           => gnd_s,
      PSINCDEC       => gnd_s,
      PSCLK          => gnd_s,
      CLK0           => open,
      CLK90          => open,
      CLK180         => open,
      CLK270         => open,
      CLK2X          => open,
      CLK2X180       => open,
      CLKDV          => open,
      CLKFX          => clk_40mhz_s,
      CLKFX180       => open,
      STATUS         => open,
      LOCKED         => locked_o,
      PSDONE         => open
    );

  clkin_ibuf_b : IBUFG
    port map (
      I => clkin_i,
      O => clkin_ibuf_s
    );

  clk40_bufg_b : BUFG
    port map (
      I => clk_40mhz_s,
      O => clk_40mhz_buf_s
    );

  clk20_bufg_b : BUFG
    port map (
      I => clk_20mhz_q,
      O => clk_20mhz_o
    );


  -----------------------------------------------------------------------------
  -- Process clk_div2
  --
  -- Purpose:
  --   Divides the 40 MHz clock by 2 to get the final 20 MHz clock.
  --
  clk_div2: process (clk_40mhz_buf_s)
  begin
    if clk_40mhz_buf_s'event and clk_40mhz_buf_s = '1' then
      clk_20mhz_q <= not clk_20mhz_q;
    end if;
  end process clk_div2;
  --
  -----------------------------------------------------------------------------

end rtl;
