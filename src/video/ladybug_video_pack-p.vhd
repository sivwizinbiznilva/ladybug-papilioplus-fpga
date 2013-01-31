-------------------------------------------------------------------------------
--
-- $Id: ladybug_video_pack-p.vhd,v 1.2 2005/10/10 22:02:14 arnim Exp $
--
-- Copyright (c) 2005, Arnim Laeuger (arnim.laeuger@gmx.net)
--
-- All rights reserved
--
-------------------------------------------------------------------------------

package ladybug_video_pack is

  -----------------------------------------------------------------------------
  -- Vector indice for the horizontal and vertical timings
  -----------------------------------------------------------------------------
  constant HA_c   : natural := 0;
  constant HB_c   : natural := 1;
  constant HC_c   : natural := 2;
  constant HD_c   : natural := 3;
  constant HA_t_c : natural := 0;
  constant HB_t_c : natural := 1;
  constant HC_t_c : natural := 2;
  constant HD_t_c : natural := 3;
  --
  constant VA_c   : natural := 0;
  constant VB_c   : natural := 1;
  constant VC_c   : natural := 2;
  constant VD_c   : natural := 3;
  constant VA_t_c : natural := 0;
  constant VB_t_c : natural := 1;
  constant VC_t_c : natural := 2;
  constant VD_t_c : natural := 3;

end ladybug_video_pack;
