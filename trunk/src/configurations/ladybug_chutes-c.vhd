-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_chutes-c.vhd,v 1.2 2005/10/10 22:12:38 arnim Exp $
--
-------------------------------------------------------------------------------

configuration ladybug_chutes_rtl_c0 of ladybug_chutes is

  for rtl

    for all: ladybug_chute
      use configuration work.ladybug_chute_rtl_c0;
    end for;

  end for;

end ladybug_chutes_rtl_c0;
