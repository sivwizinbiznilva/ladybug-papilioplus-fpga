-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: rom_dispatcher_16-c.vhd,v 1.1 2005/11/17 23:27:00 arnim Exp $
--
-------------------------------------------------------------------------------

configuration rom_dispatcher_16_struct_c0 of rom_dispatcher_16 is

  for struct

    for rom_dispatcher_8_b : rom_dispatcher_8
      use configuration work.rom_dispatcher_8_rtl_c0;
    end for;

  end for;

end rom_dispatcher_16_struct_c0;
