-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_rgb_prom-c.vhd,v 1.4 2005/11/15 23:51:43 arnim Exp $
--
-------------------------------------------------------------------------------

configuration ladybug_rgb_prom_c0 of ladybug_rgb_prom is

  for struct

    for prom_b: prom_10_2
      use configuration work.prom_10_2_rtl_c0;
    end for;

  end for;

end ladybug_rgb_prom_c0;
