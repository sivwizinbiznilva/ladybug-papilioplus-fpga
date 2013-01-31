-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_rgb-c.vhd,v 1.3 2005/11/07 21:56:12 arnim Exp $
--
-------------------------------------------------------------------------------

configuration ladybug_rgb_rtl_c0 of ladybug_rgb is

  for rtl

    for rgb_prom_b : ladybug_rgb_prom
      use configuration work.ladybug_rgb_prom_c0;
    end for;

  end for;

end ladybug_rgb_rtl_c0;
