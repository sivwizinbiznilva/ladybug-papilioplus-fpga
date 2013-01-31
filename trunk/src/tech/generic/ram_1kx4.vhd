-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ram_1kx4.vhd,v 1.2 2005/11/12 11:55:27 arnim Exp $
--
-- Generic RTL flavor.
--
-- Instantiate 1 K x 4 synchronous RAM.
--
-- For characteristics of the synchronous RAM refer to generic_ram.vhd.
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

entity ram_1kx4 is

  port (
    clk_i : in  std_logic;
    a_i   : in  std_logic_vector(9 downto 0);
    we_i  : in  std_logic;
    d_i   : in  std_logic_vector(3 downto 0);
    d_o   : out std_logic_vector(3 downto 0)
  );

end ram_1kx4;


library ieee;
use ieee.numeric_std.all;

use work.tech_comp_pack.generic_ram;

architecture struct of ram_1kx4 is

begin

  ram_b : generic_ram
    generic map (
      addr_width_g => 10,
      data_width_g => 4
    )
    port map (
      clk_i => clk_i,
      a_i   => a_i,
      we_i  => we_i,
      d_i   => d_i,
      d_o   => d_o
    );

end struct;
