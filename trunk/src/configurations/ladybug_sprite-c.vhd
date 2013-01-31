-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_sprite-c.vhd,v 1.3 2005/11/07 21:56:12 arnim Exp $
--
-------------------------------------------------------------------------------

configuration ladybug_sprite_rtl_c0 of ladybug_sprite is

  for rtl

    for sprite_ram_b : ladybug_sprite_ram
      use configuration work.ladybug_sprite_ram_struct_c0;
    end for;

    for sprite_ctrl_b : ladybug_sprite_ctrl
      use configuration work.ladybug_sprite_ctrl_rtl_c0;
    end for;

    for lu_b : ladybug_sprite_lu_prom
      use configuration work.ladybug_sprite_lu_prom_c0;
    end for;

    for f8_b : ttl_395
      use configuration work.ttl_395_rtl_c0;
    end for;

    for ctrl_lu_b : ladybug_sprite_ctrl_lu_prom
      use configuration work.ladybug_sprite_ctrl_lu_prom_c0;
    end for;

    for all : ladybug_sprite_vram
      use configuration work.ladybug_sprite_vram_struct_c0;
    end for;

    for all : ttl_166
      use configuration work.ttl_166_rtl_c0;
    end for;

    for all : ttl_161
      use configuration work.ttl_161_rtl_c0;
    end for;

    for shifters
      for shifter : ttl_395
        use configuration work.ttl_395_rtl_c0;
      end for;
    end for;

  end for;

end ladybug_sprite_rtl_c0;
