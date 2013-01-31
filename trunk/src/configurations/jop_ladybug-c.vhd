-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: jop_ladybug-c.vhd,v 1.6 2005/11/26 09:55:04 arnim Exp $
--
-------------------------------------------------------------------------------

configuration jop_ladybug_struct_c0 of jop_ladybug is

  for struct

    for machine_b: ladybug_machine
      use configuration work.ladybug_machine_struct_c0;
    end for;

    for all: dac
      use configuration work.dac_rtl_c0;
    end for;

    for rom_dispatcher_b: rom_dispatcher_16
      use configuration work.rom_dispatcher_16_struct_c0;
    end for;

    for snespads_b: snespad
      use configuration work.snespad_struct_c0;
    end for;

  end for;

end jop_ladybug_struct_c0;
