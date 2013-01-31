-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_res-c.vhd,v 1.3 2005/11/07 21:56:12 arnim Exp $
--
-------------------------------------------------------------------------------

configuration ladybug_res_rtl_c0 of ladybug_res is

  for rtl

    for ladybug_por_b : ladybug_por
      use configuration work.ladybug_por_c0;
    end for;

  end for;

end ladybug_res_rtl_c0;
