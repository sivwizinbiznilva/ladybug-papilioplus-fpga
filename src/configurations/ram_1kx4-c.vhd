-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ram_1kx4-c.vhd,v 1.3 2005/11/12 12:05:00 arnim Exp $
--
-------------------------------------------------------------------------------

configuration ram_1kx4_c0 of ram_1kx4 is

  for struct

    for ram_b : generic_ram
      use configuration work.generic_ram_rtl_c0;
    end for;

  end for;

end ram_1kx4_c0;
