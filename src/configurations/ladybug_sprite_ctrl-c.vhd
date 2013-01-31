-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_sprite_ctrl-c.vhd,v 1.2 2005/10/10 22:12:38 arnim Exp $
--
-------------------------------------------------------------------------------

configuration ladybug_sprite_ctrl_rtl_c0 of ladybug_sprite_ctrl is

  for rtl

    for e7_b : ttl_175
      use configuration work.ttl_175_rtl_c0;
    end for;

    for all : ttl_393
      use configuration work.ttl_393_rtl_c0;
    end for;

  end for;

end ladybug_sprite_ctrl_rtl_c0;
