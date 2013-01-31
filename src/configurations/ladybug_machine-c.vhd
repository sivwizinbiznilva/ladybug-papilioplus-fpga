-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_machine-c.vhd,v 1.3 2005/10/10 22:12:38 arnim Exp $
--
-------------------------------------------------------------------------------

configuration ladybug_machine_struct_c0 of ladybug_machine is

  for struct

    for clk_b: ladybug_clk
      use configuration work.ladybug_clk_rtl_c0;
    end for;

    for res_b: ladybug_res
      use configuration work.ladybug_res_rtl_c0;
    end for;

    for cpu_b: ladybug_cpu_unit
      use configuration work.ladybug_cpu_unit_struct_c0;
    end for;

    for video_b: ladybug_video_unit
      use configuration work.ladybug_video_unit_struct_c0;
    end for;

    for sound_b : ladybug_sound_unit
      use configuration work.ladybug_sound_unit_struct_c0;
    end for;

  end for;

end ladybug_machine_struct_c0;
