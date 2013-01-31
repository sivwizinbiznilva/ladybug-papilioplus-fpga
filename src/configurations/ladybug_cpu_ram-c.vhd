-------------------------------------------------------------------------------
--
-- FPGA Lady Bug
--
-- $Id: ladybug_cpu_ram-c.vhd,v 1.3 2005/11/06 15:43:17 arnim Exp $
--
-------------------------------------------------------------------------------

configuration ladybug_cpu_ram_struct_c0 of ladybug_cpu_ram is

  for struct

    for ram_4kx8_b: ram_4kx8
      use configuration work.ram_4kx8_c0;
    end for;

  end for;

end ladybug_cpu_ram_struct_c0;
