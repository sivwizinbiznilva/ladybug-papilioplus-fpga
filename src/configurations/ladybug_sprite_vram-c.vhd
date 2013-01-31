-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_sprite_vram-c.vhd,v 1.3 2005/11/06 15:43:17 arnim Exp $
--
-------------------------------------------------------------------------------

configuration ladybug_sprite_vram_struct_c0 of ladybug_sprite_vram is

  for struct

    for ram_1kx4_b : ram_1kx4
      use configuration work.ram_1kx4_c0;
    end for;

  end for;

end ladybug_sprite_vram_struct_c0;
