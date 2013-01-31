-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_generic_ram-c.vhd,v 1.3 2005/10/10 22:12:38 arnim Exp $
--
-------------------------------------------------------------------------------

configuration ladybug_generic_ram_altera_c0 of ladybug_generic_ram is

  for altera

    for ram_b : altsyncram
      use configuration work.altsyncram_struct_c0;
    end for;

  end for;

end ladybug_generic_ram_altera_c0;
