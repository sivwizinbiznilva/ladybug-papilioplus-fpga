-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: rom_dispatcher_8.vhd,v 1.1 2005/11/17 23:27:37 arnim Exp $
--
-- ROM Dispatcher Module for 8-bit Memory
--
-- Supplies the three ROM interfaces of the Lady Bug machine with data
-- from external memory in a circular order.
-- This design should fit any board which contains an 8 bit wide memory holding
-- all game data.
--
-- Memory map of external ROM/RAM:
--
--             +---------+
--       bfffh |u 0fffh  |
--             |l 0fffh  |
--             |u 0ffeh  |
--             |l 0ffeh  |
--             |   ...   |  Interleaved data of
--             | sprite  |  sprite_l and sprite_u
--             |   ...   |
--             |u 0001h  |
--             |l 0001h  |
--             |u 0000h  |
--       a000h |l 0000h  |
--             +---------+
--       9fffh |u 0fffh  |
--             |l 0fffh  |
--             |u 0ffeh  |
--             |l 0ffeh  |
--             |   ...   |  Interleaved data of
--             |  char   |  char_l and char_u
--             |   ...   |
--             |u 0001h  |
--             |l 0001h  |
--             |u 0000h  |
--       8000h |l 0000h  |
--             +---------+
--       7fffh |         |
--             |         |
--             |   ...   |  Empty Space
--             |         |
--       6000h |         |
--             +---------+
--       5fffh |  5fffh  |
--             |  5ffeh  |  Concatenation of
--             |   ...   |  cpu1 - cpu6
--             |   cpu   |
--             |   ...   |  Lowest address supplied
--             |  0001h  |  by cpu1, highest address
--       0000h |  0000h  |  supplied by cpu6
--             +---------+
--              7       0
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

entity rom_dispatcher_8 is

  port (
    clk_20mhz_i    : in  std_logic;
    por_n_i        : in  std_logic;
    ext_mem_a_o    : out std_logic_vector(15 downto 0);
    ext_mem_d_i    : in  std_logic_vector( 7 downto 0);
    rom_cpu_a_i    : in  std_logic_vector(14 downto 0);
    rom_cpu_d_o    : out std_logic_vector( 7 downto 0);
    rom_char_a_i   : in  std_logic_vector(11 downto 0);
    rom_char_d_o   : out std_logic_vector(15 downto 0);
    rom_sprite_a_i : in  std_logic_vector(11 downto 0);
    rom_sprite_d_o : out std_logic_vector(15 downto 0)
  );

end rom_dispatcher_8;


architecture rtl of rom_dispatcher_8 is

  type   state_t is (CHAR1, CHAR2, SPRITE1, SPRITE2, CPU);
  signal state_q : state_t;

  signal rom_char_d_q,
         rom_char_d_s,
         rom_sprite_d_q,
         rom_sprite_d_s  : std_logic_vector(15 downto 0);
  signal rom_cpu_d_q,
         rom_cpu_d_s     : std_logic_vector( 7 downto 0);

begin

  -----------------------------------------------------------------------------
  -- Process seq
  --
  -- Purpose:
  --   Implements the sequential elements:
  --     * FSM state vector
  --     * data registers for character ROM, sprite ROM and CPU ROM
  --
  seq: process (clk_20mhz_i, por_n_i)
  begin
    if por_n_i = '0' then
      state_q <= CHAR1;

      rom_char_d_q   <= (others => '0');
      rom_sprite_d_q <= (others => '0');
      rom_cpu_d_q    <= (others => '0');

    elsif clk_20mhz_i'event and clk_20mhz_i = '1' then
      rom_char_d_q   <= rom_char_d_s;
      rom_sprite_d_q <= rom_sprite_d_s;
      rom_cpu_d_q    <= rom_cpu_d_s;

      case state_q is
        when CHAR1 =>
          state_q <= CHAR2;

        when CHAR2 =>
          state_q <= SPRITE1;

        when SPRITE1 =>
          state_q <= SPRITE2;

        when SPRITE2 =>
          state_q <= CPU;

        when CPU =>
          state_q <= CHAR1;
      end case;

    end if;
  end process seq;
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Process addr_mux
  --
  -- Purpose:
  --   Multiplexes the character, sprite and CPU addresses to RAMA
  --   address lines.
  --
  addr_mux: process (state_q,
                     rom_char_a_i,
                     rom_sprite_a_i,
                     rom_cpu_a_i)
  begin
    case state_q is
      when CHAR1 =>
        ext_mem_a_o <= '1' & "00" & rom_char_a_i & '0';
      when CHAR2 =>
        ext_mem_a_o <= '1' & "00" & rom_char_a_i & '1';

      when SPRITE1 =>
        ext_mem_a_o <= '1' & "01" & rom_sprite_a_i & '0';
      when SPRITE2 =>
        ext_mem_a_o <= '1' & "01" & rom_sprite_a_i & '1';

      when CPU =>
        ext_mem_a_o <= '0' & rom_cpu_a_i;

      when others =>
        ext_mem_a_o <= (others => '-');

    end case;
  end process addr_mux;
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Process data_mux
  --
  -- Purpose:
  --   Three multiplexors for character, sprite and CPU data lines.
  --     access to related memory area => use RAMA data inputs
  --     access to foreign memory area => use registered values
  --
  data_mux: process (state_q,
                     ext_mem_d_i,
                     rom_char_d_q,
                     rom_sprite_d_q,
                     rom_cpu_d_q,
                     rom_cpu_a_i)
  begin
    -- defaults
    rom_char_d_s   <= rom_char_d_q;
    rom_sprite_d_s <= rom_sprite_d_q;
    rom_cpu_d_s    <= rom_cpu_d_q;

    case state_q is
      when CHAR1 =>
        rom_char_d_s( 7 downto 0)   <= ext_mem_d_i;

      when CHAR2 =>
        rom_char_d_s(15 downto 8)   <= ext_mem_d_i;

      when SPRITE1 =>
        rom_sprite_d_s( 7 downto 0) <= ext_mem_d_i;

      when SPRITE2 =>
        rom_sprite_d_s(15 downto 8) <= ext_mem_d_i;

      when CPU =>
        rom_cpu_d_s                 <= ext_mem_d_i;

      when others =>
        null;
      end case;

  end process data_mux;
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Data outputs
  -----------------------------------------------------------------------------
  rom_char_d_o   <= rom_char_d_s;
  rom_sprite_d_o <= rom_sprite_d_s;
  rom_cpu_d_o    <= rom_cpu_d_s;

end rtl;
