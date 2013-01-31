-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_video_unit-c.vhd,v 1.6 2005/10/10 22:12:38 arnim Exp $
--
-------------------------------------------------------------------------------

configuration ladybug_video_unit_struct_c0 of ladybug_video_unit is

  for struct

    for timing_b : ladybug_video_timing
      use configuration work.ladybug_video_timing_rtl_c0;
    end for;

    for char_b : ladybug_char
      use configuration work.ladybug_char_rtl_c0;
    end for;

    for sprite_b : ladybug_sprite
      use configuration work.ladybug_sprite_rtl_c0;
    end for;

    for rgb_b : ladybug_rgb
      use configuration work.ladybug_rgb_rtl_c0;
    end for;

  end for;

end ladybug_video_unit_struct_c0;
