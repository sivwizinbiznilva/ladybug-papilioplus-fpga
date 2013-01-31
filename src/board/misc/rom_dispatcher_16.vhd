-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: rom_dispatcher_16.vhd,v 1.1 2005/11/17 23:27:37 arnim Exp $
--
-- ROM Dispatcher Module for 16-bit Memory
--
-- Supplies the three ROM interfaces of the Lady Bug machine with data
-- from external memory in a circular order.
-- This design should fit any board which contains an 16 bit wide memory
-- holding all game data.
-- It uses the rom_dispatcher_8 and supplies either upper or lower byte of
-- the 16-bit wide interface.
--
-- Memory map of external ROM/RAM:
--
--         +-------------------+
--   5fffh |  0fffh  |  0fffh  |
--         |  0ffeh  |  0ffeh  |
--         |   ...   |   ...   |
--         |sprite_u | sprite_l|
--         |   ...   |   ...   |
--         |  0001h  |  0001h  |
--   5000h |  0000h  |  0000h  |
--         +-------------------+
--   4fffh |  0fffh  |  0fffh  |
--         |  0ffeh  |  0ffeh  |
--         |   ...   |   ...   |
--         | char_u  | char_l  |
--         |   ...   |   ...   |
--         |  0001h  |  0001h  |
--   4000h |  0000h  |  0000h  |
--         +-------------------+
--   3fffh |                   |
--         |       .....       |  Empty Space
--         |                   |
--   3000h |                   |
--         +-------------------+
--   2fffh |  5fffh  |  5ffeh  |
--         |  5ffdh  |  5ffch  |  Concatenation of
--         |                   |  cpu1 - cpu6
--         |   ...  cpu  ...   |
--         |                   |  Lowest address supplied
--         |  0003h  |  0002h  |  by cpu1, highest address
--   0000h |  0001h  |  0000h  |  supplied by cpu6
--         +-------------------+
--          15      8 7       0
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

entity rom_dispatcher_16 is

  port (
    clk_20mhz_i    : in  std_logic;
    por_n_i        : in  std_logic;
    ext_mem_a_o    : out std_logic_vector(14 downto 0);
    ext_mem_d_i    : in  std_logic_vector(15 downto 0);
    rom_cpu_a_i    : in  std_logic_vector(14 downto 0);
    rom_cpu_d_o    : out std_logic_vector( 7 downto 0);
    rom_char_a_i   : in  std_logic_vector(11 downto 0);
    rom_char_d_o   : out std_logic_vector(15 downto 0);
    rom_sprite_a_i : in  std_logic_vector(11 downto 0);
    rom_sprite_d_o : out std_logic_vector(15 downto 0)
  );

end rom_dispatcher_16;


use work.board_misc_comp_pack.rom_dispatcher_8;

architecture struct of rom_dispatcher_16 is

  signal ext_mem_a_s : std_logic_vector(15 downto 0);
  signal ext_mem_d_s : std_logic_vector( 7 downto 0);

begin

  rom_dispatcher_8_b : rom_dispatcher_8
    port map (
      clk_20mhz_i    => clk_20mhz_i,
      por_n_i        => por_n_i,
      ext_mem_a_o    => ext_mem_a_s,
      ext_mem_d_i    => ext_mem_d_s,
      rom_cpu_a_i    => rom_cpu_a_i,
      rom_cpu_d_o    => rom_cpu_d_o,
      rom_char_a_i   => rom_char_a_i,
      rom_char_d_o   => rom_char_d_o,
      rom_sprite_a_i => rom_sprite_a_i,
      rom_sprite_d_o => rom_sprite_d_o
    );


  -----------------------------------------------------------------------------
  -- Data multiplexer
  -----------------------------------------------------------------------------
  ext_mem_d_s <=   ext_mem_d_i( 7 downto 0)
                 when ext_mem_a_s(0) = '0' else
                   ext_mem_d_i(15 downto 8);

  ext_mem_a_o <= ext_mem_a_s(ext_mem_a_s'high downto 1);

end struct;
