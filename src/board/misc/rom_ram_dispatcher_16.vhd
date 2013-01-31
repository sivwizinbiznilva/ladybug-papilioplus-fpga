-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: rom_ram_dispatcher_16.vhd,v 1.6 2005/12/10 14:51:22 arnim Exp $
--
-- ROM Dispatcher Module for 16-bit Memory including CPU RAM multiplexing.
--
-- Supplies the three ROM interfaces of the Lady Bug machine with data
-- from external memory in a circular order.
-- This design should fit any board which contains an 16 bit wide memory
-- holding all game data.
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
--         |      CPU RAM      |
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
--
-- Write access to external RAM:
--
-- Due to the lack of /OE on B5-SRAM, we need to operate the /WE and
-- chip output enable signals with the falling clock edge.
-- The write access is /CE controlled.
-- Bus contention is avoided by the following sequence:
--   1) deassert /CE
--       -> RAM drivers off
--   2) assert /WE before /CE is asserted again
--   3) activate chip output drivers
--   4) assert /CE
--       -> RAM drivers stay off due to active /WE
--   5) deassert /CE
--       -> end of write
--   6) deassert /WE and deactivate chip output drivers
--   7) assert /CE
--       -> continue with read mode
--
--           _   _   _   _   _   _
-- clk     _/ \_/ \_/ \_/ \_/ \_/ \_
--               |   |   |   |
--                 C   C   C
--                 P   P   P
--                 U   U   U
--                 1   2   3
--         ______ ___________ ______
-- addr    ______X___________X______
--                ___     ___
-- ram_cen ______/   \___/   \______
--                  _______
-- chip_oe ________/       \________
--         ________         ________
-- ram_wen         \_______/
-- 
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

entity rom_ram_dispatcher_16 is

  port (
    clk_20mhz_i     : in  std_logic;
    por_n_i         : in  std_logic;
    chip_oel_o      : out std_logic;
    chip_oeu_o      : out std_logic;
    ext_mem_a_o     : out std_logic_vector(14 downto 0);
    ext_mem_d_i     : in  std_logic_vector(15 downto 0);
    ext_mem_d_o     : out std_logic_vector(15 downto 0);
    ext_mem_ce_n_o  : out std_logic;
    ext_mem_wel_n_o : out std_logic;
    ext_mem_weu_n_o : out std_logic;
    rom_cpu_a_i     : in  std_logic_vector(14 downto 0);
    rom_cpu_d_o     : out std_logic_vector( 7 downto 0);
    rom_char_a_i    : in  std_logic_vector(11 downto 0);
    rom_char_d_o    : out std_logic_vector(15 downto 0);
    rom_sprite_a_i  : in  std_logic_vector(11 downto 0);
    rom_sprite_d_o  : out std_logic_vector(15 downto 0);
    ram_cpu_a_i     : in  std_logic_vector(11 downto 0);
    ram_cpu_d_i     : in  std_logic_vector( 7 downto 0);
    ram_cpu_d_o     : out std_logic_vector( 7 downto 0);
    ram_cpu_we_n_i  : in  std_logic;
    ram_cpu_cs_n_i  : in  std_logic
  );

end rom_ram_dispatcher_16;


architecture rtl of rom_ram_dispatcher_16 is

  type   state_t is (CHAR, SPRITE,
                     CPU_1, CPU_2, CPU_3);
  signal state_q : state_t;

  signal rom_char_d_q,
         rom_char_d_s,
         rom_sprite_d_q,
         rom_sprite_d_s  : std_logic_vector(15 downto 0);
  signal rom_cpu_d_q,
         rom_cpu_d_s     : std_logic_vector( 7 downto 0);

  signal ram_access_q    : boolean;
  signal ram_write_q     : boolean;

  signal ram_ce_n_q,
         ram_wel_n_q,
         ram_weu_n_q     : std_logic;

  signal chip_oel_q,
         chip_oeu_q      : std_logic;

begin

  -----------------------------------------------------------------------------
  -- Process seq
  --
  -- Purpose:
  --   Implements the sequential elements:
  --     * FSM state vector
  --     * data registers for character ROM, sprite ROM and CPU ROM
  --     * RAM control signals
  --
  seq: process (clk_20mhz_i, por_n_i)
  begin
    if por_n_i = '0' then
      state_q <= CHAR;

      rom_char_d_q   <= (others => '0');
      rom_sprite_d_q <= (others => '0');
      rom_cpu_d_q    <= (others => '0');

      ram_access_q   <= false;
      ram_write_q    <= false;

      ram_ce_n_q     <= '0';

    elsif clk_20mhz_i'event and clk_20mhz_i = '1' then
      rom_char_d_q   <= rom_char_d_s;
      rom_sprite_d_q <= rom_sprite_d_s;
      rom_cpu_d_q    <= rom_cpu_d_s;

      case state_q is
        when CHAR =>
          state_q <= SPRITE;

        when SPRITE =>
          if ram_cpu_cs_n_i = '0' then
            -- CPU accesses the RAM
            ram_access_q  <= true;

            if ram_cpu_we_n_i = '0' then
              ram_write_q <= true;

              -- switch off RAM drivers, required to safely enable
              -- chip output drivers
              ram_ce_n_q  <= '1';
            end if;

          end if;
          state_q         <= CPU_1;

        when CPU_1 =>
          if ram_write_q then
            -- enable RAM again, /WE is already active,
            -- chip output drivers are enabled
            ram_ce_n_q <= '0';
          end if;

          state_q      <= CPU_2;

        when CPU_2 =>
          if ram_write_q then
            -- this ends the write and switches off RAM drivers,
            -- required to safely deactivate /WE while chip output
            -- drivers are switched off
            ram_ce_n_q <= '1';
          end if;

          state_q     <= CPU_3;

        when CPU_3 =>
          ram_access_q <= false;
          ram_write_q  <= false;

          if ram_write_q then
            -- enable RAM again, /WE is now inactive, chip output
            -- drivers have been disabled
            ram_ce_n_q <= '0';
          end if;

          state_q      <= CHAR;

      end case;

    end if;
  end process seq;
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Process neg_seq
  --
  -- Purpose:
  --   Implements the sequential elements on the falling clock edge.
  --
  neg_seq: process (clk_20mhz_i, por_n_i)
  begin
    if por_n_i = '0' then
      ram_wel_n_q <= '1';
      ram_weu_n_q <= '1';
      chip_oel_q  <= '0';
      chip_oeu_q  <= '0';

    elsif clk_20mhz_i'event and clk_20mhz_i = '0' then
      case state_q is
        -- State CPU1: activate WE of RAM, activate chip output drivers -------
        when CPU_1 =>
          if ram_write_q then
            if ram_cpu_a_i(0) = '0' then
              ram_wel_n_q <= '0';
              chip_oel_q  <= '1';
            else
              ram_weu_n_q <= '0';
              chip_oeu_q  <= '1';
            end if;
          end if;

        -- State CPU3: deactivate WE of RAM, deactivate chip output drivers ---
        when CPU_3 =>
          ram_wel_n_q <= '1';
          ram_weu_n_q <= '1';
          chip_oel_q  <= '0';
          chip_oeu_q  <= '0';

        when others =>
          null;

      end case;

    end if;
  end process neg_seq;
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
                     ram_access_q,
                     rom_char_a_i,
                     rom_sprite_a_i,
                     rom_cpu_a_i,
                     ram_cpu_a_i)
  begin
    if not ram_access_q then
      case state_q is
        when CHAR =>
          ext_mem_a_o <= '1' & "00" & rom_char_a_i;

        when SPRITE =>
          ext_mem_a_o <= '1' & "01" & rom_sprite_a_i;

        when CPU_1 |
             CPU_2 |
             CPU_3   =>
          ext_mem_a_o <= '0' & rom_cpu_a_i(14 downto 1);

        when others =>
          ext_mem_a_o <= (others => '-');

      end case;

    else
      -- make sure that address does not glitch during write
      -- access to CPU RAM
      ext_mem_a_o     <= '0' & "110" & ram_cpu_a_i(11 downto 1);

    end if;
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
      when CHAR =>
        rom_char_d_s   <= ext_mem_d_i;

      when SPRITE =>
        rom_sprite_d_s <= ext_mem_d_i;

      when CPU_1 |
           CPU_2 |
           CPU_3   =>
        if rom_cpu_a_i(0) = '0' then
          rom_cpu_d_s  <= ext_mem_d_i( 7 downto 0);
        else
          rom_cpu_d_s  <= ext_mem_d_i(15 downto 8);
        end if;

      when others =>
        null;
      end case;

  end process data_mux;
  --
  -----------------------------------------------------------------------------


  -----------------------------------------------------------------------------
  -- Output Mapping
  -----------------------------------------------------------------------------
  rom_char_d_o   <= rom_char_d_s;
  rom_sprite_d_o <= rom_sprite_d_s;
  rom_cpu_d_o    <= rom_cpu_d_s;
  ram_cpu_d_o    <= rom_cpu_d_s;

  ext_mem_d_o(15 downto 8) <= ram_cpu_d_i;
  ext_mem_d_o( 7 downto 0) <= ram_cpu_d_i;

  ext_mem_ce_n_o  <= ram_ce_n_q;
  ext_mem_wel_n_o <= ram_wel_n_q;
  ext_mem_weu_n_o <= ram_weu_n_q;

  chip_oel_o      <= chip_oel_q;
  chip_oeu_o      <= chip_oeu_q;

end rtl;
