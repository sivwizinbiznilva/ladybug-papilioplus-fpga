-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_sound_unit-c.vhd,v 1.2 2005/10/10 22:12:38 arnim Exp $
--
-------------------------------------------------------------------------------

configuration ladybug_sound_unit_struct_c0 of ladybug_sound_unit is

  for struct

    for all : sn76489_top
      use configuration work.sn76489_top_struct_c0;
    end for;

  end for;

end ladybug_sound_unit_struct_c0;
