-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_char-c.vhd,v 1.2 2005/10/10 22:12:38 arnim Exp $
--
-------------------------------------------------------------------------------

configuration ladybug_char_rtl_c0 of ladybug_char is

  for rtl

    for h_ctrl_b : ttl_175
      use configuration work.ttl_175_rtl_c0;
    end for;

    for char_ram_b : ladybug_char_ram
      use configuration work.ladybug_char_ram_struct_c0;
    end for;

    for col_ram_b : ladybug_char_col_ram
      use configuration work.ladybug_char_col_ram_struct_c0;
    end for;

  end for;

end ladybug_char_rtl_c0;
