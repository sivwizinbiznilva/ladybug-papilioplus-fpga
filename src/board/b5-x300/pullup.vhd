-------------------------------------------------------------------------------
--
-- $Id: pullup.vhd,v 1.1 2005/12/10 01:47:37 arnim Exp $
--
-- A simulation model of a pullup resistor.
-- Not intended for synthesis.
--
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity pullup is

  port (
    O : out std_logic
  );

end pullup;


architecture rtl of pullup is

begin

  O <= 'H';

end rtl;
