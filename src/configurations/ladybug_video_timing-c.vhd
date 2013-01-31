-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_video_timing-c.vhd,v 1.2 2005/10/10 22:12:38 arnim Exp $
--
-------------------------------------------------------------------------------

configuration ladybug_video_timing_rtl_c0 of ladybug_video_timing is

  for rtl

    for all : ttl_161
      use configuration work.ttl_161_rtl_c0;
    end for;

  end for;

end ladybug_video_timing_rtl_c0;
