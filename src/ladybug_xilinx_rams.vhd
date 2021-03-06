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


-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_char_ram.vhd,v 1.1 2005/11/06 15:42:13 arnim Exp $
--
-- Wrapper for technology dependent video character RAM.
--
-- Xilinx flavor.
--
-- Instantiate 1 K x 8 synchronous RAM.
--
-- The clock enable of the controller clock is not attached to the RAM to
-- emulate the asynchronous read behavior of the original RAM. Read data is
-- available within a clock cycle of the controller although it takes two
-- cycles of the main clock to get the data from the RAM macro.
--

library ieee;
use ieee.std_logic_1164.all;

library unisim;
	use unisim.vcomponents.all;

entity ladybug_char_ram is

  port (
    clk_i    : in  std_logic;
    clk_en_i : in  std_logic;
    a_i      : in  std_logic_vector(9 downto 0);
    cs_n_i   : in  std_logic;
    we_n_i   : in  std_logic;
    d_i      : in  std_logic_vector( 7 downto 0);
    d_o      : out std_logic_vector( 7 downto 0)
  );

end ladybug_char_ram;

architecture struct of ladybug_char_ram is

  signal d_s   : std_logic_vector(7 downto 0);
  signal we_s  : std_logic;

begin

  -- generate write enable at same clock edge as controller logic
  -- this might suppress intermediate writes when address bus changes
  -- during write cycle
	we_s <= not cs_n_i and not we_n_i and clk_en_i;

	RAMB16_S9_inst : RAMB16_S9
	port map (
		DO               => d_s,
		DOP              => open,
		ADDR(10)         => '0',
		ADDR(9 downto 0) => a_i,
		CLK              => clk_i,
		DI               => d_i,
		DIP              => "0",
		EN               => '1',
		SSR              => '0',
		WE               => we_s
	);

  -- gate the data output for and'ing on CPU bus
  d_o <= d_s when cs_n_i = '0' else (others => '1');

end struct;

-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_sprite_ram.vhd,v 1.1 2005/11/06 15:42:13 arnim Exp $
--
-- Wrapper for technology dependent video sprite RAM.
--
-- Xilinx flavor.
--
-- Instantiate 1 K x 8 synchronous RAM.
--
-- The clock enable of the controller clock is not attached to the RAM to
-- emulate the asynchronous read behavior of the original RAM. Read data is
-- available within a clock cycle of the controller although it takes two
-- cycles of the main clock to get the data from the RAM macro.
--

library ieee;
use ieee.std_logic_1164.all;

library unisim;
	use unisim.vcomponents.all;

entity ladybug_sprite_ram is

  port (
    clk_i    : in  std_logic;
    clk_en_i : in  std_logic;
    a_i      : in  std_logic_vector(9 downto 0);
    cs_n_i   : in  std_logic;
    we_n_i   : in  std_logic;
    d_i      : in  std_logic_vector( 7 downto 0);
    d_o      : out std_logic_vector( 7 downto 0)
  );

end ladybug_sprite_ram;

architecture struct of ladybug_sprite_ram is

  signal we_s  : std_logic;

begin

  -- generate write enable at same clock edge as controller logic
  -- this might suppress intermediate writes when address bus changes
  -- during write cycle
  we_s <= not cs_n_i and not we_n_i and clk_en_i;

	RAMB16_S9_inst : RAMB16_S9
	port map (
		DO               => d_o,
		DOP              => open,
		ADDR(10)         => '0',
		ADDR(9 downto 0) => a_i,
		CLK              => clk_i,
		DI               => d_i,
		DIP              => "0",
		EN               => '1',
		SSR              => '0',
		WE               => we_s
	);

end struct;

-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_char_col_ram.vhd,v 1.1 2005/11/06 15:42:13 arnim Exp $
--
-- Wrapper for technology dependent video character color RAM.
--
-- Xilinx flavor.
--
-- Instantiate 1 K x 4 synchronous RAM.
--
-- The clock enable of the controller clock is not attached to the RAM to
-- emulate the asynchronous read behavior of the original RAM. Read data is
-- available within a clock cycle of the controller although it takes two
-- cycles of the main clock to get the data from the RAM macro.
--

library ieee;
use ieee.std_logic_1164.all;

library unisim;
	use unisim.vcomponents.all;

entity ladybug_char_col_ram is

  port (
    clk_i    : in  std_logic;
    clk_en_i : in  std_logic;
    a_i      : in  std_logic_vector(9 downto 0);
    cs_n_i   : in  std_logic;
    we_n_i   : in  std_logic;
    d_i      : in  std_logic_vector( 3 downto 0);
    d_o      : out std_logic_vector( 3 downto 0)
  );

end ladybug_char_col_ram;

architecture struct of ladybug_char_col_ram is

  signal d_s   : std_logic_vector(3 downto 0);
  signal we_s  : std_logic;

begin

  -- generate write enable at same clock edge as controller logic
  -- this might suppress intermediate writes when address bus changes
  -- during write cycle
  we_s <= not cs_n_i and not we_n_i and clk_en_i;

	RAMB16_S4_inst : RAMB16_S4
	port map (
		DO                 => d_s,
		ADDR(11 downto 10) => "00",
		ADDR( 9 downto  0) => a_i,
		CLK                => clk_i,
		DI                 => d_i,
		EN                 => '1',
		SSR                => '0',
		WE                 => we_s
	);

  -- gate the data output for and'ing on CPU bus
  d_o <= d_s when cs_n_i = '0' else (others => '1');

end struct;

-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_sprite_vram.vhd,v 1.1 2005/11/06 15:42:13 arnim Exp $
--
-- Wrapper for technology dependent video sprite VRAM.
--
-- Xilinx flavor.
--
-- Instantiate 1 K x 4 synchronous RAM.
--
-- The clock enable of the controller clock is not attached to the RAM to
-- emulate the asynchronous read behavior of the original RAM. Read data is
-- available within a clock cycle of the controller although it takes two
-- cycles of the main clock to get the data from the RAM macro.
--

library ieee;
use ieee.std_logic_1164.all;

library unisim;
	use unisim.vcomponents.all;

entity ladybug_sprite_vram is

  port (
    clk_i    : in  std_logic;
    clk_en_i : in  std_logic;
    a_i      : in  std_logic_vector(9 downto 0);
    cs_n_i   : in  std_logic;
    we_n_i   : in  std_logic;
    d_i      : in  std_logic_vector( 3 downto 0);
    d_o      : out std_logic_vector( 3 downto 0)
  );

end ladybug_sprite_vram;

architecture struct of ladybug_sprite_vram is

  signal we_s  : std_logic;

begin

  -- generate write enable at same clock edge as controller logic
  -- this might suppress intermediate writes when address bus changes
  -- during write cycle
  we_s <= not cs_n_i and not we_n_i and clk_en_i;

	RAMB16_S4_inst : RAMB16_S4
	port map (
		DO                 => d_o,
		ADDR(11 downto 10) => "00",
		ADDR( 9 downto  0) => a_i,
		CLK                => clk_i,
		DI                 => d_i,
		EN                 => '1',
		SSR                => '0',
		WE                 => we_s
	);

end struct;

-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_cpu_ram.vhd,v 1.1 2005/11/06 15:43:38 arnim Exp $
--
-- Wrapper for technology dependent CPU RAM.
--
-- Xilinx flavor.
--
-- Instantiate 4 K x 8 synchronous RAM.
--
-- The clock enable of the controller clock is not attached to the RAM to
-- emulate the asynchronous read behavior of the original RAM. Read data is
-- available within a clock cycle of the controller although it takes two
-- cycles of the main clock to get the data from the RAM macro.
--

library ieee;
use ieee.std_logic_1164.all;

library unisim;
	use unisim.vcomponents.all;

entity ladybug_cpu_ram is

  port (
    clk_i    : in  std_logic;
    clk_en_i : in  std_logic;
    a_i      : in  std_logic_vector(11 downto 0);
    cs_n_i   : in  std_logic;
    we_n_i   : in  std_logic;
    d_i      : in  std_logic_vector( 7 downto 0);
    d_o      : out std_logic_vector( 7 downto 0)
  );

end ladybug_cpu_ram;

architecture struct of ladybug_cpu_ram is

  signal d_s1  : std_logic_vector(7 downto 0);
  signal d_s2  : std_logic_vector(7 downto 0);
  signal we_s1 : std_logic;
  signal we_s2 : std_logic;

begin

  -- generate write enable at same clock edge as controller logic
  -- this might suppress intermediate writes when address bus changes
  -- during write cycle
	we_s1 <= not cs_n_i and not we_n_i and clk_en_i and not a_i(11) ;
	we_s2 <= not cs_n_i and not we_n_i and clk_en_i and     a_i(11) ;

	RAMB16_S9_1 : RAMB16_S9
	port map (
		DO   => d_s1,
		DOP  => open,
		ADDR => a_i(10 downto 0),
		CLK  => clk_i,
		DI   => d_i,
		DIP  => "0",
		EN   => '1',
		SSR  => '0',
		WE   => we_s1
	);

	RAMB16_S9_2 : RAMB16_S9
	port map (
		DO   => d_s2,
		DOP  => open,
		ADDR => a_i(10 downto 0),
		CLK  => clk_i,
		DI   => d_i,
		DIP  => "0",
		EN   => '1',
		SSR  => '0',
		WE   => we_s2
	);

  -- gate the data output for and'ing on CPU bus
	d_o <=	d_s1 when a_i(11) = '0' and cs_n_i = '0' else
				d_s2 when a_i(11) = '1' and cs_n_i = '0' else
				(others => '1');

end struct;
