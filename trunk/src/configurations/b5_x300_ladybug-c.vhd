-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: b5_x300_ladybug-c.vhd,v 1.3 2005/12/10 01:52:08 arnim Exp $
--
-------------------------------------------------------------------------------

configuration b5_x300_ladybug_struct_c0 of b5_x300_ladybug is

  for struct

    for machine_b: ladybug_machine
      use configuration work.ladybug_machine_struct_c0;
    end for;

    for all: dac
      use configuration work.dac_rtl_c0;
    end for;

    for rom_dispatcher_b: rom_ram_dispatcher_16
      use configuration work.rom_ram_dispatcher_16_rtl_c0;
    end for;

    for ram_d_pullups
      for pullup_b: pullup
        use configuration work.pullup_rtl_c0;
      end for;
    end for;

    for snespads_b: snespad
      use configuration work.snespad_struct_c0;
    end for;

  end for;

end b5_x300_ladybug_struct_c0;
