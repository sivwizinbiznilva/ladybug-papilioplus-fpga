-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_sprite_ctrl_lu_prom-c.vhd,v 1.4 2005/11/15 23:51:43 arnim Exp $
--
-------------------------------------------------------------------------------

configuration ladybug_sprite_ctrl_lu_prom_c0 of ladybug_sprite_ctrl_lu_prom is

  for struct

    for prom_b : prom_10_3
      use configuration work.prom_10_3_rtl_c0;
    end for;

  end for;

end ladybug_sprite_ctrl_lu_prom_c0;
