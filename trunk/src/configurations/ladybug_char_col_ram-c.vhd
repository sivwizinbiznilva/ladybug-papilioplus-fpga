-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_char_col_ram-c.vhd,v 1.5 2005/11/06 15:43:17 arnim Exp $
--
-------------------------------------------------------------------------------

configuration ladybug_char_col_ram_struct_c0 of ladybug_char_col_ram is

  for struct

    for ram_1kx4_b : ram_1kx4
      use configuration work.ram_1kx4_c0;
    end for;

  end for;

end ladybug_char_col_ram_struct_c0;
